require 'open-uri'
require 'json'
require 'net/http'
require 'nokogiri'
require 'pry'
require 'dotenv'
Dotenv.load

class LeagueInfo::Getdata
  APIKEY = ENV["APIKEY"]
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
    kdaArray = Array.new
    url = "https://na.op.gg/summoner/userName=#{name}"
    doc = Nokogiri::HTML(open(url))
    rows = doc.css("div.GameItemWrap").each do |row|
      kdaArray << [row.css("span.Kill").text.gsub(/[a-z\s]|[A-Z\s]/, ""), row.css("span.Death").text.gsub(/[a-z\s]|[A-Z\s]/, ""), row.css("span.Assist").text.gsub(/[a-z\s]|[A-Z\s]/, "")]
    end
    kdaArray
  end


end