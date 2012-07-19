require 'spec_helper'
require 'capybara'
require 'capybara/dsl'

describe BoardGameGeek::App do

  include Capybara

  def setup
    Capybara.app = BoardGameGeek::App
  end

  describe '/game/:id' do
    it 'has the correct game id' do
      visit '/game/57830'
      page.has_content?('57830').must_equal true
    end
  end

end
