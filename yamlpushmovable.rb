#! /usr/bin/ruby
require 'xmlrpc/client'
require 'yaml'

class Blog
  
  def initialize(file)
    @conf = YAML::load(IO.read(file))
    @server = XMLRPC::Client.new(@conf[:host], @conf[:path], @conf[:port])
  end

  def post
    begin
      return @server.call('metaWeblog.newPost', @conf[:blog_id], @conf[:username], @conf[:password], @conf[:content], @conf[:pusblish])
    rescue Timeout::Error
      puts "Retrying #{content['title']}, retry #{retries}"
      retries =- 1
    end
  end
end

b = Blog.new ARGV[0]
b.post
