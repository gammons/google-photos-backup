class MediaItem < ActiveRecord::Base
  attr_reader :data

  def download
    flag = mime_type == "image/jpeg" ? "=d" : "=dv"
    f = Faraday.new(url: url + flag) do |faraday|
      faraday.use FaradayMiddleware::FollowRedirects
    end
    resp = f.get

    @data = resp.body
  end

  def file_name
    photo_id + "." + mime_type.split("/")[1]
  end

  def to_s
    "#{photo_id} - #{mime_type}"
  end
end
