class Scrape::EspnController < ScrapeController
  def sync_players_by_year
    cookie_from_params = {
      swid: params[:swid],
      espn_s2: params[:espn_s2]
    }
    query_params = {
      :view => 'kona_playercard'
    }

    filter_hash = HTTParty::CookieHash.new
    limit = '10000'
    filter_hash.add_cookies('{"players":{"filterSlotIds":{"value":[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,23,24]},"filterRanksForScoringPeriodIds":{"value":[1]},"sortDraftRanks":{"sortPriority":100,"sortAsc":true,"value":"PPR"},"limit":"' + limit + '","filterStatsForTopScoringPeriodIds":{"value":2,"additionalValue":["002020","102020","002019","1120201","022020"]}}}')
    cookie_hash = HTTParty::CookieHash.new
    cookie_hash.add_cookies(cookie_from_params)
    response = HTTParty.get(base_espn_url, { :query => query_params, :headers => { 'Cookie' => cookie_hash.to_cookie_string, 'x-fantasy-filter' => filter_hash.to_cookie_string }})
    api_mapper = Mappers::ApiMapper.new(response['players'])
    error_messages = api_mapper.persist_players
    render :json => { success: true, error_messages: error_messages }
  end

  def sync_owners
    cookie_from_params = {
      swid: params[:swid],
      espn_s2: params[:espn_s2]
    }
    query_params = {
      :view => 'mTeam'
    }
    cookie_hash = HTTParty::CookieHash.new
    cookie_hash.add_cookies(cookie_from_params)
    response = HTTParty.get(base_espn_url, { :query => query_params, :headers => { 'Cookie' => cookie_hash.to_cookie_string }})
    api_mapper = Mappers::ApiMapper.new(response['members'])
    error_messages = api_mapper.persist_owners
    render :json => { success: true, error_messages: error_messages }
  end

  def sync_historical_owners
    cookie_from_params = {
      swid: params[:swid],
      espn_s2: params[:espn_s2]
    }
    query_params = {
      :seasonId => params[:year] || Date.now.year,
      :view => 'mTeam'
    }
    cookie_hash = HTTParty::CookieHash.new
    cookie_hash.add_cookies(cookie_from_params)
    response = HTTParty.get(history_url, { :query => query_params, :headers => { 'Cookie' => cookie_hash.to_cookie_string }})
    api_mapper = Mappers::ApiMapper.new(response[0]['members'])
    error_messages = api_mapper.persist_owners
    render :json => { success: true, error_messages: error_messages }
  end

  def sync_teams
    cookie_from_params = {
      swid: params[:swid],
      espn_s2: params[:espn_s2]
    }
    query_params = {
      :view => 'mTeam' # TODO: USING THIS ENDPOINT WILL GET PREVIOUS RECORDS TOO
    }
    cookie_hash = HTTParty::CookieHash.new
    cookie_hash.add_cookies(cookie_from_params)
    response = HTTParty.get(base_espn_url, { :query => query_params, :headers => { 'Cookie' => cookie_hash.to_cookie_string }})
    api_mapper = Mappers::ApiMapper.new(response['teams'])
    error_messages = api_mapper.persist_teams
    render :json => { success: true, error_messages: error_messages }
  end

  def sync_historical_teams
    cookie_from_params = {
      swid: params[:swid],
      espn_s2: params[:espn_s2]
    }
    query_params = {
      :seasonId => params[:year] || Date.now.year,
      :view => 'mTeam'
    }
    cookie_hash = HTTParty::CookieHash.new
    cookie_hash.add_cookies(cookie_from_params)
    response = HTTParty.get(history_url, { :query => query_params, :headers => { 'Cookie' => cookie_hash.to_cookie_string }})
    api_mapper = Mappers::ApiMapper.new(response[0]['teams'])
    error_messages = api_mapper.persist_teams
    render :json => { success: true, error_messages: error_messages }
  end

  def sync_final_season_stats
    cookie_from_params = {
      swid: params[:swid],
      espn_s2: params[:espn_s2]
    }
    query_params = {
      :seasonId => params[:year] || Date.now.year,
      :view => 'mTeam'
    }
    cookie_hash = HTTParty::CookieHash.new
    cookie_hash.add_cookies(cookie_from_params)
    response = HTTParty.get(history_url, { :query => query_params, :headers => { 'Cookie' => cookie_hash.to_cookie_string }})
    api_mapper = Mappers::ApiMapper.new(response[0]['teams'])
    error_messages = api_mapper.persist_season_stats(params[:year])
    render :json => { success: true, error_messages: error_messages }
  end

  def sync_historical_draft
    cookie_from_params = {
      swid: params[:swid],
      espn_s2: params[:espn_s2]
    }
    query_params = {
      :seasonId => params[:year] || Date.now.year,
      :view => 'mDraftDetail'
    }
    cookie_hash = HTTParty::CookieHash.new
    cookie_hash.add_cookies(cookie_from_params)
    response = HTTParty.get(history_url, { :query => query_params, :headers => { 'Cookie' => cookie_hash.to_cookie_string }})
    api_mapper = Mappers::ApiMapper.new(response[0]['draftDetail'])
    error_messages = api_mapper.persist_draft
    render :json => { success: true, error_messages: error_messages }
  end

  def sync_pro_teams
    url = 'https://site.web.api.espn.com/apis/site/v2/teams?region=us&lang=en&leagues=nfl'
    response = HTTParty.get(url)
    api_mapper = Mappers::ApiMapper.new(response['nfl'])
    error_messages = api_mapper.persist_pro_teams
    render :json => { success: true, error_messages: error_messages }
  end

  def sync_historical_rosters
    cookie_from_params = {
      swid: params[:swid],
      espn_s2: params[:espn_s2]
    }
    query_params = {
      :seasonId => params[:year] || Date.now.year,
      :view => 'mRoster'
    }
    cookie_hash = HTTParty::CookieHash.new
    cookie_hash.add_cookies(cookie_from_params)
    response = HTTParty.get(history_url, { :query => query_params, :headers => { 'Cookie' => cookie_hash.to_cookie_string }})
    api_mapper = Mappers::ApiMapper.new(response[0]['teams'])
    error_messages = api_mapper.persist_historical_rosters(params[:year])
    render :json => { success: true, error_messages: error_messages }
  end

  def sync_active_lineups
    cookie_from_params = {
      swid: params[:swid],
      espn_s2: params[:espn_s2]
    }
    query_params = {
      :view => 'kona_playercard'
    }

    filter_hash = HTTParty::CookieHash.new
    limit = '10000'
    filter_hash.add_cookies('{"players":{"filterSlotIds":{"value":[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,23,24]},"filterRanksForScoringPeriodIds":{"value":[1]},"sortDraftRanks":{"sortPriority":100,"sortAsc":true,"value":"PPR"},"limit":"' + limit + '","filterStatsForTopScoringPeriodIds":{"value":2,"additionalValue":["002020","102020","002019","1120201","022020"]}}}')
    cookie_hash = HTTParty::CookieHash.new
    cookie_hash.add_cookies(cookie_from_params)
    response = HTTParty.get(current_year_url, { :query => query_params, :headers => { 'Cookie' => cookie_hash.to_cookie_string, 'x-fantasy-filter' => filter_hash.to_cookie_string }})
    api_mapper = Mappers::ApiMapper.new(response['players'])
    error_messages = api_mapper.persist_active_lineups
    render :json => { success: true, error_messages: error_messages }
  end

  def sync_transactions
    cookie_from_params = {
      swid: params[:swid],
      espn_s2: params[:espn_s2]
    }
    query_params = {
      :view => 'kona_playercard'
    }

    filter_hash = HTTParty::CookieHash.new
    limit = '10000'
    filter_hash.add_cookies('{"players":{"filterSlotIds":{"value":[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,23,24]},"filterRanksForScoringPeriodIds":{"value":[1]},"sortDraftRanks":{"sortPriority":100,"sortAsc":true,"value":"PPR"},"limit":"' + limit + '","filterStatsForTopScoringPeriodIds":{"value":2,"additionalValue":["002020","102020","002019","1120201","022020"]}}}')
    cookie_hash = HTTParty::CookieHash.new
    cookie_hash.add_cookies(cookie_from_params)
    response = HTTParty.get(base_espn_url, { :query => query_params, :headers => { 'Cookie' => cookie_hash.to_cookie_string, 'x-fantasy-filter' => filter_hash.to_cookie_string }})
    api_mapper = Mappers::ApiMapper.new(response['players'])
    error_messages = api_mapper.persist_transactions
    render :json => { success: true, error_messages: error_messages }
  end

  def sync_new_transactions
    cookie_from_params = {
      swid: params[:swid],
      espn_s2: params[:espn_s2]
    }
    query_params = {
      :view => 'kona_playercard'
    }

    filter_hash = HTTParty::CookieHash.new
    limit = '10000'
    filter_hash.add_cookies('{"players":{"filterSlotIds":{"value":[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,23,24]},"filterRanksForScoringPeriodIds":{"value":[1]},"sortDraftRanks":{"sortPriority":100,"sortAsc":true,"value":"PPR"},"limit":"' + limit + '","filterStatsForTopScoringPeriodIds":{"value":2,"additionalValue":["002020","102020","002019","1120201","022020"]}}}')
    cookie_hash = HTTParty::CookieHash.new
    cookie_hash.add_cookies(cookie_from_params)
    response = HTTParty.get(current_year_url, { :query => query_params, :headers => { 'Cookie' => cookie_hash.to_cookie_string, 'x-fantasy-filter' => filter_hash.to_cookie_string }})
    api_mapper = Mappers::ApiMapper.new(response['players'])
    error_messages = api_mapper.persist_transactions
    render :json => { success: true, error_messages: error_messages }
  end

  def sync_schedule
    cookie_from_params = {
      swid: params[:swid],
      espn_s2: params[:espn_s2]
    }
    query_params = {
      :seasonId => params[:year] || Date.now.year,
      :view => 'mMatchupScore'
    }
    cookie_hash = HTTParty::CookieHash.new
    cookie_hash.add_cookies(cookie_from_params)
    response = HTTParty.get(base_espn_url, { :query => query_params, :headers => { 'Cookie' => cookie_hash.to_cookie_string }})
    api_mapper = Mappers::ApiMapper.new(response['schedule'])
    error_messages = api_mapper.persist_schedule(params[:year])
    render :json => { success: true, error_messages: error_messages }
  end

  def sync_historical_schedule
    cookie_from_params = {
      swid: params[:swid],
      espn_s2: params[:espn_s2]
    }
    query_params = {
      :seasonId => params[:year] || Date.now.year,
      :view => 'mMatchupScore'
    }
    cookie_hash = HTTParty::CookieHash.new
    cookie_hash.add_cookies(cookie_from_params)
    response = HTTParty.get(history_url, { :query => query_params, :headers => { 'Cookie' => cookie_hash.to_cookie_string }})
    api_mapper = Mappers::ApiMapper.new(response[0]['schedule'])
    error_messages = api_mapper.persist_schedule(params[:year])
    render :json => { success: true, error_messages: error_messages }
  end
end
