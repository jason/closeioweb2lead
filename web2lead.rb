require 'httparty'
require 'json'
require 'sinatra'
require 'bundler/setup'
require 'slim'

class Lead
  include HTTParty
  format :json
  debug_output $stdout
  base_uri 'app.close.io:443'
  basic_auth 'YOURCLOSEIOAPIKEYGOESHERE', ' '
end

get '/' do
    slim :index
end

post '/' do
    lead = {:name => params[:company], :contacts => [{ :name => params[:name].to_s,
           :phones => [{ :phone => params[:phone].to_s, :type => "office" }], :emails =>
           [{ :email => params[:email].to_s, :type => "office" }]}]}.to_json
    response = Lead.post('/api/v1/lead/', {:body => lead, :headers =>
               {'Content-Type' => 'application/json'}})
    if response.success?
        "Your information has been submitted. We will contact you shortly!"
    else
        "Invalid data format. Your information was not submitted. Please try again"
    end
end





