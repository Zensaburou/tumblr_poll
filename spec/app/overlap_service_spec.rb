require_relative '../spec_helper'

RSpec.describe OverlapService do
  before do
    Blog.destroy_all
    Post.destroy_all
    Comparison.destroy_all
  end

  let(:subject) { OverlapService.new }
  let(:first_blog) { Blog.create(url: 'spam') }
  let(:second_blog) { Blog.create(url: 'baz') }

  describe :calculate_all_overlaps do
    it 'calculates a comparison for every possible blog pair' do
      first_blog
      second_blog
      Blog.create(url: 'boogidy')
      allow_any_instance_of(OverlapService).to receive(:calculate_overlap) { (3 / 2) }

      subject.calculate_all_overlaps
      expect(Comparison.count).to eq 3
      expect(Comparison.first.first_blog_id).to eq first_blog.id
      expect(Comparison.first.second_blog_id).to eq second_blog.id
      expect(Comparison.first.overlap).to eq((3 / 2).to_f)
    end
  end

  describe :calculate_overlap do
    it 'returns the correct index' do
      Post.create(blog_id: first_blog.id, source_title: 'bar')
      Post.create(blog_id: first_blog.id, source_title: 'bar')
      Post.create(blog_id: first_blog.id, source_title: 'foo')

      Post.create(blog_id: second_blog.id, source_title: 'bar')
      Post.create(blog_id: second_blog.id, source_title: 'bar')
      Post.create(blog_id: second_blog.id, source_title: 'foo')
      Post.create(blog_id: second_blog.id, source_title: 'foo')

      result = subject.calculate_overlap(first_blog.id, second_blog.id)
      expect(result).to eq(3 / 2)
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
