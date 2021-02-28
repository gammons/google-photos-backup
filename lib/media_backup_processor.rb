class MediaBackupProcessor
  attr_reader :logger

  def initialize
    @logger = Logger.new(STDOUT)
    @metrics = Metrics.new
    @done = false
    @mutex = Mutex.new
  end

  def execute!(handler_class)
    handler = handler_class.new
    logger.info("Beginning to get media items")
    api = GooglePhotos::Api.new

    loop do
      logger.info("Processing next page")
      photos = api.get_media_items(token, api.next_page_token)

      process_photos_page(photos, handler)

      break if api.next_page_token.nil? || @done
    end

    @metrics.log_successful_run
  end

  private

  def process_photos_page(photos, handler)
    threads = photos.map do |item|
      logger.info("Processing item #{item}")
      process_photo(handler, item)
    end

    threads.compact.each(&:join)

    @metrics.sync
  end

  def process_photo(handler, item)
    if MediaItem.exists?(photo_id: item.photo_id)
      if ENV["OVERWRITE"].blank?
        logger.info("This file was seen before.  Stopping execution.")
        @done = true
      end
      nil
    else
      Thread.new do
        @mutex.synchronize { item.save }
        handler.process(item)
        @metrics.count_success
      end
    end
  end

  def token
    t = Token.load_creds
    t = GooglePhotos::TokenHandler.new.refresh_access_token(t) if t.expired?
    t
  end
end
