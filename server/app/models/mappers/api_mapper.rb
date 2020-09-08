class Mappers::ApiMapper
  def initialize(players)
    @players_response = players || []
  end

  def persist_players
    error_messages = []
    @players_response.each do |player|
      player_mapper = Mappers::PlayerMapper.new(player.with_indifferent_access)
      successful_upsert = player_mapper.persist
      unless successful_upsert
        status[:error_messages] < player[:player][:fullName]
      end
    end
    error_messages
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
