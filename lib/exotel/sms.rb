# -*- encoding: utf-8 -*-
require 'httparty'
module Exotel
  class Sms
    include HTTParty
    base_uri "https://twilix.exotel.in/v1/Accounts"
    
    def initialize; end
    
    def self.send(params={})
      self.new.send(params)
    end
    
    def self.details(params={})
      self.new.details(params)
    end
    
    def send(params={})
      params = required_params(params)
      if valid?(params)
        body = transfrom_params(params)
        response = self.class.post("/#{Exotel.exotel_sid}/Sms/send",  {:body => body, :basic_auth => auth })
        handle_response(response)
      end  
    end
   
    def details(sid)
      response = self.class.get("/#{Exotel.exotel_sid}/Sms/Messages/#{sid}",  :basic_auth => auth)
      handle_response(response)
    end
    
    protected
    
    def valid?(params)
      if [:from, :to, :body].all?{|key| params.keys.include?(key)}
        true  
      else
        raise Exotel::ParamsError, "Missing one or many required parameters." 
      end 
    end

    def required_params(params)
      if params.keys.include?(:from)
        params
      else
        params.merge(from: Exotel.default_sender_number)
      end
    end
    
    def transfrom_params(params)
      #Keys are converted to camelcase
      params.inject({}){ |h, (key, value)| h[key.to_s.capitalize.to_sym] = value; h }
    end
    
    def auth
      {:username => Exotel.exotel_api_key, :password => Exotel.exotel_token}
    end
    
    def handle_response(response)
      case response.code.to_i
 	    when 200...300 then Exotel::Response.new(response)
      when 401 then raise Exotel::AuthenticationError, "#{response.body} Verify your sid and token." 
 	    else
 	      raise Exotel::UnexpectedError, response.body
 	    end
    end
  end
end  



