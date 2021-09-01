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
end
