class Transaction < ActiveRecord::Base
  has_many :transaction_pieces
  has_and_belongs_to_many :teams
end
