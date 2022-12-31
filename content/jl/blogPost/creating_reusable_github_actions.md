title=Creating Reusable Github Actions (for the new edition of my book, "Reactive Spring")
date=2022-12-30
type=post
tags=blog
status=published
~~~~~~


I know, I know. I'm late to the game on this one. But I just, _just_ found a usecase that - absent pressing deadlines and piling work items  - I felt like I could invest time in addressing: how to consolidate and reuse my Github Actions build logic. 

You see, I wrote a book [_The Reactive Spring Boot_](https://reactivespring.io/). It was published in 2020. It in turn has a lot of code, one Github repository per chapter, over on the [_Reactive Spring_ Github organization - `reactive-spring-book`](https://github.com/reactive-spring-book). 


I want to consolidate the Github Actions pipelines for each chapter since, by and large, the pipelines are the same. 


There are two ways to solve this: composable Github Actions or reusable Github Actions. They each have their own unique pros and cons that [I think this article](https://github.blog/2022-02-10-using-reusable-workflows-github-actions/) explains rather well. Reusable Github Actions, which we'll look at in this blog, didn't exist when I first wrote the book. Reusable Github Actions were [released in 2021](https://github.blog/2021-11-29-github-actions-reusable-workflows-is-generally-available/). 

The idea is simple: you have a Github  Action that _uses_ (invokes, calls, whatever) another. 


I like them because they offer me the following benefits:

* I can use a Github Action with its own steps
* I can automatically pass in the secrets that are accessible to my calling Github Action. 

It's like an include file for your pipelines. Short and sweet. 

Alrighty, let's dive into it. I've got a Github Action that I want to be run on all Github Actions. I've stashed this in `reactive-spring-book/actions/.github/workflows/default-flow.yml`. Here's what it looks like today, late 2022:


```yaml
name: reusable workflow for Reactive Spring Book chapter code

env:

  ARTIFACTORY_USERNAME: ${{ secrets.ARTIFACTORY_USERNAME }}
  ARTIFACTORY_PASSWORD: ${{ secrets.ARTIFACTORY_PASSWORD }}

  SPRING_PROFILES_ACTIVE: ci

  GH_PAT: ${{ secrets.GH_PAT }}
  
  PIPELINE_ORG_NAME: reactive-spring-book
  PIPELINE_REPO_NAME: pipeline
  
on:
  workflow_call:

jobs:
  build-and-publish:

    permissions:
      contents: 'read'
      id-token: 'write'

    name: Build and Publish 

    runs-on: ubuntu-latest

    steps:

      - uses: actions/checkout@v3

      - name: Cache local Maven repository
        uses: actions/cache@v3
        with:
          path: ~/.m2/repository
          key: ${{ runner.os }}-maven-${{ hashFiles('**/pom.xml') }}
          restore-keys: |
            ${{ runner.os }}-maven-            

      - uses: joshlong/java-version-export-github-action@v20

      - uses: actions/setup-java@v3
        with:
          distribution: 'adopt'
          cache: 'maven'
          java-version: ${{ env.JAVA_MAJOR_VERSION }}

      - run: echo "using $JAVA_MAJOR_VERSION"

      - name: Build
        run: ls -la $GITHUB_WORKSPACE/.github/workflows/build.sh && $GITHUB_WORKSPACE/.github/workflows/build.sh || exit 1 

      - name: Initiate Pipeline
        run: |
          curl -H "Accept: application/vnd.github.everest-preview+json" -H "Authorization: token ${GH_PAT}"  --request POST  \
              --data '{"event_type": "update-code-event" }' https://api.github.com/repos/${PIPELINE_ORG_NAME}/${PIPELINE_REPO_NAME}/dispatches

```


Easy! If you know Github Actions then all of this should be easy enough to grok. The only thing worth noting, the only standout thing that you need to know to appreciate that this is intended for reuse, is the new trigger:

```yaml
...
on:
  workflow_call:
...
```

That's it! Otherwise, it's exactly  the Github Action I would've copy-and-pasted into each of the repositories! 

From the calling side, I have a Github Action like this:

```yaml
name: Chapter Build 

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  chapter:
    uses: reactive-spring-book/actions/.github/workflows/default-flow.yml@main
    secrets: inherit

```

The build specifies some triggers and then almost immediately `uses` the reusable Github Action we just created. The important part, for me, was `secrets: inherits`, which lets the Github Action I am invoking _see_ the secrets in my environment. 

Remember: do _not_ do this for Github Actions you didn't write or trust or have control over, unless you trust them _implicitly_. They'll be able to read and do goodness knows what with your secrets. They could record them and mail them to somebody or post them on Reddit or login to your system and ransom your machines or whatever other ungodly thing! DO NOT do this unlesss you trust the action you're invoking! There's an alternative syntax whereby you can selectively stipulate which secrets to make available to the Github Action you're invoking. Do that if there's any doubt whatsoever. 

I wrote this Github Action, I trust it, and I know it's not going to compromise my systems -  well, no more than if I had copy-and-pasted it into each Git repository's Github Actions definition, anyway! 

Anyway, that's all! It just works from there. If I make a change to the test repository, it runs the reusable action as though I had copy-and-pasted the definition into my build: the Action has access to all my code, the same working directories, secrets, etc. It's fantastic. I have a convention where I expect each chapter to do whatever it needs to do to build, package, and test the code in a `.github/workflows/build.sh` script. Any build without that will fail. I can change the version of the Github Actions I use in my Github Actions, and they're changed for every pipeline that uses it. I love this!

Thanks Github Actions.

