class MediaBackupProcessor
  attr_reader :logger

  def initialize
    @logger = Logger.new(STDOUT)
  end

  def execute!(handler = NullHandler.new)
    logger.info("Beginning to get media items")
    api = GooglePhotos::Api.new

    MediaItem.destroy_all

    loop do
      logger.info("Processing next page")
      photos = api.get_media_items(token, api.next_page_token)

      done = false
      threads = photos.map do |item|
        logger.info("Processing item #{item}")
        if MediaItem.exists?(photo_id: item.photo_id)
          if ENV["OVERWRITE"].blank?
            logger.info("This file was seen before.  Stopping execution.")
            done = true
          end
          nil
        else
          Thread.new do
            item.save
            handler.process(item)
          end
        end
      end
      threads.compact.each(&:join)

      break if api.next_page_token.nil? || done
    end
  end

  private

  def token
    t = Token.load_creds
    t = GooglePhotos::TokenHandler.new.refresh_access_token(t) if t.expired?
    t
  end
end
