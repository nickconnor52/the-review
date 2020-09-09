Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope path: 'api' do
    resources :posts

    namespace :scrape do
      get 'all_players_by_year' => 'espn#fetch_all_players_by_year'
      get 'sync_owners' => 'espn#sync_owners'
      get 'sync_historical_owners' => 'espn#sync_historical_owners'
    end
  end
end
