class TransactionsController < ApplicationController
  before_action :find_team, only: [:show, :update]

  def index
    transactions = Transaction.all.limit(10).order created_at: :desc

    render :json => transactions, :include => [{
      :transaction_pieces => {
        :include => [:source_team, :receiving_team]
      }
    }]
  end

  private
end
