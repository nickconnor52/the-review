namespace :data do
  desc 'Generate Draft Picks'
  task :generate_picks => :environment do
    year = '2021'
    draft = Draft.find_or_initialize_by(year: year)
    draft.save
    Team.all.each do |t|
      (1..3).each do |round_number|
        pick = DraftPick.find_or_create_by(draft_id: draft.to_param, round_number: round_number, team_id: t.to_param)
        pick.original_pick_team_id = t.to_param
        pick.save
      end
    end
  end
end
