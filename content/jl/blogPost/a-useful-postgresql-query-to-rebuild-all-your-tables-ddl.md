title=A SQL query to re-create your PostgreSQL database tables' DDL
date=2025-12-25
type=post
tags=blog
status=published
~~~~~~


Hi! It's Christmas as I write this and in many parts of the world and to those of you who celebrate, let me wish you a very merry Christmas indeed! 

In today's post I wanted to quickly note a _very_ handy SQL query that I had some AI help me write to generate the DDL for all the tables in a PostgreSQL schema.

Put the following in a file called `query.sql`:

```sql
SELECT
    'CREATE TABLE ' || table_name || ' (' || chr(10) ||
    string_agg(
        '  ' || column_name || ' ' ||
        CASE
            WHEN data_type = 'character varying' THEN 'VARCHAR(' || character_maximum_length || ')'
            WHEN data_type = 'numeric' THEN 'NUMERIC(' || numeric_precision || ',' || numeric_scale || ')'
            ELSE UPPER(data_type)
        END ||
        CASE WHEN is_nullable = 'NO' THEN ' NOT NULL' ELSE '' END ||
        CASE WHEN column_default IS NOT NULL THEN ' DEFAULT ' || column_default ELSE '' END,
        ',' || chr(10)
    ) || chr(10) || ');' AS ddl
FROM information_schema.columns
WHERE table_schema = 'public'
GROUP BY table_name
ORDER BY table_name;
```

You can then pipe it to your database with the handy `psql` command and it'll print all the DDL for the tables themselves. Why would you want this? _Lots_ of reasons! ..Most of which have to do with a lack of discipline around using gitops around database table creation and migration. Let's say you chance upon an environment where tables have evolved organically, on the one _blessed_ instance, and you want to start version controlling it or something. 

```shell
#!/usr/bin/env bash

cat query.sql |  PGPASSWORD=YOUR_PASSWORD psql -U YOUR_USER -h YOUR_HOST YOUR_DB -t -A
```

It works! Are there better tools? Yes. But this is pretty neat if you ask me.
