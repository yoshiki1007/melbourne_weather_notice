require 'uri'
require 'net/https'

class OfficialLine
  def self.send(weather_text)
    line_uri = URI.parse('https://api.line.me/v2/bot/message/broadcast')
    line_http = Net::HTTP.new(line_uri.host, line_uri.port)

    line_http.use_ssl = true
    line_http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    line_req = Net::HTTP::Post.new(line_uri.request_uri)
    line_req['Content-type'] = ENV['CONTENT_TYPE']
    line_req["Authorization"] = ENV['LINE_CHANNEL_ACCESS_TOKEN']

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

    line_req.body = body

    begin
      line_res = line_http.request(line_req)
      results = line_res.body

      results
    rescue => e
      pp e.message
    end
  end
end