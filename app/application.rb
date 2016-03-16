require 'active_record'
require_relative 'blog_poller'
require_relative 'tumblr_poller'
require_relative 'tumblr_interface'
require_relative 'overlap_service'
require_relative 'simpson_service'

require_relative './models/blog'
require_relative './models/post'
require_relative './models/comparison'

# ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/database.db'
)
