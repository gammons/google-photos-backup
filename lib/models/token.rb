class Token
  attr_accessor :access_token, :refresh_token, :expiry

  def self.load_creds
    new(refresh_token: ENV["REFRESH_TOKEN"])
  end

  def initialize(access_token: nil, refresh_token:, expiry: nil)
    @access_token = access_token
    @refresh_token = refresh_token

    @expiry = expiry
    @expiry = Time.parse(expiry) if expiry.is_a?(String)
  end

  def expired?
    (expiry && (expiry < Time.now)) || access_token.nil?
  end

  def write_creds!
    f = File.open("refresh_token.txt", "w")
    f << refresh_token
    f.close
  end
end
