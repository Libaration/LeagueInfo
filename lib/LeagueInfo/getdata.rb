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

  def self.scrape_kda(name)
    puts ' Scraping external data'.green
    name = URI.escape name
    doc = LeagueInfo::Getdata.scrapeData("https://na.op.gg/summoner/userName=#{name}")
      doc.css('div.GameItemWrap').collect do |row|
        [row.css('span.Kill').text.gsub(/[a-z\s]|[A-Z\s]/, ''), row.css('span.Death').text.gsub(/[a-z\s]|[A-Z\s]/, ''), row.css('span.Assist').text.gsub(/[a-z\s]|[A-Z\s]/, '')]
      end
  end
end