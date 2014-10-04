require 'socket'

socket = TCPSocket.open('localhost', 8888)

STDIN.each_line do |line|
  socket.write(line)
  puts socket.gets
end