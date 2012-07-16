

#
# = SuperStruct
#
# SuperStruct is an enhanced version of the Ruby Standard library <tt>Struct</tt>.
#
# Compared with the original version, it provides the following additional features:
# * ability to initialize an instance from Hash
# * ability to pass a block on creation
#
# You can read more at http://www.simonecarletti.com/blog/2010/01/ruby-superstruct/
#
# Category:: Standard
# Package:: SuperStruct
# Author:: Simone Carletti <weppos@weppos.net>
# License:: MIT License
# Source:: http://gist.github.com/271214
#

require 'ostruct'

class SuperStruct < Struct

  # Overwrites the standard Struct initializer
  # to add the ability to create an instance from a Hash of parameters
  # and pass a block to yield on self.
  #
  # SuperEroe = SuperStruct.new(:name, :nickname)
  #
  # attributes = { :name => "Pippo", :nickname => "SuperPippo" }
  # SuperEroe.new(attributes)
  # # => #<struct SuperEroe name="Pippo", nickname="SuperPippo">
  #
  # SuperEroe.new do |s|
  # s.name = "Pippo"
  # s.nickname = "SuperPippo"
  # end
  # # => #<struct SuperEroe name="Pippo", nickname="SuperPippo">
  #
  def initialize(*args, &block)
    if args.first.is_a? Hash
      initialize_with_hash(args.first)
    else
      super
    end
    yield(self) if block_given?
  end

  private

    def initialize_with_hash(attributes = {})
      attributes.each do |key, value|
        self[key] = value
      end
    end
  
end


if $0 == __FILE__

  require 'test/unit'

  class SuperStructTest < Test::Unit::TestCase

    SuperEroe = Class.new(SuperStruct.new(:name, :supername))

    def setup
      @klass = SuperEroe
    end

    def test_initialize_with_block
      @klass.new do |instance|
        assert_instance_of SuperEroe, instance
        assert_kind_of SuperStruct, instance
      end
    end

    def test_initialize_with_hash
      instance = @klass.new(:name => "Pippo", :supername => "SuperPippo")
      assert_equal "Pippo", instance.name
      assert_equal "SuperPippo", instance.supername
    end

  end

end



module BoardGameGeek
  class Game < SuperStruct.new(:game_id, :thumbnail, :image_id, :image, :name, :description, :year_published, :min_players, :max_players, :playing_time, :min_age, :users_rated, :average_rating, :boardgame_rank, :owned, :trading, :wanting, :wishing) # need to add the rest of your instance variables here
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