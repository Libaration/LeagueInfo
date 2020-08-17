class LeagueInfo::Friends
  @@all = []
  attr_accessor :match

  def initialize(teamId:, championId:, participantId:, match:)
    @teamId = teamId
    @championId = championId
    @participantId = participantId
    @match = match
    @@all << self
  end

  def self.all
    @@all
  end
end
