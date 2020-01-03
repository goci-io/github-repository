#!/bin/sh
set -e

cd ${1}/${2}

git checkout -b goci-github-actions

mkdir -p .github/workflows
cp -R ../.github/workflows/ .github/workflows

if [[ -z $(git status -s) ]]; then
    echo "No changes required."
    exit 0
fi

git add .github/workflows
git commit -m "[goci] update github actions"

GIT_SSH_COMMAND="ssh -i ${3}" git push origin goci-github-actions
