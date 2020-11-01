module JsonWebToken
  def self.encode(payload, exp = 30.days.from_now)
    payload[:exp] = exp.to_i
    p "key"
    p Rails.application.credentials.secret_key_base
    JWT.encode(payload, ApiMtbWeather20::Application.credentials.secret_key_base)
  end

  def self.decode(token)
    body = JWT.decode(token, ApiMtbWeather20::Application.credentials.secret_key_base)[0]
    HashWithIndifferentAccess.new body
  rescue
    nil
  end

end