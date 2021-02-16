#!/bin/bash -e

git_remote_add_multi() {
	GIT_REMOTE_NAME=${GIT_REMOTE_NAME:-all}
	GIT_REMOTE_EXT=${GIT_REMOTE_EXT:-.git}
	GIT_REMOTE1=${GIT_REMOTE1:-https://gitlab.com}
	GIT_REMOTE2=${GIT_REMOTE2:-https://github.com}
	GIT_REPO_OWNER=${GIT_REPO_OWNER:-$(whoami)}
	GIT_REPO_NAME=${GIT_REPO_NAME:-$(basename $PWD)}

	if [ $# -gt 2 ] || [ $# -ge 1 ] && [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
		echo ""
		echo "Add a new git remote called \"all\" pointing at both gitlab (primary) and github (secondary)."
		echo ""
		echo "usage: $(basename $0) [\$GIT_REPO_NAME] [\$GIT_REPO_OWNER]"
		echo ""
		echo "Optional: Set these environment variables to customize the behaviour (defaults are as below):"
		echo ""
		echo "GIT_REMOTE_NAME=${GIT_REMOTE_NAME}"
		echo "GIT_REMOTE_EXT=${GIT_REMOTE_EXT}"
		echo "GIT_REMOTE1=${GIT_REMOTE1}"
		echo "GIT_REMOTE2=${GIT_REMOTE2}"
		echo "GIT_REPO_OWNER=${GIT_REPO_OWNER}"
	        echo "GIT_REPO_NAME=${GIT_REPO_NAME}\n"
		echo ""
	
		return 1
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

