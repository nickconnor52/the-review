class ScrapeController < ApplicationController
  def base_espn_url
    year = params[:year].blank? ? Date.today.year : params[:year]

    "https://fantasy.espn.com/apis/v3/games/ffl/seasons/#{year}/segments/0/leagues/#{ENV['LEAGUE_ID']}?"
  end
end
