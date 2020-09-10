class Transaction < ActiveRecord::Base
  has_many :transaction_pieces
end
