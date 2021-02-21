#!/usr/bin/env ruby

require "json"
require "aws-sdk-s3"

require_relative "./db/db"
require_relative "./models/token"
require_relative "./google_photos/token_handler"
require_relative "./google_photos/api"

class MediaBackupProcessor
  def execute!
    api = GooglePhotos::Api.new
    photos = api.get_media_items(token)
    byebug
    sleep 0
  end

  def s3_test
    s3 = Aws::S3::Client.new
    resp = s3.list_buckets
    puts resp
  end

  private

  def token
    t = Token.load_creds
    t = GooglePhotos::TokenHandler.new.refresh_access_token(t) if t.expired?
    t
  end
end
