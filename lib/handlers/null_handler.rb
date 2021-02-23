class NullHandler
  def initialize
    @logger = Logger.new(STDOUT)
  end

  def process(media_item)
    media_item.download
    @logger.info("Doing nothing with the media item")
  end
end
