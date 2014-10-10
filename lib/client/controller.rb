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
      end
    end
  end
end