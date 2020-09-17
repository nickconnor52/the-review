class TransactionPiece < ActiveRecord::Base
  belongs_to :player, optional: true
  belongs_to :draft_pick, optional: true

  def receiving_team
    if self.to_team_id.blank?
      return nil
    end

    Team.find(self.to_team_id).team_info
  end

  def source_team
    if self.from_team_id.blank?
      return nil
    end

    Team.find(self.from_team_id).team_info
  end

  def draft_year
    DraftPick.find(draft_pick_id).draft.year if draft_pick_id.present?
  end

  def display_name
    if player_id.present?
      Player.find(player_id).full_name
    elsif draft_pick_id.present?
      draft_player_id = DraftPick.find(draft_pick_id).player_id
      player = Player.find(draft_player_id)
      player.full_name unless player.nil?
    end
  end

end
