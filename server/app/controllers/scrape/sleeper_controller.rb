class Scrape::SleeperController < ScrapeController
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
    week = params[:week]
    if week.nil?
      [*1..18].each do |week|
        response = HTTParty.get("#{league_url}/transactions/#{week}")
        api_mapper = Mappers::ApiMapper.new(response)
        error_messages = api_mapper.persist_transactions
      end
    else
      response = HTTParty.get("#{league_url}/transactions/#{week}")
      api_mapper = Mappers::ApiMapper.new(response)
      error_messages = api_mapper.persist_transactions
    end
    render :json => { success: true, error_messages: error_messages }
  end

  def sync_schedule
    # TODO: HANDLE NUMBER
    year = 2021
    week = params[:week]
    if week.nil?
      [*1..18].each do |week|
        response = HTTParty.get("#{league_url}/matchups/#{week}")
        api_mapper = Mappers::ApiMapper.new(response)
        error_messages = api_mapper.persist_schedule(year, week)
      end
    else
      response = HTTParty.get("#{league_url}/matchups/#{week}")
      api_mapper = Mappers::ApiMapper.new(response)
      error_messages = api_mapper.persist_schedule(year, week)
    end

    render :json => { success: true, error_messages: error_messages }
  end

  def sync_player_stats
    year = 2021
    week = params[:week]
    if week.nil?
      [*1..18].each do |week|
        response = HTTParty.get("#{league_url}/matchups/#{week}")
        api_mapper = Mappers::ApiMapper.new(response)
        error_messages = api_mapper.persist_player_stats(year, week)
      end
    else
      response = HTTParty.get("#{league_url}/matchups/#{week}")
      api_mapper = Mappers::ApiMapper.new(response)
      error_messages = api_mapper.persist_player_stats(year, week)
    end
    render :json => { success: true, error_messages: error_messages }

  end

  def sync_owners
    # TODO: Add Owner Sleeper Nickname / Avatar
  end

  def sync_draft
    draft_id = '672128737071931392'
    year = 2021
    set_draft_order(year, draft_id)
    response = HTTParty.get("#{base_sleeper_url}/draft/#{draft_id}/picks")
    api_mapper = Mappers::ApiMapper.new(response)
    error_messages = api_mapper.persist_draft
    render :json => { success: true, error_messages: error_messages }
  end

  def sync_all_players
    response = HTTParty.get("#{base_sleeper_url}/players/nfl")
    api_mapper = Mappers::ApiMapper.new(response)
    error_messages = api_mapper.persist_players
    render :json => { success: true, error_messages: error_messages }
  end

  private

  def set_draft_order(year, draft_id)
    response = HTTParty.get("#{base_sleeper_url}/draft/#{draft_id}")
    draft_picks = Draft.find_by(year: year).draft_picks
    team_pick_mapper = response['slot_to_roster_id']
    team_pick_mapper.each do |pick_number, roster_id|
      team = Team.find_by(sleeper_roster_id: roster_id)
      team_picks = draft_picks.where(original_pick_team_id: team.to_param)
      team_picks.update_all(round_pick_number: pick_number)
    end
  end
end
