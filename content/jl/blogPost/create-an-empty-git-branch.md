title=Create a new Git branch with no history
date=2022-12-31
type=post
tags=blog
status=published
~~~~~~

Sometimes you just want to have a fresh workspace in which to imagine, but don't want to trample or even fuss with existing code. And, logically, it'd be nice if this sketch code could live _near_ the code it will eventually replace. Say, on a branch in that same codebase. Wouldn't that be nice? That'd be nice. And saints be praised it turns out there's a way to do it! 

Normally, I just create a branch, `rm -rf ` everything in the directory, and then push that. Don't do that. 

Do this: 

```shell
git switch --orphan <new branch>
git commit --allow-empty -m "Initial commit on orphan branch"
git push -u origin <new branch>
```

Thanks, [StackOverflow](https://stackoverflow.com/questions/34100048/create-empty-branch-on-github)!

Also, Happy New Year!
