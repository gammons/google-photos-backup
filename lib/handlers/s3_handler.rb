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
