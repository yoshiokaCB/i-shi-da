module Client
  class Controller
    INITIALIZED_DATA = {'name' => '', 'scene' => 'name', 'question_no' => '', 'answer' => ''}

    def clear_console
      if OS.windows?
        system('cls')
      elsif OS.mac? || OS.osx? || OS.x?
        system('clear')
      end
    end

    def scene_judge(data, line)
      case data["scene"]
      when "name"
        return {scene: "name", name: line }
      when "start"
        clear_console

        @start_time = Time.now

        return {scene: "start" }
      when "question"
        return {scene: "question", answer: line, question_no: data["question_no"]}
      when "result"
        @end_time = Time.now

        clear_console

        return {scene: "result", answer: line, question_no: 10, time: (@end_time - @start_time).truncate}
      when "retry"
        return {scene: "retry", select: line}
      end
    end

    def display_message(data)
      case data['scene']
      when 'name'
        puts <<-EOS.unindent
          ==================
              タイトル
          ==================
          ～説明～

          [名前を入力してください]
        EOS
      when 'start'
        puts <<-EOS.unindent

          [スペースを送信でスタート]
        EOS
      when 'question', 'result'
        puts <<-EOS.unindent

          [問#{data['question_no']}]
          #{data['question']}
          
          [入力]
        EOS
      when 'retry'
        unless data == {'scene'=>'retry'}
          puts <<-EOS.unindent
            [結果]
            正解率：　#{data['ratio']}
            時　間：　#{data['time']}　秒
            得　点：　#{data['score']}

            [ランキング]
          EOS

          ranking(data['ranking'])
        end

        puts 'リトライしますか？(y/n)'
      when 'end'
        puts <<-EOS.unindent

          終了します
        EOS

        exit
      end
    end

    private

    def ranking(data)
      ranking_datas = []

      data.each_pair do |rank, ranking_data|
        ranking_datas << ranking_data.merge('rank'=>rank)
      end

      Formatador.display_compact_table(ranking_datas, ['rank', 'name', 'score', 'ratio', 'time', 'date'])
    end
  end
end