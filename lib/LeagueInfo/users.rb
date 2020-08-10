class LeagueInfo::Users
  @@all = []
  @@current_user
  attr_accessor :id, :accountId, :puuid, :name, :profileIconId, :revisionDate, :summonerLevel
  def initialize

  end

  def current_user(nameArg)
    @@current_user = all.detect{|user| user.name == nameArg} #set current user
  end

  def save
    self.class.all << self
  end

  def self.get_user(name)
    data = LeagueInfo::Getdata.new
    userdetails = data.get("https://na1.api.riotgames.com/lol/summoner/v4/summoners/by-name/#{name}?api_key=#{LeagueInfo::Getdata.apikey}")
    new = self.new
    userdetails.each{ |k,v| new.send("#{k}=", v) }
    new
  end

  def self.all
    @@all
  end
end