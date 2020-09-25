namespace :data do
  desc 'Analyze a Trade'
  task :trade_analyzer => :environment do
    # Clean all these up to pass arguments
    players = []

    # Need to map the Trade Date with the NFL Week / Season Number
    # Need to add the matchup date to the games table most likely
    week = 3
    season = 2019

    # Grab your players
    team_a_players = ['Julio Jones', 'Joe Mixon', 'Vance McDonald']
    team_b_players = ['Julian Edelman', 'T.Y. Hilton', 'Noah Fant', 'Melvin Gordon III', 'DK Metcalf']
    team_a_players.each do |p|
      players << Player.find_by_full_name(p)
    end
    team_b_players.each do |p|
      players << Player.find_by_full_name(p)
    end
    player_stat_hash = {}

    # Get the variance per week for 20 weeks for each player
    (1..20).each do |index|
      players.each do |player|
        calculate_player_variance(player, player_stat_hash, week, season)
      end

      # Iterate, ignoring Week 17 data as it's not super valuable
      week += 1
      if (week == 17)
        week = 1
        season += 1
      end
    end

    team_a_variance = get_team_variance(team_a_players, player_stat_hash)
    team_b_variance = get_team_variance(team_b_players, player_stat_hash)
    team_a_total_variance = team_a_variance.values.reduce(0) { |sum, p| sum + p }
    team_b_total_variance = team_b_variance.values.reduce(0) { |sum, p| sum + p }

    # If the value is positive, it means the players in Team A's package were better, on average,
    # against the mean in their respective positions
    score = team_a_total_variance - team_b_total_variance
    puts 'Trade Score', score.round(2)
    puts 'Team A: ', team_a_variance
    puts 'Team B: ', team_b_variance
  end
end

def calculate_player_variance(player, player_stat_hash, week, season)
  # Get the top 50 Player Stats for Week 6 - 2018 (first week of trade)
  top_projected_players = PlayerStat.where(week: week, season: season)
    .joins('join players on players.id = player_stats.player_id::integer')
    .where('players.position_id = ?', player.position_id)
    .order('projected_total::float DESC')
    .limit(50)

  unless top_projected_players.blank?
    # Sum the actual scores of the top 50 projected players
    sum = top_projected_players.reduce(0) { |sum, p| sum + p.actual_total.to_f || 0 }

    # Find the average score of the best projected players
    average = sum / 50;

    # Determine the variance of the player being analyzed
    player_week_stat = PlayerStat.where(player_id: player.to_param, week: week, season: season).first

    unless player_week_stat.nil?
      actual_total = player_week_stat.actual_total.to_f
      variance = actual_total - average

      (player_stat_hash[player.full_name] ||= []) << variance
    end
  end
end

def get_team_variance(players, player_stat_hash)
  total_variance_team = {}
  players.each do |player|
    stats = player_stat_hash[player]
    total_variance = stats.reduce(0) { |sum, p| sum + p }
    average_variance = total_variance / stats.count
    total_variance_team[player] ||= 0
    total_variance_team[player] += average_variance.round(4)
  end
  total_variance_team
end


