class AddBestBallScoreToGame < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :home_best_ball_score, :float
    add_column :games, :away_best_ball_score, :float
  end
end
