class LeagueInfo::Champions
  @@all = []
  def initialize
    #todo init new champs from json
    @@all << self
  end

  def self.all
    @@all
  end
end
