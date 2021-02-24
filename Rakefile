require "dotenv"
require "rake/testtask"

require_relative "./google_photos_backup"

Dotenv.load

ENV["CONTEXT"] = "production"

desc "Runs the authorization process with google photos"
task :auth do
  `ruby auth.rb`
end

task :prom_test do
  @prometheus = Prometheus::Client.registry
  # @counter = @prometheus.counter(:photo_test, docstring: "A counter of Google photos media items processed.")
  @counter = Prometheus::Client::Counter.new(:photo_test, docstring: 'A counter of HTTP requests made')
  puts "current counter: #{@counter.get}"
  @counter.increment(by: rand(10))
  r = Prometheus::Client::Push.new("push-photos", nil, "http://admin:admin@localhost:9091").add(@prometheus)
  puts r
  sleep 0
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
