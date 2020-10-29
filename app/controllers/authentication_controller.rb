require 'jwt'

class AuthenticationController < ApplicationController
    skip_before_action :authenticate_request
   
    def decode(token)
      body = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
      HashWithIndifferentAccess.new body
    rescue
      nil
    end
    
    def authenticate
      command = AuthenticateUser.call(params[:username], params[:password])
   
      if command.success?
        p "this is the log:"
        p command.result
        render json: { auth_token: command.result, user: User.find(decode(command.result)[:user_id]) }
      else
        render json: { error: command.errors}, status: :unauthorized
      end
    end
   end