require "dotenv"
require "rake/testtask"

require_relative "./google_photos_backup"

Dotenv.load

ENV["CONTEXT"] = "production"

desc "Runs the authorization process with google photos"
task :auth do
  `ruby auth.rb`
end

desc "Run the main processing task."
task :process do
  MediaBackupProcessor.new.execute!
end

desc "Sets up a new DB"
task :db_setup do
  DB.new.create!
end

Rake::TestTask.new(:test) do |t|
  t.libs << "spec"
  t.libs << "lib"
  t.test_files = FileList["spec/**/*_spec.rb"]
end

task :default => :test
