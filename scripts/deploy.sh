#!/bin/bash
# Run script from root dir

echo "--- Clear out old build relics ---"
git branch -D deploy


echo "--- Deploy to Client ---"
git subtree split --prefix client -b deploy
git push -f heroku-ui deploy:master
git branch -D deploy

echo "--- Deploy to Server ---"
git subtree split --prefix server -b deploy
git push -f heroku-api deploy:master
git branch -D deploy

echo "--- Deploy Process Complete ---"
