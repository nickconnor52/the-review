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

## Important Recurring API Calls
`/sync_active_lineups`
- Syncs All Current Rosters (updates player team_id to current team)

`/sync_new_transactions`

- Grabs all new Free Agent and Trade transactions (need to manually add drafts to trades)

`/sync_schedule`

- Grabs the results from all games of the year, updates Game table

`/sync_teams`

- Check for any new team names

`/sync_player_stats`

- Grab all player projection data for the season in the rake file

- (also available as Rake Task):
`rake data:fetch_projections`

### Note:

If a sequence gets out of sync due to fooling around with data, reset it with the following -

``` ALTER SEQUENCE [table_name_id_seq] RESTART WITH [next_value] ```

