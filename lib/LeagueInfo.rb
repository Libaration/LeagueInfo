require_relative "./LeagueInfo/version"
require './lib/LeagueInfo/cli'
require './lib/LeagueInfo/champions'
require './lib/LeagueInfo/getdata'
require './lib/LeagueInfo/champimg'
require './lib/LeagueInfo/users'

module LeagueInfo
  class Error < StandardError; end
  # Your code goes here...
end
