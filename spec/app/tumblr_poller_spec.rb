require_relative '../spec_helper'

RSpec.describe TumblrPoller do
  let(:subject) { TumblrPoller.new }
  let(:blog) { Blog.create!(url: 'bar') }
  let(:second_blog) { Blog.create!(url: 'baz') }
  let(:completed_blog) { Blog.create!(url: 'foo', completed: true) }

  describe :poll_tumblr do
    it 'updates each blog when finished' do
      blog
      second_blog
      allow_any_instance_of(BlogPoller).to receive(:poll_posts)
      subject.poll_tumblr

      blog.reload
      second_blog.reload
      expect(blog.completed).to be_truthy
      expect(second_blog.completed).to be_truthy
    end
  end

  describe :incomplete do
    it 'includes blogs where completed is false' do
      expect(subject.incomplete_blogs.include?(blog)).to be_truthy
    end

    it 'does not include completed blogs' do
      expect(subject.incomplete_blogs.include?(completed_blog)).to be_falsey
    end
  end

  describe :blog_poller do
    before do
      ENV['NEWEST_TIMESTAMP'] = '10'
      ENV['OLDEST_TIMESTAMP'] = '1'
    end

    context 'polling has not started for blog' do
      it 'instantiates blog_poller with the existing timestamp' do
        blog
        expect(BlogPoller).to receive(:new).with(blog, 10, 1)
        subject.blog_poller(blog)
      end
    end

    context 'polling incomplete for blog' do
      let(:older_post) { Post.create(blog_id: blog.id, timestamp: 3) }
      let(:post) { Post.create(blog_id: blog.id, timestamp: 5) }

      it 'instantiates blog_poller with the existing timestamp' do
        older_post
        post
        expect(BlogPoller).to receive(:new).with(blog, 3, 1)
        subject.blog_poller(blog)
      end
    end
  end
end
