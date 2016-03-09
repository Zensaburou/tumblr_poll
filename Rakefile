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
