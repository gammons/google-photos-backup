class FileHandler
  def process(media_item)
    media_item.download
    f = File.open("/tmp/#{media_item.file_name}", "w")
    f << media_item.data
    f.close
  end
end
