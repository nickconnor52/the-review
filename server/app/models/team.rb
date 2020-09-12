class Team < ActiveRecord::Base
  has_many :rosters
  has_many :owners
  has_many :transaction_pieces
  has_and_belongs_to_many :player_transactions, class_name: 'Transaction'


  def roster
    Player.where(team_id: self.id).all
  end

  def team_info
    TeamIdentifier.where(team_id: self.id).last
  end

  def past_team_info
    TeamIdentifier.where(team_id: self.id).all
  end
end
