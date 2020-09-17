class DraftPick < ActiveRecord::Base
  belongs_to :player, optional: true

  def draft
    Draft.find(draft_id)
  end

  def team_info
    TeamIdentifier.where(team_id: team_id).order(:created_at => :asc).last
  end
end
