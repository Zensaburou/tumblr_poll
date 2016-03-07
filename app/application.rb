require 'active_record'

# ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'database.db'
)

class Blog < ActiveRecord::Base
  has_many :blogs
end

class Post < ActiveRecord::Base
  belongs_to :blog
end
