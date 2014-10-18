require 'bundler'
Bundler.require
require 'socket'
require 'json'
$:.unshift(File.join(__dir__, '../../lib'))
require 'server/data_controller'

describe Server::DataController do
  before do
    @server = Server::DataController.new
  end
  describe 'create_data' do
    context 'scene が name の場合' do
      it '{scene: "start" } が返ってくること' do
        @server.create_data({"scene" => "name", "name" => "hoge"}).should == {scene: "start"}
      end
      it '@nameの値がhogeである' do
        @server.create_data({"scene" => "name", "name" => "hoge"})
        @server.instance_variable_get(:@name).should == "hoge"
      end
    end

    context 'scene が start かつ select が 0 の場合' do
      it '{ranking: ranking } が返ってくること' do
        ranking = @server.instance_variable_get(:@ranking).load
        @server.create_data({"scene" => "start", "select" => "0"}).should == {scene: "start", ranking: ranking}
      end
    end
    context 'scene が start かつ select が 1 の場合' do
      it '{scene: "question"} が返ってくること' do
        recv = @server.create_data({"scene" => "start", "select" => "1"})
        question = @server.instance_variable_get(:@question)
        recv.should == {scene: "question", question_no: 1, question: question[0]}
      end
    end
  end
end

