require 'socket'
require 'json'

socket = TCPSocket.open('localhost', 8888)

STDIN.each_line do |line|

  data = {
      name: line,
      seen: "1",
      kaisuu: "1",
      kaitou: "gehoge"
  }

  data = data.to_json
  socket.puts(data)
  puts socket.gets

end