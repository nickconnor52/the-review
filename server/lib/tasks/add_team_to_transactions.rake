namespace :data do
  desc 'Add Teams to transaction'
  task :add_transaction_teams => :environment do
    Transaction.all.each do |transaction|
      pieces = transaction.transaction_pieces
      transaction_teams = []
      pieces.each do |piece|
        from_team_info = piece.source_team
        to_team_info = piece.receiving_team
        transaction_teams << Team.find(from_team_info.team_id) unless from_team_info.nil?
        transaction_teams << Team.find(to_team_info.team_id) unless to_team_info.nil?
      end
      transaction.teams = transaction_teams.uniq
    end
  end
end
