require_relative '../spec_helper'

RSpec.describe OverlapService do
  let(:subject) { OverlapService.new }
  let(:first_blog) { Blog.create(url: 'spam') }
  let(:second_blog) { Blog.create(url: 'baz') }

  describe :calculate_overlap do
  end

  describe :unique_source_count_for do
    it 'returns count of unique source titles' do
      Post.create(blog_id: first_blog.id, source_title: '')
      Post.create(blog_id: first_blog.id, source_title: nil)
      Post.create(blog_id: first_blog.id, source_title: 'foo')
      Post.create(blog_id: first_blog.id, source_title: 'foo')

      expect(subject.unique_source_count_for(first_blog)).to eq 1
    end
  end

  describe :source_count_for do
    it 'returns count of times a source appears in a blog' do
      Post.create(blog_id: first_blog.id, source_title: 'bar')
      Post.create(blog_id: first_blog.id, source_title: 'bar')
      Post.create(blog_id: first_blog.id, source_title: 'foo')

      expect(subject.source_count_for(first_blog, 'bar')).to be 2
    end
  end

  describe :reblogged_post_count_for do
    it 'returns a count of posts with a source title' do
      Post.create(blog_id: first_blog.id, source_title: 'bar')
      Post.create(blog_id: first_blog.id, source_title: 'foo')
      Post.create(blog_id: first_blog.id, source_title: '')
      Post.create(blog_id: first_blog.id, source_title: nil)

      expect(subject.reblogged_post_count_for(first_blog)).to be 2
    end
  end

  describe :simpson_index_for do
    it 'sums the sub indices' do
      Post.create(blog_id: first_blog.id, source_title: 'bar')
      Post.create(blog_id: first_blog.id, source_title: 'bar')
      Post.create(blog_id: first_blog.id, source_title: 'bar')
      Post.create(blog_id: first_blog.id, source_title: 'foo')
      Post.create(blog_id: first_blog.id, source_title: 'foo')
      Post.create(blog_id: first_blog.id, source_title: nil)

      result = subject.simpson_index_for(first_blog)
      expect(result).to eq 2 / 5
    end
  end

  describe :simpson_sub_index_for do
    it 'calculates the index correctly' do
      Post.create(blog_id: first_blog.id, source_title: 'bar')
      Post.create(blog_id: first_blog.id, source_title: 'bar')
      Post.create(blog_id: first_blog.id, source_title: 'foo')
      Post.create(blog_id: first_blog.id, source_title: nil)

      result = subject.simpson_sub_index_for(first_blog, 'bar')
      expect(result).to eq 1 / 3
    end
  end

  describe :source_count_product do
    it 'returns product of the source counts' do
      Post.create(blog_id: first_blog.id, source_title: 'bar')
      Post.create(blog_id: first_blog.id, source_title: 'bar')
      Post.create(blog_id: second_blog.id, source_title: 'bar')
      Post.create(blog_id: second_blog.id, source_title: 'foo')

      result = subject.source_count_product(first_blog, second_blog, 'bar')
      expect(result).to eq 2
    end
  end

  describe :series do
    it 'returns the sum of the source count products for each unique post' do
      Post.create(blog_id: first_blog.id, source_title: 'bar')
      Post.create(blog_id: first_blog.id, source_title: 'foo')
      Post.create(blog_id: second_blog.id, source_title: 'bar')
      Post.create(blog_id: second_blog.id, source_title: 'bar')
      Post.create(blog_id: second_blog.id, source_title: 'foo')

      result = subject.series(first_blog, second_blog)
      expect(result).to eq 3
    end
  end
end
