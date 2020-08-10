require 'open-uri'
require 'nokogiri'
require 'pry'
class LeagueInfo::Champimg
  def self.load(name)
    url = "http://www.asciiarts.net/figlet.ajax.php?message=#{name}&font=isometric4.flf&html_mode=undefined&facebook_mode=undefined"
    doc = Nokogiri::HTML(open(url))
    text = doc.css("div#image").children[1].text
  end

end