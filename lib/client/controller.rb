module Client
  class Controller
    def initialized_data
      return {'name' => '', 'scene' => 'name', 'question_no' => '', 'answer' => ''}
    end

    def scene_judge(data, line)
      case data["scene"]
      when "name"
        return {scene: "name", name: line }
      when "start"
        return {scene: "start" }
      when "question"
        return {scene: "question", answer: line, question_no: data["question_no"]}
      when "result"
        return {scene: "result", answer: line, question_no: 10}
      end
    end
  end
end