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

  def self.scrapeData(url)
    Nokogiri::HTML(open(url))
  end

  def self.APIKEY
    APIKEY
  end

  def self.get_random
    usersCollected = []
    doc = scrapeData('https://www.leagueofgraphs.com/rankings/summoners/na')
    users = doc.css("span.name")
    users.each { |name| usersCollected << name.text}
    usersCollected.sample
  end
end