class LeagueInfo::Stats

  def self.scrape_kda(name)
    puts ' Scraping external data'.green
    name = URI.escape name
    kdaArray = Array.new
    url = "https://na.op.gg/summoner/userName=#{name}"
    doc = Nokogiri::HTML(open(url))
    doc.css("div.GameItemWrap").each do |row|
      kdaArray << [row.css("span.Kill").text.gsub(/[a-z\s]|[A-Z\s]/, ""), row.css("span.Death").text.gsub(/[a-z\s]|[A-Z\s]/, ""), row.css("span.Assist").text.gsub(/[a-z\s]|[A-Z\s]/, "")]
    end
    kdaArray
  end

end
