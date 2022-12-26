require './weather'
require './official_line'

def lambda_handler(event:, context:)
  # 天気
  lat = "-37.8165137"
  lon = "144.9497845"
  units = "metric"
  lang = "ja"
  exclude = "minutely"

  weather = Weather.new(lat: lat, lon: lon, units: units, lang: lang, exclude: exclude)
  weather_body = weather.get_weather
  weather_text = weather.get_text(weather_body)

  #LINE
  OfficialLine.send(weather_text)
end
