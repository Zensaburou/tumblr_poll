require_relative 'application'
require_relative 'tumblr_interface'

class BlogPoller
  def initialize(blog, newest_timestamp=0, oldest_timestamp=0)
    @blog = blog
    @newest_timestamp = newest_timestamp
    @oldest_timestamp = oldest_timestamp
  end

  def poll_posts
    status = ''
    offset = 0
    until status == 'complete'
      posts = post_list(offset)
      status = parse_post_list(posts)
      offset += 20
    end
  end

  def post_list(offset=0)
    TumblrInterface.new.client.posts(@blog.url, limit: 20, offset: offset)['posts']
  end

  def parse_post_list(posts)
    posts.each do |post|
      next if post_too_recent?(post)
      return 'complete' if post_too_old?(post)
      save_post(post)
    end
  end

  def post_too_recent?(post)
    post['timestamp'] > @newest_timestamp
  end

  def post_too_old?(post)
    post['timestamp'] < @oldest_timestamp
  end

  def save_post(post)
    Post.create(post_attrs(post))
  end

  def post_attrs(post_json)
    {
      post_id: post_json['id'],
      post_url: post_json['post_url'],
      note_count: post_json['note_count'],
      date: post_json['date'],
      post_type: post_json['type'],
      timestamp: post_json['timestamp'],
      source_title: post_json['source_title'],
      is_reblogged: reblogged?(post_json),
      blog_id: @blog.id
    }
  end

  def reblogged?(post_json)
    post_json['source_title'].to_s.empty? ? 0 : 1
  end
end
