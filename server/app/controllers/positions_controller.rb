class PositionsController < ApplicationController
  def index
    positions = Position.all
    render :json => positions
  end
end
