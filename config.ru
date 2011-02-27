# encoding: utf-8

require 'net/http'
require 'uri'
require 'rocco'

def content
  r = Rocco.new 'wicked.js',[], :language => 'js', :comment_chars => '//' do
    url = URI.parse('http://yolk.github.com/mite.gyver/wicked.js')
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.get('/vendor/wicked.js/wicked.js')
    }
    res.body
    
    "// super funky fresh
    x = function() {};"
  end.to_html
end

run lambda { |env| [ 200, { 'Content-Type' => 'text/html; charset=utf-8'}, content] }