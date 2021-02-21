require "faraday"
require "byebug"

require_relative "./../models/media_item"

module GooglePhotos
  class Api
    def get_media_items(token, page_token = nil)
      url = "https://photoslibrary.googleapis.com/v1/mediaItems"
      unless page_token.nil?
        url = "https://photoslibrary.googleapis.com/v1/mediaItems?pageToken=#{page_token}"
      end

      resp = Faraday.get(url) do |req|
        req.headers["Content-type"] = "application/json"
        req.headers["Authorization"] = "Bearer #{token.access_token}"
      end
      res = JSON.parse(resp.body)

      @next_page_token = res["nextPageToken"]

      items = []

      res["mediaItems"].each do |item|
        mi = MediaItem.new
        mi.id = item["id"]
        mi.url = item["baseUrl"]
        mi.mime_type = item["mimeType"]
        mi.width = item["mediaMetadata"]["width"]
        mi.height = item["mediaMetadata"]["height"]
        items << mi
      end

      items
    end

    def next_page_token
      @next_page_token
    end
  end
end
