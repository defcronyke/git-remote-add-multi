#!/bin/bash -e

git_remote_add_multi_usage() {
	echo ""
	echo "Git Remote Add Multi"
	echo ""
	echo "by Jeremy Carter <jeremy@jeremycarter.ca>"
	echo ""
	echo "Add a new git remote called \"all\" pointing at both the current origin remote, and a secondary remote to use as"
	echo "a mirror. By default, if your origin remote isn't GitHub, then GitHub is used as the secondary remote, and it is"
	echo "assumed to have the same repo owner and repo name as your origin remote. If your origin remote is GitHub, by"
	echo "default it will use GitLab as the secondary remote. You can set a different secondary remote by passing a remote"
	echo "url as the first command line argument if you want."
	echo ""
	echo "usage: bash <(curl -sL https://tinyurl.com/git-remote-add-multi) [\$GIT_REMOTE2]"
	echo ""
	echo "Optional: Set these environment variables to customize the behaviour (defaults are as below):"
	echo ""
	echo "GIT_REMOTE_NAME=${GIT_REMOTE_NAME}"
	echo "GIT_REMOTE_EXT=${GIT_REMOTE_EXT}"
	echo "GIT_REMOTE1=${GIT_REMOTE1}"
	echo "GIT_REMOTE2=${GIT_REMOTE2}"
	echo "GIT_REPO_OWNER=${GIT_REPO_OWNER}"
	echo "GIT_REPO_NAME=${GIT_REPO_NAME}"
	echo ""
	echo "With the current settings, these urls will be added to a new remote called \"$GIT_REMOTE_NAME\""
	echo "if you run this command again with no arguments:"
	echo ""
	echo "${GIT_REMOTE1}${GIT_REPO_OWNER}/${GIT_REPO_NAME}${GIT_REMOTE_EXT}"
	echo "${GIT_REMOTE2}${GIT_REPO_OWNER}/${GIT_REPO_NAME}${GIT_REMOTE_EXT}"
        echo ""
	
	return 1
}

git_remote_add_multi_swap() {
	if [ $# -ne 3 ]; then
		echo "error: git_remote_swap needs 3 args: <target> <swap-1> <swap-2>"
		return 3
	fi

	if [ "$1" == "$2" ]; then 
		echo "$3"
	else 
		echo "$2"
	fi
}

git_remote_add_multi() {
	set +e
	git remote get-url origin >/dev/null
	if [ $? -ne 0 ]; then
		echo ""
		echo "error: You need to set an 'origin' git remote first. Use this command to do it:"
		echo ""
		echo "git remote add origin <remote-url>"
		echo ""
		return 2
	fi
	set -e

	GIT_DEFAULT_REMOTE2=${GIT_DEFAULT_REMOTE2:-github.com}
	GIT_ALT_REMOTE2=${GIT_ALT_REMOTE2:-gitlab.com}
	GIT_REMOTE_NAME=${GIT_REMOTE_NAME:-all}
	GIT_REMOTE_EXT=${GIT_REMOTE_EXT:-$(git remote get-url origin | sed -E "s/(git@|https:\/\/)(.+)([\/\:])(.+)\/(.+)(\..+)/\6/")}
	GIT_REMOTE_EXT2=${GIT_REMOTE_EXT2:-$GIT_REMOTE_EXT}
	GIT_REMOTE1=${GIT_REMOTE1:-$(git remote get-url origin | sed 's@\(^.\+[/:]\).\+/.\+@\1@')}
	GIT_REMOTE_HOST1=${GIT_REMOTE_HOST1:-$(echo "$GIT_REMOTE1" | sed -E 's/(git@|https:\/\/)(.+)([\/\:])/\2/')}
	GIT_REMOTE_HOST2=${GIT_REMOTE_HOST2:-$GIT_DEFAULT_REMOTE2}

	set +e
	GIT_REMOTE_SWAPPED=$(git_remote_add_multi_swap $(echo "$GIT_REMOTE1" | sed -E 's/(git@|https:\/\/)(.+)([\/\:])/\2/') "$GIT_DEFAULT_REMOTE2" "$GIT_ALT_REMOTE2")
	set -e

	GIT_REMOTE2=${GIT_REMOTE2:-$(echo "$GIT_REMOTE1" | sed -E "s/(git@|https:\/\/)(.+)([\/\:])/\1$GIT_REMOTE_SWAPPED\3/")}
	GIT_REPO_OWNER=${GIT_REPO_OWNER:-$(git remote get-url origin | sed -E 's/(git@|https:\/\/)(.+)([\/\:])(.+)\/(.+)/\4/')}
	GIT_REPO_NAME=${GIT_REPO_NAME:-$(git remote get-url origin | sed -E "s/(git@|https:\/\/)(.+)([\/\:])(.+)\/(.+)(\..+)/\5/")}
	GIT_REPO_OWNER2=${GIT_REPO_OWNER2:-$GIT_REPO_OWNER}
	GIT_REPO_NAME2=${GIT_REPO_NAME2:-$GIT_REPO_NAME}

	if [ $# -ge 1 ] && [ "$1" != "-h" ] && [ "$1" != "--help" ]; then
		GIT_REMOTE2_ARG="$1"
		GIT_REMOTE_EXT2=$(echo "$GIT_REMOTE2_ARG" | sed -E "s/(git@|https:\/\/)(.+)([\/\:])(.+)\/(.+)(\..+)/\6/")
		GIT_REMOTE_HOST2=$(echo "$GIT_REMOTE2_ARG" | sed -E "s/(git@|https:\/\/)(.+)([\/\:])(.+)\/(.+)(\..+)/\2/")
		GIT_REMOTE2=$(echo "$GIT_REMOTE2_ARG" | sed 's@\(^.\+[/:]\).\+/.\+@\1@')
		GIT_REPO_OWNER2=$(echo "$GIT_REMOTE2_ARG" | sed -E 's/(git@|https:\/\/)(.+)([\/\:])(.+)\/(.+)/\4/')
		GIT_REPO_NAME2=$(echo "$GIT_REMOTE2_ARG" | sed -E "s/(git@|https:\/\/)(.+)([\/\:])(.+)\/(.+)(\..+)/\5/")
	fi

	if [ $# -ge 1 ] && [ "${@: -1}" == "-h" ] || [ "${@: -1}" == "--help" ]; then
		git_remote_add_multi_usage
		return $?
	fi

	git remote add ${GIT_REMOTE_NAME} ${GIT_REMOTE1}/${GIT_REPO_OWNER}/${GIT_REPO_NAME}${GIT_REMOTE_EXT}
	git remote set-url --push --add ${GIT_REMOTE_NAME} ${GIT_REMOTE1}/${GIT_REPO_OWNER}/${GIT_REPO_NAME}${GIT_REMOTE_EXT}
	git remote set-url --push --add ${GIT_REMOTE_NAME} ${GIT_REMOTE2}/${GIT_REPO_OWNER2}/${GIT_REPO_NAME2}${GIT_REMOTE_EXT2}

	git remote -v
}

git_remote_add_multi $@

