require 'open-uri'
require 'json'
require 'net/http'
require 'nokogiri'

class LeagueInfo::Getdata
  attr_reader :APIKEY
  APIKEY = 'RGAPI-c22d83c0-485c-4821-a4ab-4420284bf4f8'.freeze
  def get(url)
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body, { symbolize_names: true })
  end

  def self.APIKEY
    APIKEY
  end

  def self.get_random
    usersCollected = []
    url = 'https://www.leagueofgraphs.com/rankings/summoners/na'
    doc = Nokogiri::HTML(open(url))
    users = doc.css("span.name")
    users.each { |name| usersCollected << name.text}
    usersCollected.sample
  end

  def self.scrape_kda(name)
    name = URI.escape name
    url = "https://lolprofile.net/summoner/na/#{name}"
    doc = Nokogiri::HTML(open(url))
    rows = doc.css("div.s-rg")
    kda = rows.css("span.kda.victory-text1")
    kdaArray = Array.new.tap do |array|
      kda.each{|thing| array << thing.text.gsub(/\s+/, "").split("/")}
    end
  end
end