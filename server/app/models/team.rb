class Team < ActiveRecord::Base
  has_many :rosters
  has_many :owners

  def team_info
    TeamIdentifier.where(team_id: self.id).last
  end

  def past_team_info
    TeamIdentifier.where(team_id: self.id).all
  end
end
