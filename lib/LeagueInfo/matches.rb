require 'pry'
class LeagueInfo::Matches
  @@all = []
  attr_accessor :teams, :owner

  def initialize(matches,owner)
    @teams = []
    @teams << matches
    @owner = owner
    self.class.all << self
  end

  def self.all
    @@all
  end

  def self.get_matches(name)
    matchIds = []
    matchData = []
    data = LeagueInfo::Getdata.new
    #LeagueInfo::Users.current.matches << data.get("https://na1.api.riotgames.com/lol/match/v4/matchlists/by-account/#{name.accountId}?api_key=#{LeagueInfo::Getdata.APIKEY}")
    matches = data.get("https://na1.api.riotgames.com/lol/match/v4/matchlists/by-account/#{name.accountId}?endIndex=2&api_key=#{LeagueInfo::Getdata.APIKEY}")[:matches]
    matches.each do |k|
      k.each { |key, value| matchIds << {key => value} if key == :gameId }
    end
    matchIds.each_with_index do |_ , i| # this loop iterates through each gameId and sets it to the currentGameId
      currentGameId = matchIds[i].values.join()
      matchHistory = data.get("https://na1.api.riotgames.com/lol/match/v4/matches/#{currentGameId}?api_key=#{LeagueInfo::Getdata.APIKEY}")[:teams] # pulls match data depending on current gameId
      matchData << matchHistory # push match data from current iteration into an array
    end
    createMatches(matchData)
  end

  def self.all_by_name(owner)
    all.select { |obj| obj.owner == owner}
  end

  def self.createMatches(matches)
    owner = LeagueInfo::Users.current
    matches.each_with_index do |game, _| # This gives all games in an array each game containing 2 hashes one for the winning team one for losing team so iterate through each game with index
      # index is not used here but left as a reminder you use index to go a level deeper into the hash
      self.new(game, owner) unless self.all.any?{ |obj| obj.teams.include? (game) }
    end
  end
end
