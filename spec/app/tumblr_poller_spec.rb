require_relative '../spec_helper'

RSpec.describe TumblrPoller do
  describe :incomplete do
    before do
      @completed_blog = Blog.create(url: 'foo', completed: true)
      @incomplete_blog = Blog.create(url: 'bar')
    end

    it 'includes blogs where completed is false' do
      expect(TumblrPoller.new.incomplete_blogs.include?(@incomplete_blog)).to be_truthy
    end

    it 'does not include completed blogs' do
      expect(TumblrPoller.new.incomplete_blogs.include?(@completed_blog)).to be_falsey
    end
  end

  describe :blog_poller do
    before do
      ENV['NEWEST_TIMESTAMP'] = '10'
      ENV['OLDEST_TIMESTAMP'] = '1'
    end

    let(:blog) { Blog.create!(url: 'bar') }

    context 'polling has not started for blog' do
      it 'instantiates blog_poller with the existing timestamp' do
        blog
        expect(BlogPoller).to receive(:new).with(blog, 10, 1)
        TumblrPoller.new.blog_poller(blog)
      end
    end

    context 'polling incomplete for blog' do
      let(:older_post) { Post.create(blog_id: blog.id, timestamp: 3) }
      let(:post) { Post.create(blog_id: blog.id, timestamp: 5) }

      it 'instantiates blog_poller with the existing timestamp' do
        older_post
        post
        expect(BlogPoller).to receive(:new).with(blog, 3, 1)
        TumblrPoller.new.blog_poller(blog)
      end
    end
  end
end
