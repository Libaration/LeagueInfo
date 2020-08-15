require 'open-uri'
require 'json'
require 'net/http'
require 'nokogiri'
require 'pry'
require 'dotenv'
Dotenv.load

class LeagueInfo::Getdata
  APIKEY = ENV["APIKEY"]
  def self.get(url)
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
    usersCollected = Array.new.tap do |array|
      users = scrapeData('https://www.leagueofgraphs.com/rankings/summoners/na').css("span.name")
      users.each { |name| array << name.text}
    end
    usersCollected.sample
  end
end