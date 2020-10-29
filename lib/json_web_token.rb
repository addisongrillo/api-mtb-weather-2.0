class JsonWebToken
    class << self
      def encode(payload, exp = 24.hours.from_now)
          p "encode"
        payload[:exp] = exp.to_i
        JWT.encode(payload, Rails.application.secrets.secret_key_base)
      end
   
      def decode(token)
          p "decode"
        body = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
        HashWithIndifferentAccess.new body
      rescue
        nil
      end
    end
   end