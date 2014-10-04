require 'socket'

server = TCPServer.open(8888)
loop do
  Thread.new(server.accept) do |client|
    while client.gets
      s = client.gets
      client.puts s
    end
  end
end