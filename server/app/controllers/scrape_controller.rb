class ScrapeController < ApplicationController
  def base_espn_url
    year = params[:year].blank? ? '2020' : params[:year]

    "https://fantasy.espn.com/apis/v3/games/ffl/seasons/#{year}/segments/0/leagues/#{ENV['LEAGUE_ID']}?"
  end

  def current_year_url
    year = Date.today.year

    "https://fantasy.espn.com/apis/v3/games/ffl/seasons/#{year}/segments/0/leagues/#{ENV['LEAGUE_ID']}?"
  end

  def history_url
    "https://fantasy.espn.com/apis/v3/games/ffl/leagueHistory/#{ENV['LEAGUE_ID']}?"
  end

  def base_sleeper_url
    'https://api.sleeper.app/v1'
  end

  def league_url
    "#{base_sleeper_url}/league/#{league_id}"
  end

  def league_id
    '669956719320846336'
  end
end
