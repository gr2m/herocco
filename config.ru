# encoding: utf-8

require 'net/http'
require 'uri'

require 'rubygems'
require "bundler/setup"
require 'rocco'

def herocco!(env)
  code_url = env['REQUEST_PATH'][1..-1];
  
  if code_url.empty?
    status  = 200
    headers = headers = { 'Content-Type'  => 'text/html; charset=utf-8', 'Cache-Control' => 'public, max-age=8640000'}
    content = File.open(Dir.pwd + '/index.html', File::RDONLY)
  else  
    url = URI.parse code_url
    result = Net::HTTP.start(url.host, url.port) {|http| http.get(url.path) }
  
    if result.is_a? Net::HTTPOK
      status  = 200
      headers = { 'Content-Type'  => 'text/html; charset=utf-8', 'Cache-Control' => 'public, max-age=8640000'}
      content = Rocco.new code_url,[], :language => File.extname(code_url)[1..-1] do
        result.body
      end.to_html
    else
      status  = 404
      headers = { 'Content-Type'  => 'text/html; charset=utf-8' }
      content  = "<h1>I'm sorry!</h1>"
      content += "<p>I tried hard but couldn't find any code at <a href='#{code_url}'>#{code_url}</a></p>"
    end
  end
  
  [ status, headers, content]
end

run lambda { |env| herocco!(env) }


