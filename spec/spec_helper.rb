require 'rspec'
require 'pp'

$LOAD_PATH.unshift File.expand_path('../../app', __FILE__)
require 'tumblr_poller'
require 'blog_poller'
require 'application'
require 'tumblr_interface'
