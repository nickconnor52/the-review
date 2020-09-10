namespace :data do
  desc 'Grab all ESPN projected data'
  task :fetch_projections => :environment do
    cookie_from_params = {
      swid: ENV['ESPN_SWID'],
      espn_s2: ENV['ESPN_S2']
    }

    filter_hash = HTTParty::CookieHash.new
    cookie_hash = HTTParty::CookieHash.new
    cookie_hash.add_cookies(cookie_from_params)

    year = '2018'
    url = "https://fantasy.espn.com/apis/v3/games/ffl/seasons/#{year}/segments/0/leagues/#{ENV['LEAGUE_ID']}?view=mMatchup&view=mMatchupScore"

    (1..17).each do |week|
      query_params = {
        :view => 'mMatchupScore',
        :scoringPeriodId => week
      }
      response = HTTParty.get(url, { :query => query_params, :headers => { 'Cookie' => cookie_hash.to_cookie_string }})
      api_mapper = Mappers::ApiMapper.new(response['schedule'])
      api_mapper.persist_player_stats(year, week)
    end

  end
end
