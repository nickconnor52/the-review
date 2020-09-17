class Player < ActiveRecord::Base
  has_and_belongs_to_many :rosters
  belongs_to :pro_team, optional: true
  belongs_to :position
  has_many :transaction_pieces
end
