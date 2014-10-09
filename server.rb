require 'bundler'
Bundler.require
require 'socket'
require 'json'
require './lib/server/data_controller'
include Server

server = TCPServer.open(8888)
loop do
  Thread.new(server.accept) do |client|
    data = DataController.new
    while s = client.gets
      client.puts data.create_data(JSON.parse(s)).to_json
    end
  end
end