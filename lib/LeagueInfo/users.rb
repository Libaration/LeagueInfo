class LeagueInfo::Users
  @@all = []
  @@current
  attr_accessor :id, :accountId, :puuid, :name, :profileIconId, :revisionDate, :summonerLevel, :matches, :rank
  def initialize

  end

  def save
    self.class.all << self
  end

  def self.find_by_name(name)
    all.detect{|user| user.name == name}
  end

  def self.get_user(name)
    userdetails = LeagueInfo::Getdata.get("https://na1.api.riotgames.com/lol/summoner/v4/summoners/by-name/#{name}?api_key=#{LeagueInfo::Getdata.APIKEY}")
    new = self.new
    new.rank = scrape_rank(name)
    userdetails.each{ |k,v| new.send("#{k}=", v) }
    new
  end

  def self.scrape_rank(name)
    url = "https://na.op.gg/summoner/userName=#{name}"
    doc = Nokogiri::HTML(open(url))
    doc.css("div.TierRank").text
  end

  def self.all
    @@all
  end

  def self.exists?(name)
    all_by_name.include?(name.name) ? true:false
  end

  def self.all_by_name
    all.collect{ |user| user.name }
  end

  def self.current
    @@current
  end

  def self.current=(user)
    @@current = user
  end
end