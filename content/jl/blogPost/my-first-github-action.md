title=My First Github Action Deployment 
date=2020-03-30
type=post
tags=blog
status=published
~~~~~~

There was a time when I would've defended Travis CI to anybody in a bar. It was a venerable piece of software that was free for open Github repositories and had reasonable integrations. I first learned about it in a tech talk being done at the Pivotal Labs San Francisco office at least five years ago. 

But there were issues. Slowly they settled in. First, the synchronization between Github and Travis CI started getting wonky. If I created a GH repository and then synchronized it with Travis, that would work, but I could also end up with an orphaned Travis CI repository if I change the GH repository's name, or delete it. There's no easy way to get rid of thee orphaned repositories. My Travis dashboards are littered with the ghosts of repositories past that I just can't seem to shake. 

There's also now the schism between http://Travis-CI.org and http://Travis-CI.com. I signed up for http://Travis-CI.com (the new hotness), but there's another fly in the ointment. I'm in the precarious situation where only the `.com` experience sees and synchronizes the new repository and the `.org` doesn't. Worse: the `.com` experience doesn't bring over the repositories from `.org`! SO, now I need two dashboards to see all the builds.

Then there's the limited integrations. It's been possible to use Docker in Travis for a while, and that largely obviates the need for integrations. I can use the _excellent_ [TestContainers](http://testcontainers.org) project to spin up darn near anything I need in my test pipeline. That said, it's a sort of bimodal world. Either you're using the default services and integrations out of the box, or you're plugging in a Docker image. It doesn't feel coherent. I like not having to spin up Docker containers. Getting my CI up and running is hard enough, and I don't particularly want to throw containers into the mix. 

I was thinking about going back to Jenkins. But, I'm a miser and I'm lazy. I didn't want to run my own installation to get access to the flexibility of a in-full-control installation, and I definitely didn't want to pay someone else to give that!  

Enter [Github Actions](http://github.com/actions). It's a general purpose workflow system that happens to be perfect for Continuous Integration use cases. Github Actions have a domain model sort of like Spring Batch's, actually. A workflow has jobs. Jobs have steps. Steps can be handled by various actions. Now, remember when I said I didn't want to deal with containers? I was wrong! Github Actions are container-centric. You can't help but bring containers into it. Each step usually has one, some, or all of the following elements: 

* a `name` that identifies the step.
* a `uses` element that specifies a container that.... _contains_ an action to execute. 
* a `run` element clause that executes arbitrary commands against a shell environment (like `bash`, `PowerShell`, `cmd.exe` and `Python`)
* a `with` element that defines input parameters that are passed into the action. 

Environment variables can be securely specified in the Github workspace `Settings` screen. Or, they can be specified inline in your Github Action file. Or some combination thereof. You can scope the environment variables to the whole workflow, to any of the subordinate jobs, or to any of their subordinate steps. You can cascade the environment variables too, so that more granular-scoped environment variables have priority over more global environment variables. 

You can decide what triggers the jobs; a push to a Github repository, a pull-request opened, a ticket filed, or even a CRON expression. Yep; you read that right: want to update your static-site every half an hour? Github pages can run the workflow to run the site-generation, and then host your website, entirely for free! How convenient! _Thanks_ Github! 

Now, let's talk about those actions. This is where the magic is. There are a _lot_ of actions out there provided not least of all [by Github](https://github.com/actions) but also [the community](https://github.com/marketplace?type=actions)! Their use is trivial and they do all sorts of things. 

Want to publish a [notification to Discord](https://github.com/marketplace/actions/actions-for-discord)? There's an action for that. Want to run [the Snyk CLI to do security audits on the code](https://github.com/marketplace/actions/snyk)? There's an action for that. Want to [cache build artifacts](https://github.com/marketplace/actions/cache) such as the artifacts downloaded into `~/.m2/repository`? There's an action for that. Want to build your code with Apache Maven, Pipenv, Composer, Rust, Gradle, YARN, etc.? If the relevant CLIs aren't already installed on the operating system of the container that's running your application, then, of course, there are actions for that! Want to build your static site using Hugo or Jekyll? There are actions for that. Create an event using Micorosft Graph? Want to run Helm? Run Rubocop, PHP Lint, ESLint, Pyflakes, etc. There are actions for that. Integrate DataDog monitoring? There's an action for that. Notify Slack or Telegram users?  There... well, you _get the idea_, surely.

The number of easy-to-integrate integrations are positively _mouth-watering_! So, I was sold. I've got a _lot_ of code that I update rarely, and _really_ need automated and reliable deployment pipelines.

So, I took one project and tried to establish a Github Action. It's a bit more verbse than the equivalent Travis CI build, but approachable and repeatable. 

Here's [the original file](https://github.com/this-week-in/twitter-pinboard-cleanup-job/blob/master/.github/workflows/blank.yml) in its Githubb-y glory. And here is is reprinted in its entirety.

```yml
# Build the Twitter Pinboard Cleanup Job
# https://help.github.com/en/actions/configuring-and-managing-workflows/creating-and-storing-encrypted-secrets

name: CI

env:
  TWITTER_TWI_CLIENT_KEY: ${{ secrets.TWITTER_TWI_CLIENT_KEY }}
  TWITTER_TWI_CLIENT_KEY_SECRET: ${{ secrets.TWITTER_TWI_CLIENT_KEY_SECRET }}
  PINBOARD_TOKEN: ${{ secrets.PINBOARD_TOKEN }}
  CF_USER: ${{ secrets.CF_USER }}
  CF_PASSWORD: ${{ secrets.CF_PASSWORD }}
  CF_SPACE: ${{ secrets.CF_SPACE }}
  CF_API: ${{ secrets.CF_API }}
  CF_ORG: ${{ secrets.CF_ORG  }}
  ARTIFACTORY_USERNAME: ${{ secrets.ARTIFACTORY_USERNAME  }}
  ARTIFACTORY_PASSWORD: ${{ secrets.ARTIFACTORY_PASSWORD  }}

on:
  push:
    branches: [ master ]
  pull_request:
    branches: [ master ]

jobs:

  build:
    runs-on: ubuntu-latest
    steps:

      - uses: actions/checkout@v2

      - name: Set up JDK 13
        uses: actions/setup-java@v1
        with:
          java-version: 13

      - name: Cache Maven packages
        uses: actions/cache@v1
        with:
          path: ~/.m2/repository
          key: ${{ runner.os }}-m2
          restore-keys: ${{ runner.os }}-m2

      - name: Build with Maven
        run: mvn -B deploy --file pom.xml

      - name: Deploy to Cloud Foundry
        run: |
          cd $GITHUB_WORKSPACE
          ./deploy/cf.sh
          ./deploy/deploy.sh
```


I don't purport to have understood everything about Github Actions, but I'm already a lot further along the path to being able to move dozens of builds over tomorrow fairly quickly. I miss Travis CI. It got me through a _lot_ of builds, and I couldn't be more grateful for that. Thanks Travis CI. I am spoilt to still not have to figure out how to build applications. Thanks, Github.


