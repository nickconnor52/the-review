class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments, -> { order('created_at ASC') }

  def comment_count
    comments.count
  end
end
