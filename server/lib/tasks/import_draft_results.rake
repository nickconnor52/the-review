require 'csv'

namespace :draft do
  desc 'import draft results'
  task :import_csv => :environment do
    draft_results = CSV.parse(File.read("./public/drafts/2020_rookie_draft.csv"), headers: true)
    draft = Draft.find_or_initialize_by(year: '2020')
    draft.save

    round_number = 1
    pick_number = 1

    draft_results.each do |pick|
      overall_pick_number = pick[0]
      owner_first_name = pick[1]

      player_full_name = pick[2]

      draft_pick = DraftPick.find_or_initialize_by(draft_id: draft.to_param, overall_pick_number: overall_pick_number)

      draft_pick.round_number = round_number
      draft_pick.round_pick_number = pick_number

      player = Player.find_by(full_name: player_full_name)
      draft_pick.player_id = player.to_param

      team_id = Owner.find_by(first_name: owner_first_name).team_id
      draft_pick.team_id = team_id
      draft_pick.original_pick_team_id = team_id

      draft_pick.save

      pick_number += 1
      if pick_number == 11
        pick_number = 1
        round_number += 1
      end
    end
  end
end
