namespace :data do
  desc 'map position to ESPN ID'
  task :map_position => :environment do
    Player.all.each do |player|
      position = Position.find_by(espn_id: player.espn_position_id)
      player.position_id = position.to_param
      player.save!
    end
  end
end
