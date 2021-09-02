class Scrape::SleeperController < ScrapeController
  def sync_owners
    # TODO: Add Owner Sleeper Nickname / Avatar
  end
  def sync_teams
    response = HTTParty.get("#{league_url}/users")
    api_mapper = Mappers::ApiMapper.new(response)
    error_messages = api_mapper.persist_teams
    render :json => { success: true, error_messages: error_messages }
  end

  def sync_active_lineups
    response = HTTParty.get("#{league_url}/rosters")
    api_mapper = Mappers::ApiMapper.new(response)
    error_messages = api_mapper.persist_active_lineups
    render :json => { success: true, error_messages: error_messages }
  end

  def sync_new_transactions
    # TODO: HANDLE THE TRANSACTION NUMBER AT THE END. INCREMENT SOMEHOW?
    response = HTTParty.get("#{league_url}/transactions/1")
    api_mapper = Mappers::ApiMapper.new(response)
    error_messages = api_mapper.persist_transactions
    render :json => { success: true, error_messages: error_messages }
  end

  def sync_all_players
    response = HTTParty.get("#{base_sleeper_url}/players/nfl")
    api_mapper = Mappers::ApiMapper.new(response)
    error_messages = api_mapper.persist_players
    render :json => { success: true, error_messages: error_messages }
  end
end
