class ScrapeController < ApplicationController
  def base_espn_url
    year = params[:year].blank? ? Date.today.year : params[:year]

    "https://fantasy.espn.com/apis/v3/games/ffl/seasons/#{year}/segments/0/leagues/#{ENV['LEAGUE_ID']}?"
  end

  def current_year_url
    year = Date.today.year

    "https://fantasy.espn.com/apis/v3/games/ffl/seasons/#{year}/segments/0/leagues/#{ENV['LEAGUE_ID']}?"
  end

  def history_url
    "https://fantasy.espn.com/apis/v3/games/ffl/leagueHistory/#{ENV['LEAGUE_ID']}?"
  end
end
