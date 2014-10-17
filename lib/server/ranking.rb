module Server
  class Ranking
    RANK_FILE_PATH = './lib/server/ranking_list.json'
    RANK_COUNT = 5

    def initialize
      unless File.exist?(RANK_FILE_PATH)
        ranking = {}
        sample = { "name" => "---", "score" => 0, "ratio" => 0, "time" => "0", "date" => "0000-00-00" }
        RANK_COUNT.times { |i| ranking[(i+1).to_s] = sample }
        ranking_save ranking
      end
    end

    def ranking_edit user_result
      rank_ary = ranking_load.values
      rank_ary.push user_result
      rank_ary.sort! do |a, b|
        b["score"] != a["score"] ? b["score"] <=> a["score"] : b["ratio"] <=> a["ratio"]
      end
      ranking = {}
      RANK_COUNT.times { |i| ranking[(i+1).to_s] = rank_ary[i] }
      ranking_save ranking

      return ranking
    end

    def ranking_load
      return File.open(RANK_FILE_PATH) { |json| JSON.load(json) }
    end

    def ranking_save ranking
      File.open(RANK_FILE_PATH, "w") { |f| f.write(ranking.to_json) }
    end

  end
end