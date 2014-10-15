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
      if data['scene'] == 'name'
        puts "=================="
        puts "     タイトル     "
        puts "=================="
        puts "～説明～"
        puts
        puts "[名前を入力してください]"
      elsif data['scene'] == 'start'
        puts
        puts "[スペースを送信でスタート]"
      elsif data['scene'] == 'question' || data['scene'] == 'result'
        puts
        puts "[問#{data['question_no']}]"
        puts data['question']
        puts
        puts "[入力]"
      elsif data['scene'] == 'retry'
        puts "[結果]"
        puts
        puts "リトライしますか？(y/n)"
      elsif data['scene'] == 'end'
        puts
        puts '終了します'
        exit
      end
    end
  end
end