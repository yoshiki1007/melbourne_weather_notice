require 'json'
require 'uri'
require 'net/https'

def lambda_handler(event:, context:)
  # 天気API
  lat = "-37.8165137"
  lon = "144.9497845"
  units = "metric"
  lang = "ja"
  exclude = "minutely"
  api_key = ENV['WEATHER_API_KEY']

  weather_uri = URI("https://api.openweathermap.org/data/3.0/onecall?lat=#{lat}&lon=#{lon}&units=#{units}&lang=#{lang}&exclude=#{exclude}&appid=#{api_key}")

  weather_res = Net::HTTP.get_response(weather_uri)
  weather_body = JSON.parse(weather_res.body)

  target_name = "Melbourne CBD $\n\n"

  weather_date = Time.at(weather_body["current"]["dt"]).strftime("%m/%d %A") + " 天気\n"
  weather = weather_body["daily"][0]["weather"][0]["main"] + ": " + weather_body["daily"][0]["weather"][0]["description"] + "\n"
  sunrise = "日の出: " + Time.at(weather_body["current"]["sunrise"], in: "+11:00").strftime("%H:%M") + "\n"
  sunset = "日没: " + Time.at(weather_body["current"]["sunset"], in: "+11:00").strftime("%H:%M") + "\n\n"
  temp_max = "最高気温: " + weather_body["daily"][0]["temp"]["max"].floor.to_s + "℃\n"
  temp_min = "最低気温: " + weather_body["daily"][0]["temp"]["min"].floor.to_s + "℃\n"
  temp_morn = "朝の気温: " + weather_body["daily"][0]["temp"]["morn"].floor.to_s + "℃\n"
  temp_day = "日中の気温: " + weather_body["daily"][0]["temp"]["day"].floor.to_s + "℃\n"
  temp_eve = "夕方の気温: " + weather_body["daily"][0]["temp"]["eve"].floor.to_s + "℃\n"
  temp_night = "夜の気温: " + weather_body["daily"][0]["temp"]["night"].floor.to_s + "℃"

  weather_text = target_name + weather_date + weather + sunrise + sunset + temp_max + temp_min + temp_morn + temp_day + temp_eve + temp_night

  # ここからLINE message API
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
