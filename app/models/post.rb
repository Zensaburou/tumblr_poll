require_relative '../application'

class Post < ActiveRecord::Base
  belongs_to :blog
end
