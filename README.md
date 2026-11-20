# Content for the JoshLong.com blog

This repository holds the Markdown and HTML content that people [read on the blog](https://joshlong.com).

## Publishing a post

Add a file to `content/jl/blogPost/` with a header like this one, then `git commit` and `git push`.

```
title=My New Post
date=2026-11-20
type=post
tags=blog
status=published
~~~~~~

The post starts here.
```

Only posts with `status=published` show up on the site.
Images go in `content/media/`.

## How it gets to the site

There is no build in this repository.
A GitHub webhook on every push calls [`joshlong-api`](https://github.com/developer-advocacy/joshlong-api) at `https://api.joshlong.com/index`.
The API pulls this repository, rebuilds its index, and the site at joshlong.com renders the posts from the API.
The API also rebuilds once a day, in case a webhook is missed.

A post usually appears within a minute or so of the push.

## Not seeing your post?

* Check the webhook deliveries in this repository's settings, under `Webhooks`, for a `202`.
* Check that the header has a `date` and `status=published`, and the `~~~~~~` divider.
* Check the `joshlong-api` logs for `rebuilt the index for the webhook`.
