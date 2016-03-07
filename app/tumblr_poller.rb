require_relative 'application'

class TumblrPoller
  def poll_blogs(blogs, newest_timestamp, oldest_timestamp)
    blogs.each { |blog| parse_posts(blog, newest_timestamp, oldest_timestamp) }
  end
end
