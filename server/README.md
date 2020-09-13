# README

This is the backend for the League In Review.

## Deploying:

Need to serve only the API to the Heroku app hosting service, this is done with the following pattern
```
$: git subtree split --prefix [server / client] -b deploy
$: git push -f heroku-[api / ui] deploy:master
$: git branch -D deploy
```

Now have two separate Heroku ENV's, heroku-api & heroku-ui
The plan will be to build release and then push it to the separate branches
```
$: git subtree push ---prefix [directory] [heroku-app] [branch-name (release)]
```

Backend Heroku App -- heroku-api

