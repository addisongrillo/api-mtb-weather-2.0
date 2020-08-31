require 'httparty'

class Trail < ApplicationRecord
  belongs_to :user
  def weather
    res=HTTParty.get("https://api.openweathermap.org/data/2.5/weather?lat=#{lat}&lon=#{lon}&APPID=459d2e1521f062a733afc2811577387a")
    JSON.parse(res.body, :quirks_mode => true)
  end
end
