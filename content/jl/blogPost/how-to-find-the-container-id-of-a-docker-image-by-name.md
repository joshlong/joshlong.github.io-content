title=How to find a Docker container's ID, filtering by the container's name
date=2023-07-27
type=post
tags=blog
status=published
~~~~~~

I know this should probably be common knowledge, but I always want to find a way to do this, and always find it, and then forget it, and the cycle continues. 

So, if you want to find a running Docker image named `bootifulmongo`, and get its container ID as the output, then run:

```shell
docker ps -aqf name=bootifulmongo
```

You could of course very usefully script its execution by storing the output as a variable: 

```shell
CONTAINER_ID=`docker ps -aqf name=bootifulmongo`
echo "the container ID is ${CONTAINER_ID}."
```
