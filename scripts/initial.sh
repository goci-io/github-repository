#!/bin/sh
set -e

cd ${1}/${2}

cp ../README.md README.md
git add README.md
git commit -m "[goci] add initial README.md"

mkdir -p .github/workflows
cp -R ../.github/workflows/ .github/workflows
git add .github/workflows
git commit -m "[goci] add initial github actions"

GIT_SSH_COMMAND="ssh -i ${3}" git push origin master
