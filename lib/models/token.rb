class Token
  attr_accessor :access_token, :refresh_token, :expiry

  def self.load_creds
    json = JSON.parse(File.read("creds_#{ENV['CONTEXT']}.json"))
    new(access_token: json["access_token"],
        refresh_token: json["refresh_token"],
        expiry: json["expiry"])
  end

  def initialize(access_token:, refresh_token:, expiry:)
    @access_token = access_token
    @refresh_token = refresh_token

    @expiry = expiry
    @expiry = Time.parse(expiry) if expiry.is_a?(String)
  end

  def expired?
    expiry < Time.now
  end

  def write_creds!
    h = { access_token: access_token, refresh_token: refresh_token, expiry: expiry }
    json = JSON.generate(h)
    f = File.open("creds_#{ENV['CONTEXT']}.json", "w")
    f << json
    f.close
  end
end
