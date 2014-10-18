module Server
  class Ranking
    RANK_FILE_PATH = './lib/server/ranking_list.json'
    RANK_COUNT = 5

    def initialize
      @mutex = Mutex.new
      unless File.exist?(RANK_FILE_PATH)
        ranking = {}
        sample = { "name" => "---", "score" => 0, "ratio" => "0/0", "time" => "0", "date" => "0000-00-00" }
        RANK_COUNT.times { |i| ranking[(i+1).to_s] = sample }
        save(ranking)
      end
    end

    def edit(user_result)
      begin
        @mutex.lock
        rank_ary = load.push(user_result)
        rank_ary.sort! do |a, b|
          b["score"] != a["score"] ? b["score"] <=> a["score"] : b["ratio"] <=> a["ratio"]
        end
        ranking = []
        RANK_COUNT.times do |i|
          rank_ary[i][:rank] = (i+1)
          ranking.push(rank_ary[i])
        end
        save(ranking)
      ensure
        @mutex.unlock
      end

      return ranking
    end

    def load
      return File.open(RANK_FILE_PATH) { |json| JSON.load(json) }
    end

    def save(ranking)
      File.open(RANK_FILE_PATH, "w") { |f| f.write(ranking.to_json) }
    end

  end
end