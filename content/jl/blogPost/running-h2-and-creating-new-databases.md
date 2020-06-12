title=Creating Databases with the New H2 Database Server 
date=2020-06-12
type=post
tags=blog
status=published
~~~~~~

You know what's super frustrating? The new default configuration [for H2 database](http://www.h2database.com/html/tutorial.html). I love H2 - it's a fast, convenient database. The latest version, however, will no longer automatically create a new database for you on your first attempt to connect and - even worse - it doesn't document particularly clearl what's required to create the database. I understand why they did this - it's better security - but I spent hours trying to get around it so I could use the darn thing at all. 

I use H2 from [Homebrew](https://brew.sh/): `brew install h2`. Disable this for now, if you have it: `brew services stop h2`. 

Then, download a distribution from the website. I'm using `h2-2019-10-14.zip`. Unzip it and then cd into the `bin` directory and run the following:

```
  java -cp h2*.jar org.h2.tools.Server -ifNotExists
```

This will allow you to run the database, create new Server-centric databases, etc. Then you can kill the instance and restart the Homebrew installed instance. You can point the H2 console to the existing H2 databasees that you created while you were running with `-ifNotExists`. That's the ticket. 

