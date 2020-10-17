class Comment < ActiveRecord::Base
  belongs_to :post

  def child_comments
    Comment.where(parent_comment_id: parent_comment_id) unless parent_comment_id.nil?
  end

  def author
    User.find(user_id) unless user_id.nil?
  end
end
