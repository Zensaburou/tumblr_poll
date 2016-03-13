task default: %w(test)

task :test do
  sh 'bundle exec rspec spec'
end

namespace :db do
  task :drop do
    sh 'rm database.db'
  end

  task :create do
    sh("bundle exec ruby #{File.dirname(__FILE__)}" + '/app/db_migrations.rb')
  end

  task reset: [:drop, :create]
end

namespace :tumblr do
  task :poll do
    require_relative 'app/application'
    TumblrPoller.new.poll_tumblr
  end

  task :simpsons do
    require_relative 'app/application'
    SimpsonService.new.calculate_all_indices
  end

  task :overlaps do
    require_relative 'app/application'
    OverlapService.new.calculate_all_overlaps
  end
end
