# Board Game Geek

This is a mobile implementation via the XML API offered up at [BoardGameGeek.com](http://boardgamegeek.com).  Goal is to make browsing basic data of users and games easier from a variety of mobile devices.

## Sinatra App

You can start the sinatra application by running `rackup` from the project directory.

## TODO

* Views seem to have too much in regards to hard-coded values and routes file seems to have too much code.
* Not sure what the best method for organizing the code is.
* I found it weird that I couldn't use haml in the helpers, but the only thing I could get to work was html.  Am I properly using helpers?
* App is sitting on [Heroku](http://boardgamegeek.herokuapp.com).
