Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope path: 'api' do
    resources :posts

    namespace :scrape do
      get 'all_players_by_year' => 'espn#fetch_all_players_by_year'
      get 'sync_historical_players' => 'espn#sync_historical_players'
      get 'sync_teams' => 'espn#sync_teams'
      get 'sync_historical_teams' => 'espn#sync_historical_teams'
      get 'sync_owners' => 'espn#sync_owners'
      get 'sync_historical_owners' => 'espn#sync_historical_owners'
      get 'sync_pro_teams' => 'espn#sync_pro_teams'
    end
  end
end
