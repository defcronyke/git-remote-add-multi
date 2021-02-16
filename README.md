# Git Remote Add Multi

```shell
$ bash <(curl -sL https://tinyurl.com/git-remote-add-multi) -h

Add a new git remote called "all" pointing at both gitlab (primary) and github (secondary).

usage: bash <(curl -sL https://tinyurl.com/git-remote-add-multi) [$GIT_REPO_NAME] [$GIT_REPO_OWNER]

Optional: Set these environment variables to customize the behaviour (defaults are as below):

GIT_REMOTE_NAME=all
GIT_REMOTE_EXT=.git
GIT_REMOTE1=git@gitlab.com:
GIT_REMOTE2=git@github.com:
GIT_REPO_OWNER=defcronyke
GIT_REPO_NAME=git-remote-add-multi

With the current settings, these urls will be added to a new remote called "all"
if you run this command again with no arguments:

git@gitlab.com:defcronyke/git-remote-add-multi.git
git@github.com:defcronyke/git-remote-add-multi.git
```
