module GooglePhotos
  class TokenHandler
    def exchange_code_for_token(code)
      query = {
        code: code,
        redirect_uri: "http://localhost:4567/callback",
        client_id: ENV["GOOGLE_CLIENT_ID"],
        client_secret: ENV["GOOGLE_CLIENT_SECRET"],
        scope: "",
        grant_type: "authorization_code"
      }

      make_request(query)
    end

    def refresh_access_token(token)
      query = {
        client_id: ENV["GOOGLE_CLIENT_ID"],
        client_secret: ENV["GOOGLE_CLIENT_SECRET"],
        grant_type: "refresh_token",
        refresh_token: token.refresh_token
      }

      new_token = make_request(query)

      # persist the refresh token between refreshes.
      new_token.refresh_token = token.refresh_token
      new_token
    end

    private

    def make_request(query)
      resp = Faraday.post("https://oauth2.googleapis.com/token", query)
      if resp.status != 200
        puts resp.body
        raise "Something went wrong with exchanging code for token"
      end

      parsed = JSON.parse(resp.body)
      Token.new(access_token: parsed["access_token"], refresh_token: parsed["refresh_token"], expiry: Time.now + 3600)
    end
  end
end
