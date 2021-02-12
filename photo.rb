#!/usr/bin/env ruby

require "dotenv"
require "faraday"
require "byebug"
require "json"

Dotenv.load

resp = Faraday.get("https://photoslibrary.googleapis.com/v1/mediaItems") do |req|
  req.headers["Content-type"] = "application/json"
  req.headers["Authorization"] = "Bearer #{ENV["TOKEN"]}"
end

s = JSON.parse(resp.body)
byebug
sleep 0
