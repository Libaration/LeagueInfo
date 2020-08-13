require 'pry'
require 'tty-progressbar'
class LeagueInfo::Matches
  @@all = []
  attr_accessor :teams, :owner, :champsPlayed

  def initialize(matches,owner, champsPlayed)
    @teams = []
    @teams << matches
    @owner = owner
    @champsPlayed = champsPlayed
    self.class.all << self
  end

  def champsPlayed
    champsPlayedArray = []
    @champsPlayed.each do |champid|
      champsPlayedArray << champid.values.first.to_s
    end
    champsPlayedArray
  end

  def self.all
    @@all
  end

  def self.get_matches(name)
    matchIds = []
    champsPlayed = []
    matchData = []
    data = LeagueInfo::Getdata.new
    #LeagueInfo::Users.current.matches << data.get("https://na1.api.riotgames.com/lol/match/v4/matchlists/by-account/#{name.accountId}?api_key=#{LeagueInfo::Getdata.APIKEY}")
    matches = data.get("https://na1.api.riotgames.com/lol/match/v4/matchlists/by-account/#{name.accountId}?endIndex=10&api_key=#{LeagueInfo::Getdata.APIKEY}")[:matches]
    puts ' Iterating through match data: '.green
    bar = TTY::ProgressBar.new(" [:bar]".green , total: matches.count, width: 77) # total is the count of matches progress is advanced inside loop below by each iteration
    matches.each do |k|
      k.each { |key, value| matchIds << {key => value} if key == :gameId}
      k.each { |key, value| champsPlayed << {key => value} if key == :champion}
    end
    matchIds.each_with_index do |_ , i| # this loop iterates through each gameId and sets it to the currentGameId
      currentGameId = matchIds[i].values.join()
      matchHistory = data.get("https://na1.api.riotgames.com/lol/match/v4/matches/#{currentGameId}?api_key=#{LeagueInfo::Getdata.APIKEY}")[:teams] # pulls match data depending on current gameId
      return 'No matches!' if matchHistory == nil # temporary solution for matches too old to lookup
      matchData << matchHistory # push match data from current iteration into an array
        bar.advance(1)
    end
    createMatches(matchData, champsPlayed)
  end

  def self.all_by_name(owner)
    all.select { |obj| obj.owner == owner}
  end

  def self.have_matches?(owner)
     self.all.any?{ |obj| obj.owner == (owner) }
  end

  def self.createMatches(matches, champsPlayed)
    owner = LeagueInfo::Users.current
    matches.each_with_index do |game, _| # This gives all games in an array each game containing 2 hashes one for the winning team one for losing team so iterate through each game with index
      # index is not used here but left as a reminder you use index to go a level deeper into the hash
      self.new(game, owner, champsPlayed) unless self.all.any?{ |obj| obj.teams.include? (game) }
    end
  end
end
