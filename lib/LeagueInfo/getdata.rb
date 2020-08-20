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
    scrapeData('https://www.leagueofgraphs.com/rankings/summoners/na').css("span.name").collect { |name| name.text }.sample
  end

  def self.scrape_kda(name)
    puts ' Scraping external data'.green
    name = URI.escape name
    doc = scrapeData("https://na.op.gg/summoner/userName=#{name}")
      doc.css('div.GameItemWrap').collect do |row|
        [row.css('span.Kill').text.gsub(/[a-z\s]|[A-Z\s]/, ''), row.css('span.Death').text.gsub(/[a-z\s]|[A-Z\s]/, ''), row.css('span.Assist').text.gsub(/[a-z\s]|[A-Z\s]/, '')]
      end
  end

  def self.get_matches(name)
    get("https://na1.api.riotgames.com/lol/match/v4/matchlists/by-account/#{name.accountId}?endIndex=10&api_key=#{APIKEY}")[:matches]
  end

  def self.get_match_data(gameId)
    get("https://na1.api.riotgames.com/lol/match/v4/matches/#{gameId}?api_key=#{APIKEY}")[:teams]
  end

  def self.get_user(name)
    get("https://na1.api.riotgames.com/lol/summoner/v4/summoners/by-name/#{name}?api_key=#{APIKEY}")
  end

  def self.get_champions
    get('http://ddragon.leagueoflegends.com/cdn/10.16.1/data/en_US/champion.json')[:data]
  end
end