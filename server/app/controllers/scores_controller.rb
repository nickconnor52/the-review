class ScoresController < ApplicationController
  def calculate_best_ball
    games = Game.where(season: 2020).all
    position_hash = {}
    position_hash['qb'] = Position.select(:id).find_by_name('Quarterback').to_param
    position_hash['rb'] = Position.select(:id).find_by_name('Running Back').to_param
    position_hash['wr'] = Position.select(:id).find_by_name('Wide Receiver').to_param
    position_hash['te'] = Position.select(:id).find_by_name('Tight End').to_param
    position_hash['flex'] = [position_hash['rb'], position_hash['wr'], position_hash['te']]
    team_scores = Hash.new(0)
    games.each do |game|
      # TODO: CACHE GAME BEST BALL SCORE IN DB -- QUERY FIRST PRIOR TO DOING THE REST OF THIS CALCULATION
      team_ids = [game.home_team_id, game.away_team_id]
      player_stats = PlayerStat.where(week: game.week, season: game.season, team_id: team_ids)
      home_team_players = player_stats.select {|p| p.team_id === game.home_team_id }
      away_team_players = player_stats.select {|p| p.team_id === game.away_team_id }

      home_team_owner = game.home_team.current_owner.first_name
      away_team_owner = game.away_team.current_owner.first_name
      team_scores[home_team_owner] = (team_scores[home_team_owner] + calculate_team_best_ball(home_team_players, position_hash)).round(2)
      team_scores[away_team_owner] = (team_scores[away_team_owner] + calculate_team_best_ball(away_team_players, position_hash)).round(2)
    end

    render :json => { best_ball_score: team_scores, season: 2020 }
  end

  private

  def calculate_team_best_ball(player_stats, position_hash)
    remaining_players = player_stats

    qb_score = get_position_score(remaining_players, [position_hash['qb']], 1)
    rb_score = get_position_score(remaining_players, [position_hash['rb']], 2)
    wr_score = get_position_score(remaining_players, [position_hash['wr']], 2)
    te_score = get_position_score(remaining_players, [position_hash['te']], 1)
    flex_score = get_position_score(remaining_players, position_hash['flex'], 2)

    return [qb_score, rb_score, wr_score, flex_score].reduce(:+)
  end

  def get_position_score(remaining_players, position_ids, count)
    player_scores = remaining_players.select { |p| position_ids.include?(p.player.position_id) }
    .sort_by { |p| p.actual_total.to_f }
    .reverse
    .first(count)

    removable_player_ids = player_scores.map(&:player_id)
    remaining_players = remaining_players.reject {|p| removable_player_ids.include?(p.player_id)}

    return player_scores.reduce(0) { |sum, p| sum + p.actual_total.to_f }
  end
end
