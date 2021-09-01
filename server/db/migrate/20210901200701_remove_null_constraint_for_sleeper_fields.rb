class RemoveNullConstraintForSleeperFields < ActiveRecord::Migration[5.1]
  def change
    change_column_null :team_identifiers, :location, true
    change_column_null :team_identifiers, :abbreviation, true
  end
end
