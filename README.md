# Git Remote Add Multi

##### By Jeremy Carter _<_[jeremy@jeremycarter.ca](mailto:Jeremy%20Carter%20<jeremy@jeremycarter.ca>)_>_

## Git Remote Add Multi

Add a new git remote called "all" pointing at both the current origin remote, and a secondary remote to use as
a mirror. By default, if your origin remote isn't GitHub, then GitHub is used as the secondary remote, and it is
assumed to have the same repo owner and repo name as your origin remote. If your origin remote is GitHub, by
default it will use GitLab as the secondary remote. You can set a different secondary remote by passing a remote
url as the first command line argument if you want.

## Usage:

```shell
bash <(curl -sL https://tinyurl.com/git-remote-add-multi)
```

#### Optional: Set these environment variables to customize the behaviour, and pass an optional arg for secondary-git-url (defaults are as below):

```shell
GIT_REMOTE_NAME="all" bash <(curl -sL https://tinyurl.com/git-remote-add-multi) git@github.com:defcronyke/git-remote-add-multi.git
```

With the current settings (assuming origin remote is GitLab), these urls will be added to a new remote called "all"
if you run this command again in this repository with no arguments:

```shell
git@gitlab.com:defcronyke/git-remote-add-multi.git
git@github.com:defcronyke/git-remote-add-multi.git
```

## Get help:

```shell
bash <(curl -sL https://tinyurl.com/git-remote-add-multi) -h
```
