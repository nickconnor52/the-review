class Game < ActiveRecord::Base
  def home_team
    Team.find(self.home_team_id)
  end

  def away_team
    Team.find(self.away_team_id)
  end

end
