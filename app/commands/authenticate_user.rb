require 'jwt'



class AuthenticateUser
    prepend SimpleCommand
  
    def initialize(username, password)
      @username = username
      @password = password
    end
    
    def encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end

    def call
      encode(user_id: user.id) if user
    end
  
    private
  
    attr_accessor :username, :password
  
    def user
      user = User.find_by_username(username)
      return user if user && user.authenticate(password)
  
      errors.add :user_authentication, 'invalid credentials'
      nil
    end
  end