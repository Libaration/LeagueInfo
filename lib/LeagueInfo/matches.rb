require 'pry'
class LeagueInfo::Matches

  def initialize

  end

  def self.get_matches(name)
    collecteddetails = nil
    matchIds = []
    data = LeagueInfo::Getdata.new
    #LeagueInfo::Users.current.matches << data.get("https://na1.api.riotgames.com/lol/match/v4/matchlists/by-account/#{name.accountId}?api_key=#{LeagueInfo::Getdata.APIKEY}")
    matches = data.get("https://na1.api.riotgames.com/lol/match/v4/matchlists/by-account/#{name.accountId}?endIndex=1&api_key=#{LeagueInfo::Getdata.APIKEY}")[:matches]
    matches.each do |k|
      k.each { |key, value| matchIds << {key => value} if key == :gameId }
    end
    matchIds.each do |game|
      gameid = game.values.first
      matchdetails = data.get("https://na1.api.riotgames.com/lol/match/v4/matches/#{gameid}?api_key=#{LeagueInfo::Getdata.APIKEY}")
      collecteddetails = { :team1 => [], :team2 => [], :stats => [], :playerinfo => [], :champion => [] }
      matchdetails[:teams][0].each do |key,value|
        attributes = [:win, :teamId, :towerKills, :bans]
        collecteddetails[:team1] = matchdetails[:teams][0].select do |val|
          attributes.include?(val)
        end
      end
      #TODO fix . can only do one game a time needs rewrite.
      matchdetails[:teams][1].each do |key,value|
        attributes = [:win, :teamId, :towerKills, :bans]
        collecteddetails[:team2] = matchdetails[:teams][1].select do |val|
          attributes.include?(val)
        end
      end
      matchdetails[:participantIdentities].each do |key,value|
        attributes = [:summonerName]
        collecteddetails[key] = matchdetails[:participantIdentities].select do |val|
          attributes.include?(val)
        end
      end
    end
    pp collecteddetails
  end
end
