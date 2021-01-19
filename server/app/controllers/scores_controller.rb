class ScoresController < ApplicationController
  def calculate_best_ball
    games = Game.where(season: 2020).where('week::Int < ?', 13).all
    position_hash = {}
    position_hash['qb'] = Position.select(:id).find_by_name('Quarterback').to_param
    position_hash['rb'] = Position.select(:id).find_by_name('Running Back').to_param
    position_hash['wr'] = Position.select(:id).find_by_name('Wide Receiver').to_param
    position_hash['te'] = Position.select(:id).find_by_name('Tight End').to_param
    position_hash['flex'] = [position_hash['rb'], position_hash['wr'], position_hash['te']]
    team_scores = Hash.new(0)
    actual_scores = Hash.new(0)
    games.each do |game|
      team_ids = [game.home_team_id, game.away_team_id]

      home_team_owner = game.home_team.current_owner.first_name
      away_team_owner = game.away_team.current_owner.first_name

      home_team_week_score = 0
      away_team_week_score = 0

      use_cache = !params[:recalculate]

      if use_cache && (game.home_best_ball_score && game.away_best_ball_score)
        home_team_week_score = game.home_best_ball_score
        away_team_week_score = game.away_best_ball_score
      else
        player_stats = PlayerStat.where(week: game.week, season: game.season, team_id: team_ids)
        home_team_players = player_stats.select {|p| p.team_id === game.home_team_id }
        away_team_players = player_stats.select {|p| p.team_id === game.away_team_id }

        home_team_week_score = calculate_team_best_ball(home_team_players, position_hash)
        away_team_week_score = calculate_team_best_ball(away_team_players, position_hash)

        game.home_best_ball_score = home_team_week_score
        game.away_best_ball_score = away_team_week_score
        game.save!
      end

      team_scores[home_team_owner] = (team_scores[home_team_owner] + home_team_week_score).round(2)
      team_scores[away_team_owner] = (team_scores[away_team_owner] + away_team_week_score).round(2)
      actual_scores[home_team_owner] = (actual_scores[home_team_owner] + game.home_score.to_f).round(2)
      actual_scores[away_team_owner] = (actual_scores[away_team_owner] + game.away_score.to_f).round(2)
    end

    render :json => { best_ball_score: team_scores, actual_total_score: actual_scores, season: 2020 }
  end

  private

  def calculate_team_best_ball(player_stats, position_hash)
    remaining_players = player_stats

    qb_score, remaining_players = get_position_score(remaining_players, [position_hash['qb']], 1)
    rb_score, remaining_players = get_position_score(remaining_players, [position_hash['rb']], 2)
    wr_score, remaining_players = get_position_score(remaining_players, [position_hash['wr']], 2)
    te_score, remaining_players = get_position_score(remaining_players, [position_hash['te']], 1)
    flex_score, remaining_players = get_position_score(remaining_players, position_hash['flex'], 2)

    return [qb_score, rb_score, wr_score, flex_score].reduce(:+)
  end

  def get_position_score(remaining_players, position_ids, count)
    player_scores = remaining_players.select { |p| position_ids.include?(p.player.position_id) }
    .sort_by { |p| p.actual_total.to_f }
    .reverse
    .first(count)

    removable_player_ids = player_scores.map(&:player_id)
    remaining_players = remaining_players.reject {|p| removable_player_ids.include?(p.player_id)}

    return player_scores.reduce(0) { |sum, p| sum + p.actual_total.to_f }, remaining_players
  end
end
