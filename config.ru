# encoding: utf-8

require 'net/http'
require 'uri'
require 'rocco'

def content
  r = Rocco.new('wicked.js') do
    url = URI.parse('http://yolk.github.com/mite.gyver/wicked.js')
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.get('/vendor/wicked.js/wicked.js')
    }
    
    puts 'say, what?'
    res.body.force_encoding('UTF-8')
  end

  r.to_html || 'nothing'
end

run lambda { |env| [ 200, { 'Content-Type' => 'text/html; charset=utf-8'}, content] }