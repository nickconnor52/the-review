class Roster < ActiveRecord::Base
  has_and_belongs_to_many :players
end
