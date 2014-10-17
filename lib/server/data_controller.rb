require './lib/server/ranking'

module Server
  class DataController
    STD_TIME_POINT = 1
    TIME_SCORE_POINT = 1
    RATE_SCORE_POINT = 10

    def initialize
      @ranking = Server::Ranking.new
      @mutex = Mutex.new
    end

    def create_data(recv)
      case recv["scene"]
        when "name"
          @name = recv["name"].chomp
          return {scene: "start"}
        when "start"
          @score = 0
          @ratio = 0
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
          #正解判定 rate
          answer_check recv

          #スコア計算
          score_calculate recv

          #ユーザーの結果
          user_result = {
              "name" => @name,
              "score" => @score,
              "ratio" => @ratio,
              "time" => recv["time"],
              "date" => Time.now.strftime("%Y-%m-%d %H:%M")
          }

          #ランキング編集
          begin
            @mutex.lock
            ranking_list = @ranking.ranking_edit user_result
          ensure
            @mutex.unlock
          end

          return user_result.merge({"scene" => "retry", "ranking" => ranking_list})
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

    def answer_check recv_data
      q_no = recv_data["question_no"].to_i
      @ratio += 1 if recv_data["answer"].chomp == @question[q_no-1]
    end

    def score_calculate recv
      std_time = (@question.join.size) * STD_TIME_POINT
      time_score = (std_time - recv["time"].to_i) * TIME_SCORE_POINT
      ratio_score = @ratio * RATE_SCORE_POINT
      @score = time_score + ratio_score
    end

    def create_ranking_file
      File.open(RANK_FILE_PATH, "w") { |f| f.write(@ranking.to_json) }
    end

  end
end
