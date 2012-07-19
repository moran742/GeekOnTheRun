module BoardGameGeek
  class Game < SuperStruct.new(:game_id, :thumbnail, :image_id, :image, :name, :description, :year_published, :min_players, :max_players, :playing_time, :min_age, :users_rated, :average_rating, :boardgame_rank, :owned, :trading, :wanting, :wishing)
    def self.find(game_id)
      url = "http://boardgamegeek.com/xmlapi2/thing?type=boardgame&stats=1&id=" + game_id
      doc = Nokogiri::XML(open(url))

      attributes = {
        :game_id => doc.xpath("//item/@id").text,
        :thumbnail => doc.xpath("//thumbnail").text,
        :image_id => doc.xpath("//thumbnail").text.match(/\d+/).to_s,
        :image => doc.xpath("//image").text,
        :name => doc.xpath("//name/@value").text,
        :description => doc.xpath("//description").text,
        :year_published => doc.xpath("//yearpublished/@value").text,
        :min_players => doc.xpath("//minplayers/@value").text,
        :max_players => doc.xpath("//maxplayers/@value").text,
        :playing_time => doc.xpath("//playingtime/@value").text,
        :min_age => doc.xpath("//minage/@value").text,
        :users_rated => doc.xpath("//statistics/ratings/usersrated/@value").text,
        :average_rating => doc.xpath("//statistics/ratings/average/@value").text,
        :owned => doc.xpath("//statistics/ratings/owned/@value").text,
        :trading => doc.xpath("//statistics/ratings/trading/@value").text,
        :wanting => doc.xpath("//statistics/ratings/wanting/@value").text,
        :wishing => doc.xpath("//statistics/ratings/wishing/@value").text
      }

      Game.new(attributes)
    end
  end
end
