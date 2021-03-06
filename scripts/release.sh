#!/bin/bash

if git log --skip 1 origin/master..origin/develop|grep '^commit '; then
  # Bump the current release version
  VERSION=$(npm run release:bump --silent -- release)

  # Create the current release
  git add package.json
  git commit -m "v$VERSION"
  git tag -a -f "$VERSION" -m "$VERSION release"

  # Create dev release
  DEV_VERSION=$(npm run release:bump --silent -- dev)
  git add package.json
  git commit -m "Prepare v$DEV_VERSION"

  # Push to master
  git branch -f master $VERSION
  git push origin master develop
  git push --tags
  if [ $? -eq 0 ]; then
    npm run release:upload -- $VERSION
  fi
else
  echo "No commits, skipping release"
fi
