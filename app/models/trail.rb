require 'httparty'

class Trail < ApplicationRecord
  belongs_to :user
  def weather
    two_four_ago=Time.now.to_i
    res=HTTParty.get("https://api.openweathermap.org/data/2.5/onecall?lat=#{lat}&lon=#{lon}&exclude=minutely,daily&units=imperial&appid=459d2e1521f062a733afc2811577387a")
    JSON.parse(res.body, :quirks_mode => true)
  end
  def weather_history
    two_four_ago=Time.now.to_i
    res=HTTParty.get("https://api.openweathermap.org/data/2.5/onecall/timemachine?lat=#{lat}&lon=#{lon}&dt=#{two_four_ago}&exclude=minutely,daily&units=imperial&appid=459d2e1521f062a733afc2811577387a")
    JSON.parse(res.body, :quirks_mode => true)
  end
end
