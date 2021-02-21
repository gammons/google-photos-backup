require "minitest/autorun"

require_relative "../../lib/models/token"

describe Token do
  it "news up a token" do
    t = Token.new(access_token: "asdf", refresh_token: "fdsa", expiry: Time.now)

    _(t.access_token).must_equal("asdf")
    _(t.refresh_token).must_equal("fdsa")
  end

  it "#expired?" do
    File.delete("creds_test.json") if File.exist?("creds_test.json")
    t = Token.new(access_token: "asdf", refresh_token: "fdsa", expiry: Time.now)
    t.write_creds!
    token = Token.load_creds

    token.expired?
  end


  it "#write_creds" do
    File.delete("creds_test.json") if File.exist?("creds_test.json")

    t = Token.new(access_token: "asdf", refresh_token: "fdsa", expiry: Time.now)
    t.write_creds!

    _(File.exist?("creds_test.json")).must_equal true
    _(JSON.parse(File.read("creds_test.json"))["access_token"]).must_equal "asdf"

    File.delete("creds_test.json")
  end

  it "#load_creds" do
    File.delete("creds_test.json") if File.exist?("creds_test.json")

    t = Token.new(access_token: "asdf", refresh_token: "fdsa", expiry: Time.now)
    t.write_creds!

    token = Token.load_creds

    _(token.access_token).must_equal "asdf"

    File.delete("creds_test.json")
  end
end
