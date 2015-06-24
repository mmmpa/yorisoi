begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end


require 'rake'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'


def run_in_dummy_app(command)
  success = system("cd spec/dummy && #{command}")
  raise "#{command} failed" unless success
end


task "default" => "spec:test"

namespace "spec" do
  task "test" do
    puts "Running rake in dummy app"
    ENV["RAILS_ENV"] = "test"
    run_in_dummy_app "rspec"
  end
end

namespace "db" do
  desc "Set up databases for integration testing"
  task "setup" do
    puts "Setting up databases"
    run_in_dummy_app "rm -f db/*.sqlite3"
  end
end