title=Building a Hybrid Search Engine with JDBC and PostgreSQL
date=2026-01-11
type=post
tags=blog
status=published
~~~~~~

When building modern search functionality, developers often reach for specialized search engines like Elasticsearch or Solr. But what if you could build a sophisticated, production-grade search engine using just JDBC and PostgreSQL? This article explores a fascinating implementation that combines vector embeddings, full-text search, and fuzzy matching—all powered by PostgreSQL's rich ecosystem of extensions.

## Architecture Overview

At its core, this search implementation consists of three main components:

1. **Document Management**: Ingesting and chunking documents for efficient searching
2. **Hybrid Search**: Combining multiple search strategies for better results
3. **Service Layer**: Integrating search with domain entities through a clean abstraction

## The Foundation: PostgreSQL Extensions

The magic starts with three PostgreSQL extensions that transform a standard database into a powerful search platform:

```sql
CREATE EXTENSION IF NOT EXISTS vector;
CREATE EXTENSION IF NOT EXISTS pg_trgm;
```

- **pgvector**: Enables storage and similarity search of vector embeddings
- **pg_trgm**: Provides trigram-based fuzzy text matching
- **Built-in FTS**: PostgreSQL's native full-text search capabilities

## Database Schema Design

The schema elegantly separates documents from their searchable chunks:

```sql
CREATE TABLE document (
    id          serial primary key,
    source_type TEXT,
    source_uri  TEXT,
    title       TEXT,
    created_at  TIMESTAMPTZ DEFAULT now(),
    raw_text    TEXT,
    metadata    JSONB NOT NULL DEFAULT '{}'
);

CREATE TABLE document_chunk (
    id          BIGSERIAL PRIMARY KEY,
    document_id BIGINT NOT NULL REFERENCES document (id) ON DELETE CASCADE,
    chunk_index INT    NOT NULL,
    text        TEXT   NOT NULL,
    tsv         TSVECTOR,
    embedding   VECTOR(1536),
    clean_text  TEXT   NOT NULL,
    tokens      TEXT[] NOT NULL DEFAULT ARRAY[]::TEXT[]
);
```

Each document is split into overlapping chunks, with each chunk containing:
- The raw text
- A vector embedding (1536 dimensions, typical for OpenAI embeddings)
- A tsvector for full-text search
- Cleaned text and token arrays for fuzzy matching

### Automatic Index Maintenance with Triggers

PostgreSQL triggers automatically maintain search indexes whenever data changes:

```sql
CREATE OR REPLACE FUNCTION chunk_tsv_trigger()
    RETURNS TRIGGER AS
$$
BEGIN
    NEW.tsv := to_tsvector('english', NEW.text);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER chunk_tsv_update
    BEFORE INSERT OR UPDATE ON document_chunk
    FOR EACH ROW
EXECUTE PROCEDURE chunk_tsv_trigger();
```

This ensures the full-text search vector stays synchronized with the text content without any application-level maintenance.

## Document Chunking Strategy

The chunking algorithm is deceptively simple but highly effective:

```java
private List<String> chunk(String text, int tokensPerChunk, double overlap) {
    if (text == null || text.isBlank()) {
        return List.of();
    }

    var words = text.split("\\s+");
    var step = (int) (tokensPerChunk * (1 - overlap));
    var chunks = new ArrayList<String>();

    for (var i = 0; i < words.length; i += step) {
        var end = Math.min(words.length, i + tokensPerChunk);
        chunks.add(String.join(" ", Arrays.copyOfRange(words, i, end)));
    }
    return chunks;
}
```

The implementation uses:
- **800 tokens per chunk**: Large enough for context, small enough for focused matching
- **15% overlap**: Ensures important content isn't lost at chunk boundaries

By overlapping chunks, we avoid the "split sentence" problem where critical information straddles chunk boundaries.

## The Ingestion Pipeline

When a document is indexed, the system performs several operations atomically:

```java
Document ingest(String title, String fullText, Map<String, Object> metadata) {
    // Combine title and text for better search context
    fullText = title + " " + fullText;

    // Generate a unique key from metadata for deduplication
    var key = this.keyFor(metadata);

    // Remove existing documents with the same key
    var allExistingDocuments = this.jdbcClient
        .sql("select id from document where key = ? ")
        .params(key)
        .query((RowMapper<Number>) (rs, rowNum) -> rs.getLong(1))
        .list();

    if (!allExistingDocuments.isEmpty()) {
        this.jdbcClient.sql("delete from document where key = ? ")
            .params(key).update();
    }

    // Create document chunks
    var chunks = this.chunk(fullText, 800, 0.15);

    // Insert document
    var gkh = new GeneratedKeyHolder();
    this.jdbcClient
        .sql("""
            INSERT INTO document(key, source_uri, title, created_at, raw_text, metadata)
            VALUES (?, ?, ?, ?, ?, ?::jsonb)
            returning id
        """)
        .params(key, "text", title, new Date(), fullText, JsonUtils.write(metadata))
        .update(gkh);

    var documentId = ((Integer) Objects.requireNonNull(gkh.getKeys())
        .values().iterator().next()).longValue();

    // Generate and store embeddings for each chunk
    for (var i = 0; i < chunks.size(); i++) {
        var chunkText = chunks.get(i);
        var resp = this.embeddingModel.embed(chunkText);

        this.jdbcClient
            .sql("""
                INSERT INTO document_chunk(document_id, chunk_index, text, embedding)
                VALUES (?, ?, ?, ?)
            """)
            .params(documentId, i, chunkText, new PGvector(resp))
            .update();
    }

    return this.documentById(documentId);
}
```

The ingestion process:
1. Deduplicates based on metadata keys
2. Chunks the text with overlap
3. Generates vector embeddings for each chunk using Spring AI's `EmbeddingModel`
4. Stores everything atomically in a transaction

## Hybrid Search: The Best of All Worlds

The real power lies in the hybrid search strategy that combines three complementary approaches:

### Phase 1: Hybrid Vector + Full-Text Search

```java
var sql = """
    WITH fts AS (
        SELECT id, ts_rank(tsv, plainto_tsquery('english', ?)) AS fts_score
        FROM document_chunk
        WHERE tsv @@ plainto_tsquery('english', ?)
    )
    SELECT dc.document_id as document_id,
           dc.id,
           dc.text,
           (1 - (dc.embedding <=> CAST(? AS vector))) AS vec_score,
           f.fts_score,
           0.7*(1 - (dc.embedding <=> CAST(? AS vector))) + 0.3 * f.fts_score AS score
    FROM fts f
    JOIN document_chunk dc ON f.id = dc.id
    ORDER BY score DESC
    LIMIT 20
    """;
```

This query is elegant in its sophistication:

1. **Full-Text Prefilter**: The CTE filters chunks using PostgreSQL's text search (`@@` operator)
2. **Vector Similarity**: Computes cosine distance between query and chunk embeddings
3. **Weighted Combination**: Merges scores with 70% weight on vector similarity, 30% on full-text rank
4. **Performance**: Only computes expensive vector similarity for FTS matches

The `<=>` operator is pgvector's cosine distance operator. Converting it to similarity with `(1 - distance)` gives us a score where higher is better.

### Phase 2: Fuzzy Fallback Search

When the hybrid search returns no results (perhaps due to typos or terminology mismatches), the system falls back to trigram fuzzy matching:

```java
if (results.isEmpty()) {
    var fuzzySql = """
        SELECT document_id, id, text,
               (
                   SELECT MAX(similarity(w, ?))
                   FROM unnest(tokens) AS w
               ) AS score
        FROM document_chunk
        WHERE (
           SELECT MAX(similarity(w, ?))
           FROM unnest(tokens) AS w
        ) > 0.20
        ORDER BY score DESC
        LIMIT 20
        """;
    results = jdbcClient
        .sql(fuzzySql)
        .params(query, query)
        .query(this.searchHitRowMapper)
        .list();
}
```

This fuzzy search:
- Tokenizes chunks into individual words (stored in the `tokens` array)
- Computes trigram similarity between the query and each token
- Returns chunks where the best token match exceeds a 0.20 threshold
- Handles misspellings, partial matches, and similar terms

### Metadata Filtering

The system supports filtering by metadata using PostgreSQL's JSONB containment operator:

```java
var metadataSql = hasMetadata ?
    """
        JOIN document d ON dc.document_id = d.id
        WHERE d.metadata @> ?::jsonb
    """ : "";
```

The `@>` operator checks if the left JSONB contains the right JSONB, enabling queries like "find all podcast transcripts" or "search only blog posts from 2024."

## Domain Integration: The Service Layer

The `JdbcSearchService` bridges the low-level index with domain entities:

```java
@Override
public <T extends Searchable> void index(T searchable) {
    var searchableId = searchable.searchableId();
    var clzz = keyFor(searchable.getClass());
    var repo = repositoryFor(searchable.getClass());

    var result = repo.result(searchableId);
    var textForSearchable = result.text();
    var titleForSearchable = result.title();

    if (StringUtils.hasText(textForSearchable) &&
        StringUtils.hasText(titleForSearchable)) {
        this.index.ingest(titleForSearchable, textForSearchable,
            Map.of(KEY, searchableId, CLASS, clzz));
    }
}
```

This abstraction:
- Works with any `Searchable` entity through a repository pattern
- Stores entity metadata for later retrieval
- Maintains the connection between search results and domain objects

### Search Result Assembly

When searching, the service reconstructs domain objects from index hits:

```java
@Override
public Collection<RankedSearchResult> search(String query, Map<String, Object> metadata) {
    var results = new LinkedHashSet<RankedSearchResult>();
    var all = this.index.search(query, metadata);
    all.sort(Comparator.comparing(IndexHit::score));

    for (var hit : all) {
        var documentChunk = hit.documentChunk();
        var document = this.index.documentById(documentChunk.documentId());
        var resultMetadata = document.metadata();

        // Extract entity information from metadata
        var clzz = (String) resultMetadata.get(CLASS);
        var clzzObj = ReflectionUtils.classForName(clzz);
        var searchableId = ((Number) resultMetadata.get(KEY)).longValue();

        // Retrieve the actual domain object
        var repo = this.repositoryFor(clzzObj);
        var result = repo.result(searchableId);

        results.add(new RankedSearchResult(
            searchableId, result.aggregate().id(),
            result.title(), result.text(),
            resultName(clzzObj), hit.score()
        ));
    }

    return this.dedupeBySearchableAndType(results);
}
```

The deduplication step ensures that when multiple chunks from the same document match, only the highest-scoring result is returned.

## Event-Driven Indexing

The system integrates with Spring Modulith for reactive indexing:

```java
@ApplicationModuleListener
void indexForSearchOnTranscriptCompletion(TranscriptRecordedEvent event) {
    var aClazz = (Class<? extends Transcribable>) event.type();
    var repo = this.repositoryFor(aClazz);
    var transcribable = repo.find(event.transcribableId());

    this.log.info("indexing for search transcribable ID {}",
        event.transcribableId());
    this.index(transcribable);
}
```

When a transcript is recorded, the entity is automatically indexed for search—demonstrating how search can seamlessly integrate into event-driven architectures.

## Performance Optimizations

The implementation includes several thoughtful optimizations:

### Caching Strategy

```java
Index(JdbcClient jdbc, EmbeddingModel embeddingModel, ...,
      Cache documentsCache, Cache documentChunksCache) {
    this.documentsCache = documentsCache;
    this.documentChunksCache = documentChunksCache;
}

protected List<DocumentChunk> documentChunks(Long documentId) {
    return this.documentChunksCache.get(documentId, () ->
        jdbcClient
            .sql("select dc.* from document_chunk dc where dc.document_id = ?")
            .params(documentId)
            .query(this.documentChunkRowMapper)
            .list()
    );
}
```

Caches reduce database hits for frequently accessed documents and chunks.

### Database Indexes

```sql
-- Full-text search index
CREATE INDEX idx_document_chunk_tsv ON document_chunk USING GIN (tsv);

-- Trigram search index
CREATE INDEX idx_document_chunk_text_trgm ON document_chunk USING GIN (text gin_trgm_ops);

-- Metadata filtering index
CREATE INDEX idx_document_metadata ON document USING GIN (metadata);
```

GIN (Generalized Inverted Index) indexes make text search and JSONB queries blazingly fast.

## Why This Approach Works

This JDBC-based search implementation demonstrates several advantages:

1. **Simplicity**: No separate search infrastructure to maintain
2. **Transactional Consistency**: Search updates happen in the same transaction as data changes
3. **Rich Querying**: Metadata filtering, fuzzy matching, and semantic search in one place
4. **Cost-Effective**: Leverages existing PostgreSQL infrastructure
5. **Hybrid Power**: Combines semantic understanding (vectors) with exact matching (FTS) and fuzzy tolerance (trigrams)

The three-tiered search strategy ensures robust results:
- Semantic matches for conceptual similarity
- Full-text matches for exact terms
- Fuzzy matches for typo-tolerance

## Trade-offs and Considerations

While powerful, this approach has limitations:

- **Embedding Generation**: Requires an external API (OpenAI, etc.) for vector generation
- **Scale**: May require tuning for very large datasets (millions of chunks)
- **Vector Dimensions**: 1536 dimensions consume significant storage
- **Cold Start**: Initial indexing of large corpora can be time-consuming

## Conclusion

This implementation showcases PostgreSQL's evolution from a traditional RDBMS to a multi-modal database capable of sophisticated search workloads. By combining pgvector, full-text search, and trigram matching with clean abstractions, it delivers production-grade search functionality without the operational complexity of dedicated search engines.

The hybrid approach is particularly elegant: it uses cheap full-text search to filter candidates, then applies expensive vector comparisons only to promising matches, finally falling back to fuzzy search when needed. This multi-layered strategy ensures both performance and result quality.

For applications already using PostgreSQL, this pattern offers a compelling alternative to introducing separate search infrastructure—proving that sometimes the best tool for the job is the one you already have.



*The complete implementation includes Spring Boot configuration, domain abstractions, and row mappers that weren't covered in detail here. The key insight is that modern PostgreSQL, with its extension ecosystem, can serve as a powerful foundation for semantic search applications.*
