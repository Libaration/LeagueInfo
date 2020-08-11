require 'pry'
class LeagueInfo::Matches

  def initialize

  end

  def self.get_matches(name)
    collected = []
    matchIds = []
    data = LeagueInfo::Getdata.new
    #LeagueInfo::Users.current.matches << data.get("https://na1.api.riotgames.com/lol/match/v4/matchlists/by-account/#{name.accountId}?api_key=#{LeagueInfo::Getdata.APIKEY}")
    matches = data.get("https://na1.api.riotgames.com/lol/match/v4/matchlists/by-account/#{name.accountId}?endIndex=2&api_key=#{LeagueInfo::Getdata.APIKEY}")[:matches]
    matches.each do |k|
      k.each { |key, value| matchIds << {key => value} if key == :gameId }
    end
    pp matchIds

    #todo matchids pulls all matchIds for current player need to iterate through them all sending calls to match history
    # details api.

  end
end
