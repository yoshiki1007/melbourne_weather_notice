require 'uri'
require 'net/https'

class OfficialLine
  def self.line_send(weather_text)
    uri = URI.parse('https://api.line.me/v2/bot/message/broadcast')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    req = Net::HTTP::Post.new(uri.request_uri)
    req['Content-type'] = ENV['CONTENT_TYPE']
    req["Authorization"] = ENV['LINE_CHANNEL_ACCESS_TOKEN']

    body = {
      "messages": [
        {
          "type" => "text",
          "text" => weather_text,
          "emojis" => [
            {
              "index": 14,
              "productId": "5ac21184040ab15980c9b43a",
              "emojiId": "024"
            }
          ]
        }
      ]
    }.to_json

    req.body = body

    begin
      res = http.request(req)
      res.body
    rescue => e
      pp e.message
    end
  end
end
