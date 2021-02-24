require "active_record"
require "aws-sdk-s3"
require "faraday"
require "faraday_middleware"
require "json"
require "logger"
require "prometheus/client"
require "prometheus/client/push"
require "sqlite3"
require "time"

require "byebug"

Dir["./lib/db/*.rb"].sort.each { |file| require file }
Dir["./lib/models/*.rb"].sort.each { |file| require file }
Dir["./lib/google_photos/*.rb"].sort.each { |file| require file }
Dir["./lib/handlers/*.rb"].sort.each { |file| require file }

require "./lib/media_backup_processor"
