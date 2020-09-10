class TeamsController < ApplicationController
  before_action :find_team, only: [:show, :update]

  def index
    teams = Team.all.order created_at: :desc

    render :json => teams, :include => [:team_info]
  end

  def show
    render :json => @team, :include => [:team_info, :roster]
  end

  private
  def find_team
    @team = Team.find(team_params[:id])
  end

  def team_params
    params.permit(:id)
  end
end
