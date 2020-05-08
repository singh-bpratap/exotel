module Exotel
  class << self
    attr_accessor :exotel_sid, :exotel_api_key, :exotel_token, :default_sender_number
    
    def configure
      yield self
    end
  end  
  
  class AuthenticationError < StandardError;  end

  class UnexpectedError < StandardError;  end

  class ParamsError < StandardError;  end
end


