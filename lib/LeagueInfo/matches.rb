require 'pry'
require 'tty-progressbar'
class LeagueInfo::Matches
  @@all = []
  attr_accessor :owner, :champsPlayed, :friendlyResult, :enemyResult, :gameId

  def initialize(friendlyResult:, owner:, champsPlayed:, enemyResult:, gameId:)
    @friendlyResult = friendlyResult
    @enemyResult = enemyResult
    @gameId = gameId
    @owner = owner
    @champsPlayed = champsPlayed
    self.class.all << self
  end

  def self.all
    @@all
  end

  def self.get_matches(name)
    matchesjson = LeagueInfo::Getdata.get("https://na1.api.riotgames.com/lol/match/v4/matchlists/by-account/#{name.accountId}?endIndex=10&api_key=#{LeagueInfo::Getdata.APIKEY}")[:matches]
    puts ' Iterating through match data: '.green
    bar = TTY::ProgressBar.new(' [:bar]'.green , total: matchesjson.count, width: 77) # total is the count of matches progress is advanced inside loop below by each iteration
    matchesjson.each do |match|
      bar.advance(1)
      currentGame = LeagueInfo::Getdata.get("https://na1.api.riotgames.com/lol/match/v4/matches/#{match[:gameId]}?api_key=#{LeagueInfo::Getdata.APIKEY}")[:teams]
      unless all.any? { |obj| obj.gameId == match[:gameId] }
        new(friendlyResult: currentGame[0][:win], enemyResult: currentGame[1][:win], owner: LeagueInfo::Users.current, champsPlayed: match[:champion], gameId: match[:gameId])
      end
    end
  end

  def self.all_by_name(owner)
    all.select { |obj| obj.owner == owner}
  end

  def self.have_matches?(owner) 
    all.any?{ |obj| obj.owner == owner }
  end


  def self.most_played
    champsArray = all_by_name(LeagueInfo::Users.current).collect do |match|
      match.champsPlayed.to_s
    end
    champFrequency = {}.tap do |hash|
      champsArray.collect {|champid| hash[champid.to_sym] = champsArray.count(champid) }
    end
    if LeagueInfo::Champions.valid?(champFrequency.key(champFrequency.values.max).to_s) == true
      puts '          Most played champion: '.blue + LeagueInfo::Champions.find_by_id(champFrequency.key(champFrequency.values.max).to_s).name.to_s
    else
      puts '          Most played champion: Not in database (New Champion)'
    end
  end
end
