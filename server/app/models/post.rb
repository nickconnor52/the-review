class Post < ActiveRecord::Base
  attr_accessor :body

  belongs_to :user
end
