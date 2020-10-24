require 'httparty'

class Trail < ApplicationRecord
  belongs_to :user
  def weather
    two_four_ago=Time.now.to_i
    res=HTTParty.get("https://api.openweathermap.org/data/2.5/onecall?lat=#{lat}&lon=#{lon}&exclude=minutely,daily&units=imperial&appid=#{ENV["WEATHER_KEY"]}")
    JSON.parse(res.body, :quirks_mode => true)
  end
  def weather_history
    two_four_ago=Time.now.to_i
    res=HTTParty.get("https://api.openweathermap.org/data/2.5/onecall/timemachine?lat=#{lat}&lon=#{lon}&dt=#{two_four_ago}&exclude=minutely,daily&units=imperial&appid=#{ENV["WEATHER_KEY"]}")
    JSON.parse(res.body, :quirks_mode => true)
  end
end
