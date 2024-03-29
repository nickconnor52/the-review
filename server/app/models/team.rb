class Team < ActiveRecord::Base
  has_many :rosters
  has_many :owners
  has_many :transaction_pieces
  has_many :players
  belongs_to :user, optional: true
  has_and_belongs_to_many :player_transactions, class_name: 'Transaction'

  def current_owner
    Owner
      .where(team_id: self.id)
      .where(last_active_season: [nil, '']).first
  end

  def past_owners
    Owner
      .where(team_id: self.id)
      .where.not(last_active_season: [nil, ''])
  end

  def position_need
    Position.where(id: trade_block_position_id).first
  end

  def roster
    Player.where(team_id: self.id).order(:espn_position_id => :asc).all
  end

  def team_info
    TeamIdentifier.where(team_id: self.id).order(:created_at => :asc).last
  end

  def past_team_info
    TeamIdentifier
      .where(team_id: self.id)
      .order(created_at: :desc)
      .all[1..-1]
  end

  def trade_block
    roster.where(on_trade_block: true)
  end

  def trade_count
    player_transactions.where(transaction_type: 'TRADE_ACCEPT').count
  end

  def original_players
    original_picks = DraftPick.where(draft_id: '1', team_id: id).pluck(:player_id)
    players_with_transactions = TransactionPiece.where(player_id: original_picks).where.not(action_type: 'LINEUP').pluck(:player_id)
    players.where(id: original_picks).where.not(id: players_with_transactions).pluck(:full_name)
  end
end
