require 'csv'

namespace :draft do
  desc 'import draft order'
  draft_order = CSV.parse(File.read("./public/drafts/2019_draft_order.csv"), headers: true)

  task :import_order => :environment do
    draft = Draft.find_by(year: '2019')

    overall_pick_number = 1

    (1..3).each do |round_number|
      draft_order.each do |order|
        pick_number = order[0]
        owner_first_name = order[1]

        team_id = Owner.find_by(first_name: owner_first_name).team_id
        draft_pick = DraftPick.find_by(draft_id: draft.to_param, original_pick_team_id: team_id, round_number: round_number)

        draft_pick.overall_pick_number = overall_pick_number
        draft_pick.round_pick_number = pick_number

        draft_pick.save

        overall_pick_number += 1
      end
    end
  end
end
