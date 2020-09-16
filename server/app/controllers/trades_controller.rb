class TradesController < ApplicationController
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
          :include => [:source_team, :receiving_team, :player]
        }
      }
    ]
  end

  private
end
