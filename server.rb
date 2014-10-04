require 'socket'
require 'json'


list = [
    "hoge",
    "foo",
    "baz",
    "bazz",
    "hogehoge"
]

server = TCPServer.open(8888)
loop do
  Thread.new(server.accept) do |client|

    while s = client.gets
      res = JSON.parse(s)

      case res["seen"].to_i
        when 0
          data = {
            name: '',
            seen: 1,
            question_no: '',
            answer: ''
          }

          client.puts data.to_json
        when 1
          #名前入力
          @name = res["name"]

          data = {
            name: @name,
            seen: 2,
            question_no: "",
            answer: ""
          }
          client.puts data.to_json
        when 2
          #スタート画面
          @score = 0
          res['answer'] = 'answer'
          client.puts res.to_json
        when 3
          #出題
          @question = list.shuffle
          @question[res[:question_no].to_i]
        when 4
          #判定
          if res[:kaitou] == @question[res[:question_no].to_i]
            #正解の判定
          else
            #不正解の判定
          end

          #クライアントへ問題を送信
        when 5
          #結果
      end
    end
  end
end