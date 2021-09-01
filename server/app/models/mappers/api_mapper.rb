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
    @response.each do |player|
      transaction_mapper = Mappers::TransactionMapper.new(player.with_indifferent_access)
      successful_upsert = transaction_mapper.persist
      unless successful_upsert
        @error_messages << player['player']['fullName']
      end
    end
    @error_messages
  end

  # Loop through all players and assign TeamID -- will overwrite current TeamID
  def persist_active_lineups
    @response.each do |player|
      player_mapper = Mappers::PlayerMapper.new(player.with_indifferent_access)
      successful_upsert = player_mapper.persist_lineup
      unless successful_upsert
        @error_messages << player['player']['fullName']
      end
    end
    @error_messages
  end

  def persist_schedule(year)
    @response.each do |game|
      game_mapper = Mappers::ScheduleMapper.new(game.with_indifferent_access, year)
      successful_upsert = game_mapper.persist
      unless successful_upsert
        @error_messages << game['away_team_id']
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
    draft_mapper = Mappers::DraftMapper.new(@response.with_indifferent_access)
    successful_upsert = draft_mapper.persist
    unless successful_upsert
      @error_messages << 'There was an issue with the draft'
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

  def persist_lineup
    pro_team = ProTeam.find_by(espn_id: @espn_pro_team_id)
    team = Team.find_by(espn_id: @espn_fantasy_team_id)
    player = Player.find_by(espn_id: @espn_player_id)

    if player.nil?
      persist()
      return true
    end

    player.espn_fantasy_team_id = @espn_fantasy_team_id
    player.team_id = team.to_param
    player.espn_pro_team_id = @espn_pro_team_id
    player.pro_team = pro_team
    if @espn_fantasy_team_id === 0
      player.on_trade_block = false
    end

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
  def initialize(draftDetails)
    @picks = draftDetails[:picks]
    @date = draftDetails[:completeDate]
  end

  def persist
    draft_year = DateTime.strptime(@date.to_s,'%Q').year
    draft = Draft.find_or_initialize_by(year: draft_year)
    draft.save!
    @picks.each do |pick|
      draft_pick = DraftPick.find_or_initialize_by(draft_id: draft.id, overall_pick_number: pick['overallPickNumber'])
      draft_pick.round_number = pick['roundId']
      draft_pick.round_pick_number = pick['roundPickNumber']
      player = Player.find_by(espn_id: pick['playerId'])
      draft_pick.player_id = player.to_param
      team = Team.find_by(espn_id: pick['teamId'])
      draft_pick.team_id = team.to_param
      draft_pick.original_pick_team_id = team.to_param
      draft_pick.save
    end
  end
end

class Mappers::ScheduleMapper
  def initialize(game, year)
    @game = game
    @year = year
    @home_team = Team.find_by(espn_id: game[:home][:teamId])
    @away_team = Team.find_by(espn_id: game[:away][:teamId])
  end

  def persist
    game = Game.find_or_initialize_by(season: @year, week: @game[:matchupPeriodId], away_team_id: @away_team.to_param, home_team_id: @home_team.to_param)
    game.away_score = @game['away']['totalPoints']
    game.home_score = @game['home']['totalPoints']
    game.winner = @game['winner']
    game.playoff_tier_type = @game['playoffTierType']
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
  def initialize(player)
    @player_info = player
  end

  def persist
    transactions = @player_info['transactions']
    transactions.each do |t|
      upsert_transaction(t)
    end unless transactions.nil?
  end

  def upsert_transaction(transaction_info)
    unless transaction_info['type'] === 'DRAFT'
      transaction = Transaction.find_or_initialize_by(espn_id: transaction_info['id'])
      date = transaction_info['acceptedDate'] ? transaction_info['acceptedDate'] : transaction_info['proposedDate']
      transaction.accepted_date = DateTime.strptime(date.to_s,'%Q')
      transaction.transaction_type = transaction_info['type']
      transaction.save

      transaction_teams = []

      transaction_info['items'].each do |piece|
        piece = upsert_pieces(piece, transaction.to_param)
        from_team_info = piece.source_team
        to_team_info = piece.receiving_team
        transaction_teams << Team.find(from_team_info.team_id) unless from_team_info.blank?
        transaction_teams << Team.find(to_team_info.team_id) unless to_team_info.blank?
      end unless transaction_info['items'].blank?
      transaction.teams = transaction_teams.uniq
    end
  end

  def upsert_pieces(piece_info, transaction_id)
    player = Player.find_by(espn_id: piece_info['playerId'])
    from_team = Team.find_by(espn_id: piece_info['fromTeamId'])
    to_team = Team.find_by(espn_id: piece_info['toTeamId'])
    piece = TransactionPiece.find_or_initialize_by(
      transaction_id: transaction_id,
      player_id: player.to_param,
      from_team_id:from_team.to_param,
      to_team_id: to_team.to_param
    )
    piece.action_type = piece_info['type']

    piece.save

    piece
  end
end
