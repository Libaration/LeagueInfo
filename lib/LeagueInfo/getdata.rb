require 'open-uri'
require 'json'
require 'net/http'

class LeagueInfo::Getdata
  #attr_reader :APIKEY
  APIKEY = 'RGAPI-c22d83c0-485c-4821-a4ab-4420284bf4f8'.freeze
  def get(url)
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body, { symbolize_names: true })
  end

  def self.apikey
    APIKEY
  end
end