#!/usr/bin/env ruby

require "json"
require "aws-sdk-s3"
require "logger"
require "faraday"
require "faraday_middleware"
require "byebug"

require_relative "./db/db"
require_relative "./models/token"
require_relative "./google_photos/token_handler"
require_relative "./google_photos/api"

class NullHandler
  def process(media_item)
    media_item.download
    logger.info("Doing nothing with the media item")
  end
end

class FileHandler
  def process(media_item)
    media_item.download
    f = File.open("/tmp/#{media_item.file_name}", "w")
    f << media_item.data
    f.close
  end
end

class S3Handler
  def initialize
    @s3 = Aws::S3::Client.new
    @logger = Logger.new(STDOUT)
  end

  def process(media_item)
    media_item.download

    @logger.info("Storing item to S3")
    @s3.put_object(
      body: media_item.data,
      bucket: ENV["S3_BUCKET"],
      key: media_item.file_name,
      # storage_class: "GLACIER",
      metadata: {
        photo_id: media_item.photo_id,
        url: media_item.url,
        created_at: media_item.created_at
      }
    )
  end
end


class MediaBackupProcessor
  attr_reader :logger

  def initialize
    @logger = Logger.new(STDOUT)
  end

  def execute!(handler = S3Handler.new)
    logger.info("Beginning to get media items")
    api = GooglePhotos::Api.new

    MediaItem.destroy_all

    loop do
      logger.info("Processing next page")
      photos = api.get_media_items(token, api.next_page_token)

      threads = photos.map do |item|
        Thread.new do
          logger.info("Processing item #{item}")
          next if MediaItem.exists?(photo_id: item.photo_id) && ENV["OVERWRITE"].blank?

          item.save
          handler.process(item)
        end
      end
      threads.each(&:join)

      break if api.next_page_token.nil?
    end
  end

  private

  def token
    t = Token.load_creds
    t = GooglePhotos::TokenHandler.new.refresh_access_token(t) if t.expired?
    t
  end
end
