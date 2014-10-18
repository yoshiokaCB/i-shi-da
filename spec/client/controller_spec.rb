require 'bundler'
Bundler.require
$:.unshift(File.join(__dir__, '../../lib'))
require 'client/controller'

describe Client::Controller do
  before do
    @controller = Client::Controller.new
  end

  describe 'scene_judge' do
    context 'scene が name の場合' do
      it '{scene: "name", name: 入力した値 } が返ってくること' do
        @controller.scene_judge({"scene" => "name"}, 'name').should == {scene: "name", name: 'name' }
      end
    end

    context 'scene が start の場合' do
      it '{scene: "start", select: 入力した値 } が返ってくること' do
        @controller.scene_judge({"scene" => "start"}, 1).should == {scene: "start", select: 1}
      end
    end

    context 'scene が question の場合' do
      it '{scene: "question", answer: 入力した値, question_no: data["question_no"]} が返ってくること' do
        @controller.scene_judge({"scene" => "question", "question_no" => 1}, 'answer').should == {scene: "question", answer: 'answer', question_no: 1}
      end
    end

    context 'scene が result の場合' do
      before do
        @controller.scene_judge({"scene" => "start"}, ' ')
        @result = @controller.scene_judge({"scene" => "result", "question_no" => 10}, 'answer')
      end

      it 'scene が result であること' do
        @result[:scene].should == 'result'
      end

      it 'answer が 入力した値であること' do
        @result[:answer].should == 'answer'
      end

      it 'question_no が 10 であること' do
        @result[:question_no].should == 10
      end

      it 'time が Fixnum クラスであること' do
        @result[:time].class.should == Fixnum
      end
    end

    context 'scene が retry の場合' do
      it '{scene: "retry", select: 入力した値} が返ってくること' do
        @controller.scene_judge({"scene" => "retry"}, 'y').should == {scene: "retry", select: 'y'}
      end
    end
  end

  describe 'message' do
    context 'scene が name の場合' do
      it '文字列が返ってくること' do
        @controller.message({"scene" => "name"}).class.should == String
      end
    end

    context 'scene が start の場合' do
      it '文字列が返ってくること' do
        @controller.message({"scene" => "start"}).class.should == String
      end
    end

    context 'scene が question の場合' do
      it '文字列が返ってくること' do
        @controller.message({"scene" => "question"}).class.should == String
      end
    end

    context 'scene が result の場合' do
      it '文字列が返ってくること' do
        @controller.message({"scene" => "result"}).class.should == String
      end
    end

    context 'scene が retry の場合' do
      it '文字列が返ってくること' do
        @controller.message({"scene" => "retry"}).class.should == String
      end
    end

    context 'scene が end の場合' do
      it '文字列が返ってくること' do
        @controller.message({"scene" => "end"}).class.should == String
      end
    end
  end
end