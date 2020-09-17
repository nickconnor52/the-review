class Draft < ActiveRecord::Base
  has_many :draft_picks, -> { order('overall_pick_number::integer ASC') }
end
