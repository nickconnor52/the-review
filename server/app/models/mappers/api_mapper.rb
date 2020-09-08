class Mappers::ApiMapper
  def initialize(players)
    @players_response = players || []
  end

  def persist_players
    @players_response.each do |player|
      player_mapper = Mappers::PlayerMapper.new(player)
      player_mapper.persist
    end
  end
end

class Mappers::PlayerMapper
  attr_accessor :first_name, :last_name, :full_name, :espn_id,
  :espn_fantasy_team_id, :espn_pro_team_id, :espn_position_id,
  :jersey_number, :status

  def initialize(player)
    #
  end

  def persist
    #
  end
end
