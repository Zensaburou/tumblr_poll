require_relative 'application'

class TumblrPoller
  def poll_tumblr
    poller_array = incomplete_blogs.map { |b| blog_poller(b) }
    run_pollers(poller_array)
  end

  def run_pollers(blog_poller_array)
    threads = []
    blog_poller_array.each do |poller|
      threads << Thread.new do
        poller.poll_posts
        poller.blog.update(completed: true)
      end
    end
    threads.map(&:join)
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
