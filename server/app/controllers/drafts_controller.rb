class DraftsController < ApplicationController
  before_action :get_draft, only: [:show]

  def show
    render :json => @draft, :include => [
      {
        :draft_picks => {
          :include => [
            :player => {
              :include => [:position]
            }
          ],
          :methods => [
            :team_info
          ]
        }
      }
    ]
  end

  private

  def get_draft
    @draft = Draft.find_by(year: params[:year])
  end
end
