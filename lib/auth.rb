require "byebug"
require "dotenv"
require "faraday"
require "sinatra"

require_relative "./token_handler"

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
  token = TokenHandler.new.exchange_code_for_token(params[:code])
  token.write_creds!

  if response.status == 200
    "All set!"
  else
    "Something went wrong... #{response.body}"
  end
end
