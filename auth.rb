require "sinatra"

require "./google_photos_backup"

Dotenv.load

link = "http://localhost:4567"
if RbConfig::CONFIG["host_os"] =~ /mswin|mingw|cygwin/
  system "start #{link}"
elsif RbConfig::CONFIG["host_os"] =~ /darwin/
  system "open #{link}"
elsif RbConfig::CONFIG["host_os"] =~ /linux|bsd/
  system "xdg-open #{link}"
end

get "/" do
  query = {
    redirect_uri: "http://localhost:4567/callback",
    prompt: "consent",
    response_type: "code",
    client_id: ENV["GOOGLE_CLIENT_ID"],
    scope: "https://www.googleapis.com/auth/photoslibrary.readonly",
    access_type: "offline"
  }

  url = URI::HTTPS.build(
    host: "accounts.google.com",
    path: "/o/oauth2/v2/auth",
    query: URI.encode_www_form(query)
  )
  "<a href='#{url}'>Authorize with google</a>"
end

get "/callback" do
  token = GooglePhotos::TokenHandler.new.exchange_code_for_token(params[:code])

  if response.status == 200
    token.write_creds!
    "All set!"
  else
    "Something went wrong... #{response.body}"
  end
end
