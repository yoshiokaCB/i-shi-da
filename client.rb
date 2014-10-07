require 'bundler'
Bundler.require
require 'socket'
require 'json'

def scene_judge(data, line)
  case data["scene"]
    when "name"
      return {scene: "name", name: line }
    when "start"
      return {scene: "start" }
    when "question"
      return {scene: "question", answer: line, question_no: data["question_no"]}
    when "result"
      return {scene: "result", answer: line, question_no: 10}
  end
end

@socket = TCPSocket.open('localhost', 8888)
recv_data = {
    "name" => '',
    "scene" => "name",
    "question_no" => "",
    "answer" => ""
}

STDIN.each_line do |line|

  send_data = scene_judge(recv_data, line)
  p "send_data : " + send_data.to_s

  @socket.puts send_data.to_json

  recv_data = JSON.parse(@socket.gets)
  p "recv_data : " + recv_data.to_s

end
