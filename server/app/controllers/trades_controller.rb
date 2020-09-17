class TradesController < ApplicationController
  before_action :get_trade, only: [:show]
  def index
    trades = Transaction.where(transaction_type: 'TRADE_ACCEPT').order created_at: :desc

    render :json => trades, :include => [
      {
        :teams => {
          :include => [:team_info]
        }
      },
      {
        :transaction_pieces => {
          :include => [:source_team, :receiving_team, :player, :draft_pick],
          :methods => [:display_name, :draft_year]
        }
      }
    ]
  end

  def create
    transaction_teams = []
    transaction_teams << Team.find(params[:teamAId])
    transaction_teams << Team.find(params[:teamBId])
    transaction = Transaction.new
    transaction.accepted_date = DateTime.strptime("#{params[:date]} 12:00", '%m/%d/%y %H:%M')
    transaction.transaction_type = 'TRADE_ACCEPT'
    transaction.espn_id = '0'
    transaction.teams = transaction_teams
    transaction.save

    team_a_players = params[:teamAPlayerNames]
    team_a_players.each do |player_name|
      add_player_to_transaction(player_name, transaction, params[:teamBId], params[:teamAId])
    end

    team_b_players = params[:teamBPlayerNames]
    team_b_players.each do |player_name|
      add_player_to_transaction(player_name, transaction, params[:teamAId], params[:teamBId])
    end

    render :json => transaction
  end

  def show
    render :json => @trade, :include => [
      {
        :teams => {
          :include => [:team_info]
        }
      },
      {
        :transaction_pieces => {
          :include => [
            :source_team,
            :receiving_team,
            :player,
            :draft_pick,
            :display_name
          ]
        }
      }
    ]
  end

  private
  def add_player_to_transaction(player_name, transaction, from_team_id, to_team_id)
    player = Player.find_by(full_name: player_name)
    piece = TransactionPiece.new(player_id: player.to_param)
    piece.from_team_id = from_team_id
    piece.to_team_id = to_team_id
    piece.action_type = 'TRADE'
    piece.transaction_id = transaction.to_param
    piece.save
  end

  def get_trade
    @trade = Transaction.find(params[:id])
  end
end
