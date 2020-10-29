require 'jwt'

class AuthenticationController < ApplicationController
    skip_before_action :authenticate_request
   
    def decode(token)
      p "decode"
      body = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
      p"body"
      p body
      HashWithIndifferentAccess.new body
    rescue
      nil
    end
    
    def authenticate
      command = AuthenticateUser.call(params[:username], params[:password])
   
      if command.success?
        p "command.result"
        p command.result
        render json: { auth_token: command.result, user: User.find(decode(command.result)[:user_id]) }
      else
        render json: { error: command.errors}, status: :unauthorized
      end
    end
   end