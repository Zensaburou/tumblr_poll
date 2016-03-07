require 'active_record'
require_relative 'blog_poller'
require_relative 'tumblr_poller'
require_relative 'tumblr_interface'

# ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'database.db'
)

class Blog < ActiveRecord::Base
  has_many :posts
end

class Post < ActiveRecord::Base
  belongs_to :blog
end
