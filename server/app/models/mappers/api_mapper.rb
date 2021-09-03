class Mappers::ApiMapper
  def initialize(response)
    @error_messages = []
    @response = response || []
  end

  def persist_players
    @response.each do |id, player|
      player_mapper = Mappers::PlayerMapper.new(player.with_indifferent_access, id)
      successful_upsert = player_mapper.persist
      unless successful_upsert
        @error_messages << id
      end
    end
    @error_messages
  end

  def persist_transactions
    @response.each do |transactions|
      transaction_mapper = Mappers::TransactionMapper.new(transactions.with_indifferent_access)
      successful_upsert = transaction_mapper.persist
      unless successful_upsert
        @error_messages << transactions["transaction_id"]
      end
    end
    @error_messages
  end

  # Loop through all players and assign TeamID -- will overwrite current TeamID
  # Reset all players on a roster, overwrite each team's current players
  def persist_active_lineups
    @response.each do |team|
      team_mapper = Mappers::LineupMapper.new(team.with_indifferent_access)
      successful_upsert = team_mapper.persist
      unless successful_upsert
        @error_messages << team['owner_id']
      end
    end
    @error_messages
  end

  def persist_schedule(year, week)
    @response.each do |game|
      game_mapper = Mappers::ScheduleMapper.new(game.with_indifferent_access, year, week)
      successful_upsert = game_mapper.persist
      unless successful_upsert
        @error_messages << game['matchup_id']
      end
    end
    @error_messages
  end

  def persist_owners
    @response.each do |owner|
      owner_mapper = Mappers::OwnerMapper.new(owner.with_indifferent_access)
      successful_upsert = owner_mapper.persist
      unless successful_upsert
        @error_messages << player['owner']['lastName']
      end
    end
    @error_messages
  end

  def persist_teams
    @response.each do |team|
      team_mapper = Mappers::TeamMapper.new(team.with_indifferent_access)
      successful_upsert = team_mapper.persist
      unless successful_upsert
        @error_messages << team['nickname']
      end
    end
    @error_messages
  end

  def persist_season_stats(year)
    @response.each do |team|
      stat_mapper = Mappers::SeasonStatMapper.new(team.with_indifferent_access, year)
      successful_upsert = stat_mapper.persist
      unless successful_upsert
        @error_messages << team['nickname']
      end
    end
    @error_messages
  end

  def persist_draft
    @response.each do |pick|
      draft_mapper = Mappers::DraftMapper.new(pick.with_indifferent_access)
      successful_upsert = draft_mapper.persist
      unless successful_upsert
        @error_messages << 'There was an issue with the draft'
      end
    end
    @error_messages
  end

  def persist_pro_teams
    @response.each do |conference|
      team_mapper = Mappers::ProTeamMapper.new(conference.with_indifferent_access)
      successful_upsert = team_mapper.persist
      unless successful_upsert
        @error_messages << conference['name']
      end
    end
    @error_messages
  end

  def persist_historical_rosters(year)
    @response.each do |team|
      roster_mapper = Mappers::RosterMapper.new(team.with_indifferent_access, year)
      successful_upsert = roster_mapper.persist
      unless successful_upsert
        @error_messages << team['id']
      end
    end
    @error_messages
  end

  def persist_player_stats(year, week)
    @response.each do |game|
      if players = game.dig('away', 'rosterForCurrentScoringPeriod', 'entries')
        espn_team_id = game['away']['teamId']
        players.each do |p|
          player_mapper = Mappers::PlayerStatMapper.new(p['playerPoolEntry']['player'].with_indifferent_access, year, week, espn_team_id)
          successful_upsert = player_mapper.persist
          unless successful_upsert
            @error_messages << espn_team_id['id']
          end
        end
      end

      if players = game.dig('home', 'rosterForCurrentScoringPeriod', 'entries')
        players.each do |p|
          espn_team_id = game['home']['teamId']
          player_mapper = Mappers::PlayerStatMapper.new(p['playerPoolEntry']['player'].with_indifferent_access, year, week, espn_team_id)
          successful_upsert = player_mapper.persist
          unless successful_upsert
            @error_messages << espn_team_id['id']
          end
        end
      end
    end
    @error_messages
  end
end

class Mappers::PlayerMapper
  attr_accessor :first_name, :last_name, :full_name, :espn_id,
                :espn_fantasy_team_id, :espn_pro_team_id, :espn_position_id,
                :jersey_number, :status

  def initialize(player, id)
    @first_name = player[:first_name]
    @last_name = player[:last_name]
    @full_name = player[:full_name]
    @espn_player_id = player[:espn_id]
    @sleeper_player_id = id
    @sleeper_pro_team_id = player[:team]
    @sleeper_position_id = player[:position]
    @jersey_number = player[:number]
    @status = player[:status]
  end

  def persist
    if @espn_player_id.nil?
      player = Player.find_or_initialize_by(sleeper_id: @sleeper_player_id)
    else
      player = Player.find_or_initialize_by(espn_id: @espn_player_id)
    end
    player.sleeper_id = @sleeper_player_id
    player.first_name = @first_name
    player.last_name = @last_name
    player.full_name = @full_name
    player.sleeper_pro_team_id = @sleeper_pro_team_id
    player.sleeper_position_id = @sleeper_position_id
    player.position = Position.find_by(abbreviation: @sleeper_position_id)
    player.jersey_number = @jersey_number
    player.status = @status
    player.pro_team = ProTeam.find_by(abbreviation: @sleeper_pro_team_id)
    player.save
  end
end

class Mappers::OwnerMapper
  attr_accessor :first_name, :last_name, :espn_id

  def initialize(owner)
    @first_name = owner[:firstName]
    @last_name = owner[:lastName]
    @espn_id = owner[:id]
  end

  def persist
    owner = Owner.find_or_initialize_by(espn_id: @espn_id)
    owner.first_name = @first_name
    owner.last_name = @last_name
    owner.season_joined = '2020'
    owner.city = 'Columbus, OH'
    owner.save
  end
end

class Mappers::TeamMapper
  attr_accessor :espn_id, :location, :nickname, :abbreviation, :logo_url

  def initialize(team)
    @sleeper_id = team[:user_id]
    @nickname = team[:metadata][:team_name] || team[:display_name]
    if team[:metadata][:avatar].nil?
      @logo_url = "https://sleepercdn.com/avatars/#{team[:avatar]}"
    else
      @logo_url = team[:metadata][:avatar]
    end
  end

  def persist
    team = Team.find_or_initialize_by(sleeper_id: @sleeper_id)
    team.save
    team_info = TeamIdentifier.find_or_initialize_by(team_id: team.to_param, location: @location, nickname: @nickname)
    team_info.abbreviation = @abbreviation
    team_info.logo_url = @logo_url
    team_info.save
  end
end

class Mappers::LineupMapper
  def initialize(team)
    @team_sleeper_id = team[:owner_id]
    @active_players = team[:players]
    @roster_id = team[:roster_id]
  end

  def persist
    team = Team.find_by(sleeper_id: @team_sleeper_id)
    team.sleeper_roster_id = @roster_id
    team.save!

    current_team = Player.where(team_id: team.to_param)
    cut_players = current_team.select{ |player| !@active_players.include?(player.sleeper_id)}
    cut_players.each do |player|
      player.on_trade_block = false
      player.team_id = nil
      player.sleeper_fantasy_team_id = nil
      player.espn_fantasy_team_id = nil
      player.save
    end

    @active_players.each do |player_id|
      player = Player.find_by(sleeper_id: player_id)
      player.sleeper_fantasy_team_id = @team_sleeper_id
      player.team_id = team.to_param
      player.save
    end
  end
end

class Mappers::SeasonStatMapper
  def initialize(team, year)
    @team = team
    @year = year
  end

  def persist
    team = Team.find_by(espn_id: @team['id'])
    stats = SeasonStat.find_or_initialize_by(team_id: team.to_param, season: @year)
    stats.playoff_seed = @team['playoffSeed']
    stats.final_espn_rank = @team['rankCalculatedFinal']
    stats.save
  end
end

class Mappers::ProTeamMapper
  def initialize(conference)
    @conference_name = conference[:name]
    @conference_teams = conference[:teams]
  end

  def persist
    @conference_teams.each do |team|
      pro_team = ProTeam.find_or_initialize_by(espn_id: team['id'])
      pro_team.name = team['displayName']
      pro_team.nickname = team['shortDisplayName']
      pro_team.abbreviation = team['abbreviation']
      pro_team.logo_url = team['logo']['href']
      pro_team.conference_name = @conference_name
      pro_team.save
    end
  end
end

class Mappers::DraftMapper
  def initialize(pick)
    @round = pick[:round]
    @player_id = pick[:player_id]
    @pick_number = pick[:pick_no]
    @user_id = pick[:picked_by]
    @round_pick_number = pick[:draft_slot]
  end

  def persist
    # TODO: Automate this number
    draft_year = 2021
    draft = Draft.find_or_initialize_by(year: draft_year)
    draft.save!

    draft_pick = DraftPick.find_or_initialize_by(draft_id: draft.id, round_number: @round, round_pick_number: @round_pick_number)
    draft_pick.overall_pick_number = @pick_number
    player = Player.find_by(sleeper_id: @player_id)
    draft_pick.player_id = player.to_param
    team = Team.find_by(sleeper_id: @user_id)
    draft_pick.team_id = team.to_param
    draft_pick.save
  end
end

class Mappers::ScheduleMapper
  def initialize(game, year, week)
    @week = week
    @year = year
    @team_id = Team.find_by(sleeper_roster_id: game[:roster_id]).to_param
    @matchup_id = game[:matchup_id].to_s
    @points = game[:points]
  end

  def persist
    game = Game.find_or_initialize_by(season: @year, week: @week, sleeper_matchup_id: @matchup_id)
    if game.home_team_id.nil?
      game.home_team_id = @team_id
      game.home_score = @points
    else
      game.away_team_id = @team_id
      game.away_score = @points
    end
    # TODO: CHECK THIS
    unless @score.to_i === 0
      game.winner = (game.away_score.to_f > game.home_score.to_f) ? "AWAY" : "HOME"
    end
    # TODO - NEED EXAMPLE
    game.playoff_tier_type = "NONE"

    game.save
  end
end

class Mappers::RosterMapper
  def initialize(team, year)
    @team = Team.find_by(espn_id: team[:id])
    @year = year
    @response = team
  end

  def persist
    roster = Roster.find_or_initialize_by(team_id: @team.to_param, year: @year)
    roster.save!

    players = @response[:roster][:entries]
    players.each do |p|
      player = find_player(p)
      unless roster.players.find_by(id: player.to_param)
        roster.players << player
      end
    end
    roster.save
  end

  def find_player(player_info)
    player = Player.find_or_initialize_by(espn_id: player_info['playerId'])
    player.first_name = player_info['playerPoolEntry']['player']['firstName']
    player.last_name = player_info['playerPoolEntry']['player']['lastName']
    player.full_name = player_info['playerPoolEntry']['player']['fullName']
    player.espn_pro_team_id = player_info['playerPoolEntry']['player']['proTeamId']
    player.pro_team_id = ProTeam.find_by(espn_id: player_info['playerPoolEntry']['player']['proTeamId']).to_param
    player.espn_position_id = player_info['playerPoolEntry']['player']['defaultPositionId']
    player.status = player_info['status']
    player.save

    player
  end
end

class Mappers::PlayerStatMapper
  def initialize(player, year, week, espn_team_id)
    @player = player
    @week = week
    @year = year
    @team = Team.find_by(espn_id: espn_team_id)
  end

  def persist
    player = Player.find_by(espn_id: @player['id'])
    stat = PlayerStat.find_or_initialize_by(player_id: player.to_param, season: @year, week: @week)
    @player['stats'].each do |s|
      if s['statSourceId'] == 0
        stat.actual_total = s['appliedTotal']
      elsif s['statSourceId'] == 1
        stat.projected_total = s['appliedTotal']
      end
    end
    stat.team_id = @team.to_param
    stat.save
  end
end

class Mappers::TransactionMapper
  def initialize(transaction)
    @sleeper_transaction_id = transaction[:transaction_id]
    @transaction_type = transaction[:type]
    @date = transaction[:status_updated]
    @roster_ids = transaction[:roster_ids]
    @drops = transaction[:drops]
    @adds = transaction[:adds]
  end

  def persist
    transaction = Transaction.find_or_initialize_by(sleeper_id: @sleeper_transaction_id)
    transaction.accepted_date = DateTime.strptime(@date.to_s,'%Q')
    transaction.transaction_type = @transaction_type
    transaction_teams = []
    @roster_ids.each do |id|
      team = Team.find_by(sleeper_roster_id: id)
      transaction_teams << team
    end

    transaction.teams = transaction_teams.uniq

    transaction.save!

    if @transaction_type === 'free_agent'
      @drops.each do |player_id, roster_id|
        team_id = Team.find_by(sleeper_roster_id: roster_id).to_param
        upsert_piece(player_id, nil, team_id, transaction.to_param, "DROP")
      end unless @drops.nil?

      @adds.each do |player_id, roster_id|
        team_id = Team.find_by(sleeper_roster_id: roster_id).to_param
        upsert_piece(player_id, team_id, nil, transaction.to_param, "ADD")
      end unless @adds.nil?
    end

    if @transaction_type === 'trade'
      # TODO - need an example to use
    end

    transaction.save!
  end

  def upsert_piece(player_id, to_team_id, from_team_id, transaction_id, transaction_type)
    player = Player.find_by(sleeper_id: player_id)
    from_team = Team.find_by(id: from_team_id)
    to_team = Team.find_by(id: to_team_id)
    piece = TransactionPiece.find_or_initialize_by(
      transaction_id: transaction_id,
      player_id: player.to_param,
      from_team_id:from_team.to_param,
      to_team_id: to_team.to_param
    )
    piece.action_type = transaction_type

    piece.save!
  end
end
