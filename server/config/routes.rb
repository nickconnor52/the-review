Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope path: 'api' do
    resources :posts
    resources :teams

    namespace :scrape do
      get 'sync_players_by_year' => 'espn#sync_players_by_year'
      get 'sync_active_lineups' => 'espn#sync_active_lineups'
      get 'sync_historical_players' => 'espn#sync_historical_players'
      get 'sync_teams' => 'espn#sync_teams'
      get 'sync_historical_teams' => 'espn#sync_historical_teams'
      get 'sync_historical_rosters' => 'espn#sync_historical_rosters'
      get 'sync_owners' => 'espn#sync_owners'
      get 'sync_historical_owners' => 'espn#sync_historical_owners'
      get 'sync_historical_draft' => 'espn#sync_historical_draft'
      get 'sync_pro_teams' => 'espn#sync_pro_teams'
      get 'sync_transactions' => 'espn#sync_transactions'
      get 'sync_new_transactions' => 'espn#sync_new_transactions'
      get 'sync_schedule' => 'espn#sync_schedule'
      get 'sync_historical_schedule' => 'espn#sync_historical_schedule'
      get 'sync_final_season_stats' => 'espn#sync_final_season_stats'
    end
  end
end
