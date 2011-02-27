# encoding: utf-8

require 'net/http'
require 'uri'
require File.dirname(__FILE__) +'/vendor/rocco/lib/rocco.rb'

def content(env)
  file_url = env['REQUEST_PATH'][1..-1];
  r = Rocco.new file_url,[], :language => File.extname(file_url)[1..-1] do
    url = URI.parse file_url
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.get(url.path)
    }
    res.body
  end.to_html
end

run lambda { |env| [ 200, { 'Content-Type' => 'text/html; charset=utf-8', 'Cache-Control' => 'public, max-age=300'}, content(env)] }