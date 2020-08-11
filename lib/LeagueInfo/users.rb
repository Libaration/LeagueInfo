class LeagueInfo::Users
  @@all = []
  @@current
  attr_accessor :id, :accountId, :puuid, :name, :profileIconId, :revisionDate, :summonerLevel
  def initialize

  end

  def current_user(nameArg)
    @@current = all.detect{|user| user.name == nameArg} #set current user
  end

  def save
    self.class.all << self
  end

  def self.find_by_name(name)
    all.detect{|user| user.name == name}
  end

  def self.get_user(name)
    data = LeagueInfo::Getdata.new
    userdetails = data.get("https://na1.api.riotgames.com/lol/summoner/v4/summoners/by-name/#{name}?api_key=#{LeagueInfo::Getdata.APIKEY}")
    new = self.new
    userdetails.each{ |k,v| new.send("#{k}=", v) }
    new
  end

  def self.all
    @@all
  end

  def self.current
    @@current
  end

  def self.current=(user)
    @@current = user
  end
end