class TransactionPiece < ActiveRecord::Base
  def receiving_team
    if self.to_team_id.nil?
      return nil
    end

    Team.find(self.to_team_id).team_info
  end

  def source_team
    if self.from_team_id.nil?
      return nil
    end

    Team.find(self.from_team_id).team_info
  end

end
