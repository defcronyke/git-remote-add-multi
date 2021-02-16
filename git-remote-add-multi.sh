#!/bin/bash -e

git_remote_add_multi_usage() {
	echo ""
        echo "Add a new git remote called \"all\" pointing at both gitlab (primary) and github (secondary)."
        echo ""
        echo "usage: bash <(curl -sL https://tinyurl.com/git-remote-add-multi) [\$GIT_REPO_NAME] [\$GIT_REPO_OWNER]"
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
	elif [ "$1" == "$3" ]; then 
		echo "$2"
	else
		echo "error: The first arg wasn't equal to either the second or the third arg. Swapping failed: $1: $2: $3"
		return 4
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

	GIT_REMOTE_NAME=${GIT_REMOTE_NAME:-all}
	GIT_REMOTE_EXT=${GIT_REMOTE_EXT:-$(git remote get-url origin | sed -E "s/(git@|https:\/\/)(.+)([\/\:])(.+)\/(.+)(\..+)/\6/")}
	GIT_REMOTE1=${GIT_REMOTE1:-$(git remote get-url origin | sed 's@\(^.\+[/:]\).\+/.\+@\1@')}
	GIT_REMOTE_HOST1=${GIT_REMOTE_HOST1:-$(echo "$GIT_REMOTE1" | sed -E 's/(git@|https:\/\/)(.+)([\/\:])/\2/')}
	GIT_REMOTE_HOST2=${GIT_REMOTE_HOST2:-github.com}

	set +e
	GIT_REMOTE_SWAPPED=$(git_remote_add_multi_swap $(echo "$GIT_REMOTE1" | sed -E 's/(git@|https:\/\/)(.+)([\/\:])/\2/') "$GIT_REMOTE_HOST1" "$GIT_REMOTE_HOST2")
	set -e

	GIT_REMOTE2=${GIT_REMOTE2:-$(echo "$GIT_REMOTE1" | sed -E "s/(git@|https:\/\/)(.+)([\/\:])/\1$GIT_REMOTE_SWAPPED\3/")}
	GIT_REPO_OWNER=${GIT_REPO_OWNER:-$(git remote get-url origin | sed -E 's/(git@|https:\/\/)(.+)([\/\:])(.+)\/(.+)/\4/')}
	GIT_REPO_NAME=${GIT_REPO_NAME:-$(git remote get-url origin | sed -E "s/(git@|https:\/\/)(.+)([\/\:])(.+)\/(.+)(\..+)/\5/")}

	if [ $# -gt 2 ] || [ $# -ge 1 ] && [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
		git_remote_add_multi_usage
		return $?
	fi

	if [ $# -ge 1 ]; then
		GIT_REPO_NAME=$1
	fi

	if [ $# -ge 2 ]; then
		GIT_REPO_OWNER=$2
	fi

	git remote add ${GIT_REMOTE_NAME} ${GIT_REMOTE1}/${GIT_REPO_OWNER}/${GIT_REPO_NAME}${GIT_REMOTE_EXT}
	git remote set-url --push --add ${GIT_REMOTE_NAME} ${GIT_REMOTE1}/${GIT_REPO_OWNER}/${GIT_REPO_NAME}${GIT_REMOTE_EXT}
	git remote set-url --push --add ${GIT_REMOTE_NAME} ${GIT_REMOTE2}/${GIT_REPO_OWNER}/${GIT_REPO_NAME}${GIT_REMOTE_EXT}

	git remote -v
}

git_remote_add_multi $@

