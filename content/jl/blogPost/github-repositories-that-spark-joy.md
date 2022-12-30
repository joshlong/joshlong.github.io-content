title=A Github profile that sparks joy
date=2022-12-30
type=post
tags=blog
status=published
~~~~~~

Happy new year! The world is about to ring in a new year, and with it comes a chance to reflect, to prioritize, to _clean_. My Github repositories were proliferating like rabbits! It was getting out of hand, and something needed to be done!

<img width="100%" src = "https://pbs.twimg.com/media/FlLXjnnaMAAry2y?format=jpg&name=4096x4096" />

You know, I use Github a _lot_. I love Github. I feel like they love me, too. Either way, I love them. I use it a _lot_. Waaay too much. I've got more than a thousand repositories across dozens of Github organizations, partly because of my contributions to other Github organizations and partly because I created my own to solve some sort of particular problem. Heck, I created a few organizations just to house the demo code for some book and course content I've authored! In part because I'm so prolific at shows, I've got 8.3k followers on Github. Who knew _that_ was a metric? Apparently, that's a lot. All that to say, I use and abuse Github a lot and people seem to take note, but I think I could do a lot better. I had countless Github repositories laying around, abandoned, rejected, ephemeral. A lot of these repositories were just created to triage a bug or sketch out an idea. A lot of them were created for a particular version of a talk that I haven't given since. Whatever the reason, these things were piling up! 

It's the holidays, the perfect time to take stock and get ready for the next year. I've been updating a _lot_ of code to use new Github Actions, to use the latest-and-greatest Spring Boot 3.x release, to use the latest-and-greatest Kubernetes CRDs, etc. I also wanted to clean up my profile. I created a new Github Organization [called `joshlong-attic`](https://github.com/joshlong-attic). Great so I had a place to put the repositories, out of sight, out of mind. But how do I get them there? Github supports transferring a repository to another organization or another owner altogether, but it involves a lot of clicking, and I was hoping to move more than 500 repositories, so this didn't seem viable. Some sort of automation is required. Github even has an HTTP API I could manipulate.

I could write a full HTTP client program that authenticates and works with data and the like. But that sounded suspiciously like work, and I already had enough of that! I wanted to get this show on the road. So I found a `curl` snippet that would do the work for me. So I met myself in the middle: I [wrote a program](https://github.com/joshlong-attic/joshlong-attic-migration/blob/main/main.py) that printed permutations of this `curl` command for every repository I wanted to transfer. Here's the Python code:

```python
#!/usr/bin/env python
import os

# https://docs.github.com/en/rest/repos/repos?apiVersion=2022-11-28#transfer-a-repository

repos = [ 
	# the string names of more than 500 repositories goes here
	'test',
	'foo',
	'bar'
]

if __name__ == '__main__':

    def transfer(gh_pat: str, repo: str):
        repo = repo.strip()
        cmd = '''
        curl -X POST -H "Accept: application/vnd.github+json"  -H "Authorization: Bearer %s" -H "X-GitHub-Api-Version: 2022-11-28"  https://api.github.com/repos/joshlong/%s/transfer  -d '{"new_owner":"joshlong-attic", "new_name":"%s"}'
        ''' % (gh_pat, repo, repo)
        return cmd.strip()


    gh_pat = os.environ['GH_PAT']
    assert gh_pat is not None, 'you must specify a github personal access token'
    cmds = [transfer(gh_pat, repo) for repo in repos]
    print(os.linesep.join(cmds))
```

I saved this as `main.py` and ran this script: 


```shell
pipenv run python main.py > commands.sh 
```

The file, `commands.sh`, is what I actually need to run. It expects that I've got an environment variable, `GH_PAT`, with a [valid Github Personal Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token). 

I made `commands.sh` executable: 

```shell
chmod a+x commands.sh
```

Then executed it: 


```shell
./commands.sh
```

Then stood back. It took a minute or two, but by the end of it my Github Profile was _much_ more navigable! Thanks Github. 



 
