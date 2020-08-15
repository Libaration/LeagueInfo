require 'pry'
class LeagueInfo::Champions
  attr_accessor :key, :name, :blurb, :version, :info, :id, :title, :image, :tags, :partype, :stats
  @@all = []
  def initialize
    @@all << self
  end

  def img
    doc = LeagueInfo::Getdata.scrapeData("http://www.asciiarts.net/figlet.ajax.php?message=#{self.name}&font=isometric4.flf&html_mode=undefined&facebook_mode=undefined")
    image = doc.css("div#image").children[1].text
    puts "#{image}".light_blue ; puts "                                                   #{self.title}".light_blue
  end

  def self.valid?(id)
    all.any? {|champion| champion.key.include?(id)} ? true : false
  end

  def self.find_by_id(id)
    all.detect { |champion| champion.key == id}
  end

  def self.load_champions
    data = LeagueInfo::Getdata.new
    champlist = data.get('http://ddragon.leagueoflegends.com/cdn/6.24.1/data/en_US/champion.json')[:data]
    champlist.each do |_key, value|
      champion = self.new
      value.each_pair { |k, v| champion.send("#{k}=", v)}
    end
  end

  def self.find_by_name(name)
    all.detect { |champion| champion.name == name }
  end

  def winratio
    # stats call
  end


  def self.all
    @@all
  end
end
