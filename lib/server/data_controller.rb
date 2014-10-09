module Server
  class DataController

    def create_data(recv)
      case recv["scene"]
        when "name"
          @name = recv["name"].chomp
          return {scene: "start"}
        when "start"
          @score = 0
          @question = create_question
          return {scene: "question", question_no: 1, question: @question[0]}
        when "question"
          #正解判定
          answer_check recv

          #次の問題のナンバー
          q_no = recv["question_no"].to_i
          q_no += 1

          #最終問題のときは"result"を返す
          scene =  q_no == @question.size ? "result" : "question"

          return {scene: scene, question_no: q_no, question: @question[q_no-1]}
        when "result"
          #正解判定
          answer_check recv

          @ranking = read_ranking
          return {name: @name, score: @score, ranking: @ranking }
      end
    end

    private

    def create_question
      return [
          "hoge",
          "foo",
          "baz",
          "bazz",
          "hogehoge",
          "hoge2",
          "foo2",
          "baz2",
          "bazz2",
          "hogehoge2"
      ]
    end

    def answer_check recv_data
      q_no = recv_data["question_no"].to_i
      @score += 1 if recv_data["answer"].chomp == @question[q_no-1]
    end

    def read_ranking
      return {
          "1" => { name: "hoge", score: 190, ratio: 9, time: "1234", date: "2014-10-18" },
          "2" => { name: "foo", score: 160, ratio: 9, time: "1234", date: "2014-10-18" },
          "3" => { name: "bar", score: 150, ratio: 9, time: "1234", date: "2014-10-18" },
          "4" => { name: "bazz", score: 130, ratio: 9, time: "1234", date: "2014-10-18" },
          "5" => { name: "fuze", score: 110, ratio: 9, time: "1234", date: "2014-10-18" }
      }
    end

  end
end
