require "dotenv"

Dotenv.load

require_relative "./lib/db"
require_relative "./lib/photo_processor"

desc "Runs the photo processor"
task :auth do
  `ruby lib/auth.rb`
end

task :process do
  PhotoProcessor.new.execute!
  #PhotoProcessor.new.s3_test
end

desc "Sets up a new DB"
task :db_setup do
  DB.new.create!
end
