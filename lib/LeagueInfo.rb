require_relative "./LeagueInfo/version"
require './lib/LeagueInfo/cli'
require './lib/LeagueInfo/champions'
require './lib/LeagueInfo/getdata'
require './lib/LeagueInfo/champimg'
require './lib/LeagueInfo/users'
require './lib/LeagueInfo/matches'

module LeagueInfo
  class Error < StandardError; end
  # Your code goes here...
end