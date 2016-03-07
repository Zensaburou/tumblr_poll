require 'tumblr_client'
require 'dotenv'
Dotenv.load

class TumblrClient
  attr_reader :client

  def initialize
    Tumblr.configure do |config|
      config.consumer_key = ENV['CONSUMER_KEY']
      config.consumer_secret = ENV['CONSUMER_SECRET']
      config.oauth_token = ENV['OAUTH_TOKEN']
      config.oauth_token_secret = ENV['OAUTH_TOKEN_SECRET']
    end
    @client = Tumblr::Client.new
  end

  def client
    @client
  end
end
