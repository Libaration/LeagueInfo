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
    userdetails = LeagueInfo::Getdata.get_user(name)
     self.new.tap do |user|
      user.rank = scrape_rank(name)
      userdetails.each{ |key,value| user.send("#{key}=", value) }
    end
  end

  def self.scrape_rank(name)
    doc = LeagueInfo::Getdata.scrapeData("https://na.op.gg/summoner/userName=#{name}")
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