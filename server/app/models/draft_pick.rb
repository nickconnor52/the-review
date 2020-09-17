class DraftPick < ActiveRecord::Base
  def draft
    Draft.find(draft_id)
  end
end
