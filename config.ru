# encoding: utf-8

require 'net/http'
require 'net/https'
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
    uri = URI.parse code_url
    
    http = Net::HTTP.new(uri.host, uri.port)
    if uri.scheme == 'https'
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    request = Net::HTTP::Get.new(uri.request_uri)

    response = http.request(request)
  
    puts response.inspect
  
    if response.is_a? Net::HTTPOK
      status  = 200
      headers = { 'Content-Type'  => 'text/html; charset=utf-8', 'Cache-Control' => 'public, max-age=8640000'}
      content = Rocco.new code_url,[], :language => File.extname(code_url)[1..-1] do
        response.body
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


