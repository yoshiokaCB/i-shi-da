require 'bundler'
Bundler.require
require 'socket'
require 'json'
require './lib/client/controller'


socket = TCPSocket.open('localhost', 8888)
controller = Client::Controller.new

recv_data = Client::Controller::INITIALIZED_DATA

controller.clear_console

controller.display_message(recv_data)

STDIN.each_line do |line|

  send_data = controller.scene_judge(recv_data, line)
  # p "send_data : " + send_data.to_s

  socket.puts send_data.to_json

  recv_data = JSON.parse(socket.gets)
  #p "recv_data : " + recv_data.to_s

  controller.display_message(recv_data)
end
