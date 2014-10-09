require 'bundler'
Bundler.require
require 'socket'
require 'json'
require './lib/client/controller'


@socket = TCPSocket.open('localhost', 8888)
client = Client::Controller.new

recv_data = client.initialized_data

STDIN.each_line do |line|

  send_data = client.scene_judge(recv_data, line)
  p "send_data : " + send_data.to_s

  @socket.puts send_data.to_json

  recv_data = JSON.parse(@socket.gets)
  p "recv_data : " + recv_data.to_s

end
