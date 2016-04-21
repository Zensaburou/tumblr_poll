require_relative 'application'

class TumblrPoller
  def poll_tumblr
    incomplete_blogs.each do |b|
      blog_poller(b).poll_posts
      b.update(completed: true)
    end
  end

  def incomplete_blogs
    Blog.where(completed: false)
  end

  def blog_poller(blog)
    started?(blog) ? incomplete_poller(blog) : new_poller(blog)
  end

  def started?(blog)
    blog.posts.any?
  end

  def incomplete_poller(blog)
    oldest_polled_timestamp = blog.posts.minimum(:timestamp)
    BlogPoller.new(
      blog,
      oldest_polled_timestamp,
      ENV['OLDEST_TIMESTAMP'].to_i
    )
  end

  def new_poller(blog)
    BlogPoller.new(
      blog,
      ENV['NEWEST_TIMESTAMP'].to_i,
      ENV['OLDEST_TIMESTAMP'].to_i
    )
  end
end
