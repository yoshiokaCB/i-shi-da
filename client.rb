require 'socket'
require 'json'

def seen_judge(data, line)
  case data['seen'].to_i
  when 1
    return {name: line, seen: 2}
  when 2
    return {seen: 3, question_no: 1}
  end
end

@socket = TCPSocket.open('localhost', 8888)
send_data = {
      name: '',
      seen: 0,
      question_no: "",
      answer: ""
  }

STDIN.each_line do |line|

  @socket.puts send_data.to_json

  recv_data = JSON.parse(@socket.gets)

  send_data = seen_judge(recv_data, line)
end
