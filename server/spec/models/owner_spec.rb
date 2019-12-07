RSpec.describe Owner, type: :model do
  describe 'is created' do
    it 'can be queried from the database' do
      Owner.create do |owner|
        owner.first_name = 'Nick'
        owner.last_name = 'Connor'
        owner.city = 'Houston'
        owner.season_joined = '2017'
      end
      expect(Owner.all.count).to eq 1
    end
  end
end
