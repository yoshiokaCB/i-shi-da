module Client
  class Controller
    INITIALIZED_DATA = {'name' => '', 'scene' => 'name', 'question_no' => '', 'answer' => ''}

    def scene_judge(data, line)
      case data["scene"]
      when "name"
        return {scene: "name", name: line }
      when "start"
        system('cls')

        return {scene: "start" }
      when "question"
        return {scene: "question", answer: line, question_no: data["question_no"]}
      when "result"
        system('cls')

        return {scene: "result", answer: line, question_no: 10}
      end
    end
  end
end