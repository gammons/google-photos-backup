#!/usr/bin/env ruby

require "faraday"
require "byebug"
require "json"
require "aws-sdk-s3"

class PhotoProcessor
  def execute!
    puts "token = ", ENV["TOKEN"]
    resp = Faraday.get("https://photoslibrary.googleapis.com/v1/mediaItems") do |req|
      req.headers["Content-type"] = "application/json"
      req.headers["Authorization"] = "Bearer #{ENV["TOKEN"]}"
    end
    res = JSON.parse(resp.body)
    puts res

    puts res["mediaItems"][0]

    page_token = res["nextPageToken"]

    resp = Faraday.get("https://photoslibrary.googleapis.com/v1/mediaItems?pageToken=#{page_token}") do |req|
      req.headers["Content-type"] = "application/json"
      req.headers["Authorization"] = "Bearer #{ENV["TOKEN"]}"
    end
    res = JSON.parse(resp.body)

    puts "next page"
    puts res["mediaItems"][0]

    byebug
    sleep 0
  end

  def s3_test
    s3 = Aws::S3::Client.new
    resp = s3.list_buckets
    puts resp

  end
end
