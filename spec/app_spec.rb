require 'spec_helper'

describe BoardGameGeek::App do

  include Rack::Test::Methods

  def app
    BoardGameGeek::App
  end

  describe '/game/:id' do
    it 'has the correct game id' do
      get '/game/57830'
      last_response.body.must_match /57830/
    end
  end

end
