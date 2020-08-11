require 'pry'
class LeagueInfo::Matches

  def self.get_matches(name)
    matchIds = []
    data = LeagueInfo::Getdata.new
    #LeagueInfo::Users.current.matches << data.get("https://na1.api.riotgames.com/lol/match/v4/matchlists/by-account/#{name.accountId}?api_key=#{LeagueInfo::Getdata.APIKEY}")
    matches = data.get("https://na1.api.riotgames.com/lol/match/v4/matchlists/by-account/#{name.accountId}?api_key=#{LeagueInfo::Getdata.APIKEY}")[:matches]
    matches.each do |k|
      k.each { |key, value| matchIds << {key => value} if key == :gameId }
    end
    pp matchIds
  end

end
