require 'colorize'
require 'tty-prompt'
require 'pry'
class LeagueInfo::CLI
  prompt = TTY::Prompt.new
  def splash
    puts "

█████                                                       █████               ██████
░░███                                                       ░░███               ███░░███
 ░███         ██████   ██████    ███████ █████ ████  ██████  ░███  ████████    ░███ ░░░   ██████
 ░███        ███░░███ ░░░░░███  ███░░███░░███ ░███  ███░░███ ░███ ░░███░░███  ███████    ███░░███
 ░███       ░███████   ███████ ░███ ░███ ░███ ░███ ░███████  ░███  ░███ ░███ ░░░███░    ░███ ░███
 ░███      █░███░░░   ███░░███ ░███ ░███ ░███ ░███ ░███░░░   ░███  ░███ ░███   ░███     ░███ ░███
 ███████████░░██████ ░░████████░░███████ ░░████████░░██████  █████ ████ █████  █████    ░░██████
░░░░░░░░░░░  ░░░░░░   ░░░░░░░░  ░░░░░███  ░░░░░░░░  ░░░░░░  ░░░░░ ░░░░ ░░░░░  ░░░░░      ░░░░░░
                                ███ ░███
                               ░░██████
                                ░░░░░░    ".blue
    LeagueInfo::Champions.load_champions
    start
  end

  def start
    prompt = TTY::Prompt.new(active_color: :blue)
    prompt.on(:keypress) do |event|
      if event.value == "\u0015"
        puts "CTRL U was pressed"  #TODO implement user switcher hotkey????
      end
    end
    response = prompt.select('Make a selection to begin.', ['Find a Champion', 'Find a User'])
    case response
    when 'Find a Champion'
      all_champions
    when 'Find a User'
      find_user
    end
  end

  def attributes(champion)
    puts "#{champion.img}".light_blue
    prompt = TTY::Prompt.new(active_color: :blue)
    choices = %w(Key Blurb Tags)
    champattr = prompt.multi_select("Which attributes do you want to find out about?", choices)
    champattr.each do |attr|
      puts "#{attr}: ".red + champion.send(attr.downcase).join('/').blue if attr == 'Tags'
      puts "#{attr}: ".red + champion.send(attr.downcase).blue unless attr == 'Tags'
    end
    navkey = prompt.keypress("Press 'M' to return to main menu Press 'C' to return to champion selection or just press 'ESC' to exit".red)
    case navkey
    when 'm'
      start
    when 'c'
      all_champions
    when "\e"
      goodbye
    when "\r"
      start
    end
  end

  def all_champions
    prompt = TTY::Prompt.new(active_color: :blue)
    champArray = []
    #LeagueInfo::Champions.all.each{ |champion| puts "#{champion.name}".blue}
    LeagueInfo::Champions.all.each{ |champion| champArray << champion.name}
    champion = prompt.select('What champion are you searching for? (You can type!)', champArray, filter: true)
    attributes(LeagueInfo::Champions.find_by_name(champion))
  end

  def find_user
    prompt = TTY::Prompt.new(active_color: :blue)
    user = prompt.ask('Enter your league username:')
    unsavedUser = LeagueInfo::Users.get_user(user)
    ['accountId', 'id', 'name', 'profileIconId', 'puuid', 'summonerLevel'].each{|var| print "#{var}: " ; puts unsavedUser.send("#{var}")}
    navkey = prompt.keypress("Press S to save this account or press M to go back to the main menu".yellow)
    case navkey
    when 'm'
      start
    when 's'
      unsavedUser.save
    end
  end

  def goodbye
    puts 'See you soon!'.blue
  end
end
