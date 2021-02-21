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

desc "refresh the access token."
task :refresh_access_token do
  token = Token.load_creds
  token = GooglePhotos::TokenHandler.new.refresh_access_token(token)
  token.write_creds!
end

task :process do
  MediaBackupProcessor.new.execute!
  # PhotoProcessor.new.s3_test
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
