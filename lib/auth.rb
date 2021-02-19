require "byebug"
require "dotenv"
require "faraday"
require "sinatra"

Dotenv.load

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
  query = {
    code: params[:code],
    redirect_uri: "http://localhost:4567/callback",
    client_id: ENV["GOOGLE_CLIENT_ID"],
    client_secret: ENV["GOOGLE_CLIENT_SECRET"],
    scope: "",
    grant_type: "authorization_code"
  }

  resp = Faraday.post("https://oauth2.googleapis.com/token", query)
  f = File.open("creds.json", "w")
  f << JSON.parse(resp.body)

  if response.status == 200
    "All set!"
  else
    "Something went wrong... #{response.body}"
  end
end
