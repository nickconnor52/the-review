class User < ActiveRecord::Base
  has_secure_password
  has_many :posts

  validates :email, presence: true, uniqueness: true

  def team
    Team.find_by(user_id: id)
  end
end
