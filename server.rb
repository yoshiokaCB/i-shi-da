require 'bundler'
Bundler.require

require 'socket'
require 'json'
require './lib/server/data_controller'


server = TCPServer.open(8888)
loop do
  Thread.new(server.accept) do |client|
    data = DataController.new
    while s = client.gets
      data.recv_data = JSON.parse(s)
      data.create_data
      client.puts data.send_data.to_json
    end
  end
end