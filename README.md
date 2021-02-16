# Git Remote Add Multi

##### by Jeremy Carter _<_jeremy@jeremycarter.ca_>\_

## Git Remote Add Multi

Add a new git remote called "all" pointing at both the current origin remote, and a secondary remote to use as
a mirror. By default, if your origin remote isn't GitHub, then GitHub is used as the secondary remote, and it is
assumed to have the same repo owner and repo name as your origin remote. If your origin remote is GitHub, by
default it will use GitLab as the secondary remote. You can set a different secondary remote by passing a remote
url as the first command line argument if you want.

## Usage:

```shell
bash <(curl -sL https://tinyurl.com/git-remote-add-multi) [$GIT_REMOTE2]
```

#### Optional: Set these environment variables to customize the behaviour (defaults are as below):

```shell
GIT_REMOTE_NAME="all"
GIT_REMOTE_EXT=".git"
GIT_REMOTE1="git@gitlab.com:"
GIT_REMOTE2="git@github.com:"
GIT_REPO_OWNER="defcronyke"
GIT_REPO_NAME="git-remote-add-multi"
```

With the current settings, these urls will be added to a new remote called "all"
if you run this command again with no arguments:

```shell
git@gitlab.com:defcronyke/git-remote-add-multi.git
git@github.com:defcronyke/git-remote-add-multi.git
```
