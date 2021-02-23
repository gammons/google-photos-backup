require "dotenv"
require "rake/testtask"

require_relative "./lib/models/token"
require_relative "./lib/google_photos/token_handler"

require_relative "./lib/media_backup_processor"
require_relative "./lib/db/db"

Dotenv.load

ENV["CONTEXT"] = "production"

desc "Runs the authorization process with google photos"
task :auth do
  `ruby lib/auth.rb`
end

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
