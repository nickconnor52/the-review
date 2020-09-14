class TeamsController < ApplicationController
  before_action :get_team, only: [:show, :update, :team_transactions, :roster]

  def index
    teams = Team.all.order created_at: :desc

    render :json => teams, :include => [:team_info]
  end

  def show
    render :json => @team, :include => [
      :current_owner,
      :team_info,
      :past_team_info,
      :roster => {
        :include => [
          :pro_team,
          :position
        ]
      }
    ]
  end

  def team_transactions
    transactions = Transaction.includes(:teams).where('teams.id' => team_params[:id]).order accepted_date: :desc

    render :json => transactions, :include => [
      {
        :teams => {
          :include => :team_info
        }
      },
      {
        :transaction_pieces => {
          :include => [
            :player,
            :source_team,
            :receiving_team
          ]
        }
      }
    ]
  end

  def roster
    if params[:year] === DateTime.now.year.to_s
      @selected_roster = @team.roster
    else
      @selected_roster = @team.rosters.find_by(year: params[:year]).players
    end

    render :json => @selected_roster, :include => [
      :pro_team,
      :position
    ]
  end


  private
  def get_team
    @team = Team.find(team_params[:id])
  end

  def team_params
    params.permit(:id)
  end
end
