require 'sinatra'
require 'haml'
require 'open-uri'
require 'nokogiri'

get '/' do
	@title = "Mobile BGG"
	haml :index
end

get '/about' do
	@title = "Mobile BGG"
	haml :about
end

get '/game/*' do
	@title = "Mobile BGG"
  @gameId = params[:splat].first
  @url = "http://boardgamegeek.com/xmlapi2/thing?type=boardgame&stats=1&id=" + @gameId
  @gameDetailsInXml = Nokogiri::XML(open(@url))

  # Fill Variables with Game Data
  @id = @gameDetailsInXml.xpath("//item/@id").text
  @thumbnail = @gameDetailsInXml.xpath("//thumbnail").text
  @imageId = @thumbnail.match(/\d+/).to_s
  @image = @gameDetailsInXml.xpath("//image").text
  @name = @gameDetailsInXml.xpath("//name/@value").text
  @description = @gameDetailsInXml.xpath("//description").text
  @yearPublished = @gameDetailsInXml.xpath("//yearpublished/@value").text
  @minPlayers = @gameDetailsInXml.xpath("//minplayers/@value").text
  @maxPlayers = @gameDetailsInXml.xpath("//maxplayers/@value").text
  @playingTime = @gameDetailsInXml.xpath("//playingtime/@value").text
  @minAge = @gameDetailsInXml.xpath("//minage/@value").text
  @usersRated = @gameDetailsInXml.xpath("//statistics/ratings/usersrated/@value").text
  @averageRating = @gameDetailsInXml.xpath("//statistics/ratings/average/@value").text
  @boardGameRank = @gameDetailsInXml.xpath("//statistics/ratings/ranks/rank/@value").text
  @owned = @gameDetailsInXml.xpath("//statistics/ratings/owned/@value").text
  @trading = @gameDetailsInXml.xpath("//statistics/ratings/trading/@value").text
  @wanting = @gameDetailsInXml.xpath("//statistics/ratings/wanting/@value").text
  @wishing = @gameDetailsInXml.xpath("//statistics/ratings/wishing/@value").text

  haml :game
end

get '/hot' do
  @url = "http://boardgamegeek.com/xmlapi2/hot?boardgame"
	@gamesInXml = Nokogiri::XML(open(@url))
	@list = @gamesInXml.xpath("/items/item").to_a
	@games = []
  @list.each do |game|
  	@h = Hash.new
  	@h["id"] = game.xpath("@id").to_s
  	@h["name"] = game.xpath("name/@value").to_s
  	@games.push(@h)
  end
	haml :hot
end

get '/gamesearch' do
  @title = "Mobile BGG"
  haml :gamesearch
end

post '/searchresults' do
  @words = params[:search] 
  @formedSearch = @words.gsub(" ", "+")
  @url = "http://boardgamegeek.com/xmlapi2/search?query=" + @formedSearch
  @resultsInXml = Nokogiri::XML(open(@url))
  @gameNames = @resultsInXml.xpath("//item/name/@value").to_a
  @gameIds = @resultsInXml.xpath("//item/@id").to_a
  @results = []
  0.upto(5) do |number|
    @h = Hash.new
    @h["id"] = @gameIds[number].value
    @h["name"] = @gameNames[number].value
    @results.push(@h)
  end
  haml :searchresults
end

post '/user' do
  @title = "Mobile BGG"
  @userId = params[:search]
  @url = "http://boardgamegeek.com/xmlapi2/user?name=" + @userId + "&buddies=1&guilds=1&top=1&hot=1"
  @userDetailXml = Nokogiri::XML(open(@url))

  # fill variables with user data 
  @userId = @userDetailXml.xpath("/user/@id").text
  @userName = @userDetailXml.xpath("/user/@name").text
  @firstName = @userDetailXml.xpath("/user/firstname/@value").text
  @lastName = @userDetailXml.xpath("/user/lastname/@value").text
  @avatarLink = @userDetailXml.xpath("/user/avatarlink/@value").text
  @yearRegistered = @userDetailXml.xpath("/user/yearregistered/@value").text
  @lastLogin = @userDetailXml.xpath("/user/lastlogin/@value").text
  @stateOrProvince = @userDetailXml.xpath("/user/stateorprovince/@value").text
  @country = @userDetailXml.xpath("/user/country/@value").text
  @tradeRating = @userDetailXml.xpath("/user/traderating/@value").text
  

  # Below block of code will yield an array of buddies in hashes for the @buddies var. It will also yield 2 other vars as well
  @buddiesCount = @userDetailXml.xpath("/user/buddies/@total").text
  @buddiesXml = @userDetailXml.xpath("/user/buddies/buddy").to_a
  @buddies = []
  @buddiesXml.each do |buddy|
    h = Hash.new
    h["id"] = buddy.xpath("@id").text
    h["name"] = buddy.xpath("@name").text
    @buddies.push(h)
  end

  # Below block of code will yield an array of Guilds for user with hash for each guild including ID and Name
  @guildsXml = @userDetailXml.xpath("/user/guilds/guild").to_a
  @guilds = []
  @guildsXml.each do |guild|
    h = Hash.new
    h["id"] = guild.xpath("@id").text
    h["name"] = guild.xpath("@name").text
    @guilds.push(h)
  end

  # Below block of code will yield an array of Top 10 list for user with hash for each game including ID and Name
  @topTenXml = @userDetailXml.xpath("/user/top/item").to_a
  @topTen = []
  @topTenXml.each do |topTenGame|
    h = Hash.new
    h["id"] = topTenGame.xpath("@id").text
    h["name"] = topTenGame.xpath("@name").text
    @topTen.push(h)
  end

  # Below block of code will yield an array of Top 10 Hot list for user with hash for each game including ID and Name
  @hotTenXml = @userDetailXml.xpath("/user/hot/item").to_a
  @hotTen = []
  @hotTenXml.each do |hotTenGame|
    h = Hash.new
    h["id"] = hotTenGame.xpath("@id").text
    h["name"] = hotTenGame.xpath("@name").text
    @hotTen.push(h)
  end
  
  haml :user
end

get '/usersearch' do
  haml :usersearch
end





helpers do

  def userHotList()
    @hotString = '<ul data-role="listview" data-theme="c">'
    if @hotTen.length != 0
      0.upto(@hotTen.length-1) do |item|
      @specialHotUrl = @hotTen[item]["id"]
      @hotString.concat('<li><a href="/game/' + @specialHotUrl +'">' + @hotTen[item]["name"] + '</a></li>')
      end
      @hotString = @hotString + '</ul>'
    else
      @hotString = "This user has not added games."
    end
    return @hotString
  end


  def userTopList()
    @topString = '<ul data-role="listview" data-theme="c">'
    if @topTen.length != 0
      0.upto(@topTen.length-1) do |item|
      @specialTopUrl = @topTen[item]["id"]
      @topString.concat('<li><a href="/game/' + @specialTopUrl +'">' + @topTen[item]["name"] + '</a></li>')
      end
      @topString = @topString + '</ul>'
    else
      @topString = "This user has not added games."
    end
    return @topString
  end

  def userBuddyList()
    @buddyString = '<ul data-role="listview" data-theme="c">'
    if @buddies.length != 0
      0.upto(@buddies.length-1) do |item|
      @buddyString.concat('<li><a href="#">' + @buddies[item]["name"] + '</a></li>')
      end
      @buddyString = @buddyString + '</ul>'
    else
      @buddyString = "This user does not have any buddies."
    end
    return @buddyString
  end

  def userGuildsList()
    @guildsString = '<ul data-role="listview" data-theme="c">'
    if @guilds.length != 0
      0.upto(@guilds.length-1) do |item|
      @guildsString.concat('<li>' + @guilds[item]["name"] + '</li>')
      end
      @guildsString = @guildsString + '</ul>'
    else
      @guildsString = "This user does not belong to any guilds."
    end
    return @guildsString
  end

end




__END__