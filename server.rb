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
      puts res["message"]
      puts res["seen"]
      client.puts s
      case res["seen"].to_i
        when 1
          #名前入力
          @name = res["name"]
        when 2
          #スタート画面
          @score = 0
        when 3
          #出題
          @question = list.shuffle
          @quesiton[res[:kaisuu].to_i]
        when 4
          #判定
          if res[:kaitou] == @quesiton[res[:kaisuu].to_i]
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