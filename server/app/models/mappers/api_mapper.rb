class Mappers::ApiMapper
  def initialize(response)
    @error_messages = []
    @response = response || []
  end

  def persist_players
    @response.each do |player|
      player_mapper = Mappers::PlayerMapper.new(player.with_indifferent_access)
      successful_upsert = player_mapper.persist
      unless successful_upsert
        @error_messages < player[:player][:fullName]
      end
    end
    @error_messages
  end

  def persist_owners
    @response.each do |owner|
      owner_mapper = Mappers::OwnerMapper.new(owner.with_indifferent_access)
      successful_upsert = owner_mapper.persist
      unless successful_upsert
        @error_messages < player[:owner][:lastName]
      end
    end
    @error_messages
  end

  def persist_teams
    @response.each do |team|
      team_mapper = Mappers::TeamMapper.new(team.with_indifferent_access)
      successful_upsert = team_mapper.persist
      unless successful_upsert
        @error_messages < team[:nickname]
      end
    end
    @error_messages
  end

  def persist_pro_teams
    @response.each do |conference|
      team_mapper = Mappers::ProTeamMapper.new(conference.with_indifferent_access)
      successful_upsert = team_mapper.persist
      unless successful_upsert
        @error_messages < conference[:name]
      end
    end
    @error_messages
  end
end

class Mappers::PlayerMapper
  attr_accessor :first_name, :last_name, :full_name, :espn_id,
                :espn_fantasy_team_id, :espn_pro_team_id, :espn_position_id,
                :jersey_number, :status

  def initialize(player)
    @first_name = player[:player][:firstName]
    @last_name = player[:player][:lastName]
    @full_name = player[:player][:fullName]
    @espn_player_id = player[:id]
    @espn_fantasy_team_id = player[:onTeamId]
    @espn_pro_team_id = player[:onTeamId]
    @espn_position_id = player[:player][:defaultPositionId]
    @jersey_number = player[:player][:jersey]
    @status = player[:status]
    # TODO - PLAYER -> STATS
  end

  def persist
    player = Player.find_or_initialize_by(espn_id: @espn_player_id)
    player.first_name = @first_name
    player.last_name = @last_name
    player.full_name = @full_name
    player.espn_fantasy_team_id = @espn_fantasy_team_id
    player.espn_pro_team_id = @espn_pro_team_id
    player.espn_position_id = @espn_position_id
    player.jersey_number = @jersey_number
    player.status = @status
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
    @espn_id = team[:id]
    @location = team[:location]
    @nickname = team[:nickname]
    @abbreviation = team[:abbrev]
    @logo_url = team[:logo]
  end

  def persist
    team = Team.find_or_initialize_by(espn_id: @espn_id)
    team.save
    team_info = TeamIdentifier.find_or_initialize_by(team_id: team.to_param, location: @location, nickname: @nickname)
    team_info.location = @location
    team_info.nickname = @nickname
    team_info.abbreviation = @abbreviation
    team_info.logo_url = @logo_url
    team_info.save
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
