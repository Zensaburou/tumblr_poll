require_relative 'tumblr_client'
require 'json'

t=TumblrClient.new.client

puts JSON.pretty_generate(t.posts('glitterandcamo.tumblr.com', offset: 2))
