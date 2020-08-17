require_relative "./LeagueInfo/version"
require './lib/LeagueInfo/cli'
require './lib/LeagueInfo/champions'
require './lib/LeagueInfo/getdata'
require './lib/LeagueInfo/users'
require './lib/LeagueInfo/matches'
require './lib/LeagueInfo/friends'

module LeagueInfo
  class Error < StandardError; end
  # Your code goes here...
end