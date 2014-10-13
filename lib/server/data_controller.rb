module Server
  class DataController
    STD_TIME_POINT = 1
    TIME_SCORE_POINT = 1
    RATE_SCORE_POINT = 10

    def create_data(recv)
      case recv["scene"]
        when "name"
          @name = recv["name"].chomp
          return {scene: "start"}
        when "start"
          @score = 0
          @rate = 0
          @question = create_question
          @std_time = standard_time_calculate
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
          #正解判定 rate
          answer_check recv

          #スコア計算
          score_calculate recv

          @ranking = read_ranking
          return {scene: "retry", name: @name, score: @score, rate: @rate, ranking: @ranking }

        when "retry"
          case recv["select"].chomp
            when "y"
              return {scene: "start"}
            when "n"
              return {scene: "end"}
            else
              return {scene: "retry"}
          end
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

    def standard_time_calculate
      return (@question.join.size) * STD_TIME_POINT
    end

    def answer_check recv_data
      q_no = recv_data["question_no"].to_i
      @rate += 1 if recv_data["answer"].chomp == @question[q_no-1]
    end

    def score_calculate recv
      time_score = (@std_time - recv[:time].to_i) * TIME_SCORE_POINT
      rate_score = @rate * RATE_SCORE_POINT
      @score = time_score + rate_score
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
