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

        return {scene: "start", select: line }
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
      puts message(data)

      if data['scene'] == 'retry' && data != {"scene" => "retry"}
        ranking(data['ranking'])
      end
    end

    def message(data)
      case data['scene']
      when 'name'
        return <<-EOS.unindent
          =====================================
                       I・SHI・DA
          =====================================
          これはタイピングゲームです。
          Rubyのメソッドを10問出題します。

          順番に問題が出題されるので、
          入力をしてエンターを押してください。

          全問回答後に結果が表示されます。


          ※あらかじめ入力モードを半角にしてください

          [名前を入力してエンターを押してください]
        EOS
      when 'start'
        ranking(data['ranking']) if data['ranking']

        return <<-EOS.unindent

          番号を入力してエンターを押してください
          [0] -> ランキング表示
          [1] -> ゲームスタート
        EOS
      when 'question', 'result'
        return <<-EOS.unindent

          [問#{data['question_no']}]
          #{data['question']}
          
          [入力]
        EOS
      when 'retry'
        unless data == {'scene'=>'retry'}
          return <<-EOS.unindent
            [結果]
            正解率：　#{data['ratio']}
            時　間：　#{data['time']}　秒
            得　点：　#{data['score']}

            [ランキング]
          EOS

          # ranking(data['ranking'])
        end

        return 'リトライしますか？(y/n)'
      when 'end'
        return <<-EOS.unindent

          終了します
        EOS

        exit
      end
    end

    private

    def ranking(data)
      Formatador.display_compact_table(data, ['rank', 'name', 'score', 'ratio', 'time', 'date'])
    end
  end
end