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

  def get_trade
    @trade = Transaction.find(params[:id])
  end
end
