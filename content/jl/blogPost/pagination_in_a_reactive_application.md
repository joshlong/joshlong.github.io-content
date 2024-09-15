title=Pagination in a Reactive Application
date=2022-07-06
type=post
tags=blog
status=published
~~~~~~


Suppose you're working with a REST API that produces pages of data capped at, let's suppose, 50 records per fetch. Each batch of 50 comes with a `nextPageToken`, that can be used to fetch the next batch of results. So, you call the service the first time with no `nextPageToken`, and you're given the first batch of results. Call it again with the `nextPageToken` that came with the first batch and you'll get the second page of results. Call it again with the `nextPageToken` that came with the second batch and you'll get the third page of results. You see? One page depends on the previous one. 

We can't resolve, or even define the pipeline to resolve, the second batch without first resolving the first batch. This is a common thing in all sorts of scenarios, be they data access, RPC or REST services, in-memory but asynchronous communications, etc. In this blog, we're going to look at a simple way to solve this problem using operators built right into the `Flux<T>` and `Mono<T>` operators [in Project Reactor](https://ProjectReactor.io): `expand`.


Let's look at an example.   I'm working with the YouTube API and I want to query all the videos associated with a given YouTube playlist, represented by a `Playlist` object. The trouble is that you can't get all the individual items associated with a `Playlist` if there are more than 50 of them. If you exceed 50, you need to start   _paging_ - to go through the results one batch at a time. I've got an aggregate to keep each paged batch of results I've taken to calling `PlaylistVideos`. 





```java
 record PlaylistVideos(String playlistId,
 	 Collection<Video> videos, String nextPageToken, String previousPageToken,
                      int resultsPerPage, int totalResults) {
}

```


I want to end up with a `Flux<Video>`, containing all the `Video`s in each of the `PlaylistVideos`.  We want to basically _add_ to a `Flux<T>` at runtime, based on the state of earlier data in the same `Flux<T>`. Thankfully, this is trivial to do with the recursive `expand` operator: 

```java

	Flux<Video> getAllVideosByPlaylist(String playlistId) {
		Flux<PlaylistVideos> expanded = getVideosByPlaylist(playlistId, null)//
				.expand(playlistVideos -> {
					var nextPageToken = playlistVideos.nextPageToken();
					if (!StringUtils.hasText(nextPageToken)) {
						return Mono.empty();
					}
					else {
						return getVideosByPlaylist(playlistId, nextPageToken);
					}
				});
		return expanded
			.flatMap(plv->Flux.fromIterable(plv.videos()));
	}

```

Here, we look up the first page of results. Then `expand` it. In the `expand` operator, we are able to look at the existing state of the `Publisher<T>` before deciding to add to it (by returning another `Publisher<T>`) or to terminate, by returning a `Mono.empty()`. 

Once that's done, I end up with a stream of `PlaylistVideos` whose `videos` I flat map into one stream, a view on the underlying `PlaylistVideos`.
