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
    case LeagueInfo::Users.all.count
    when 0
      choices = [
          { name:'Find a Champion', value:'Find a Champion'},
          { name:'Find a User', value:'Find a User' },
          { name:'My Matches', value:'My Matches', disabled: "(No accounts saved)" }
      ]
      else
      choices = [
          { name:'Find a Champion', value:'Find a Champion'},
          { name:'Find a User', value:'Find a User' },
          { name:'My Matches', value:'My Matches'},
          { name:'Account Switcher', value:'Account Switcher'}
      ]
    end
    response = prompt.select('Make a selection to begin.', choices)
    case response
    when 'Find a Champion'
      all_champions
    when 'Find a User'
      find_user
    when 'My Matches'
      matches
    when 'Account Switcher'
      account_switcher
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
    navkey = prompt.keypress("Press 'M' to return to main menu Press 'C' to return to champion selection or just press 'ESC' to exit".yellow)
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
    user = prompt.ask('Enter your league username:', default: "TSM Bjergsen")
    user = URI.escape user
    unsavedUser = LeagueInfo::Users.get_user(user)
    ['accountId', 'id', 'name', 'profileIconId', 'puuid', 'summonerLevel'].each{|var| print "#{var}: " ; puts unsavedUser.send("#{var}")}
    navkey = prompt.keypress("Press S to save this account or press M to not save and go back to the main menu".yellow)
    case navkey
    when 'm'
      start
    when 's'
      if LeagueInfo::Users.exists?(unsavedUser)
        puts 'User already exists'.red
        account_switcher
      else
        unsavedUser.save
        LeagueInfo::Users.current = unsavedUser
        account_switcher
      end
    end
  end

  def account_switcher
    userArray = []
    prompt = TTY::Prompt.new(active_color: :blue)
      LeagueInfo::Users.all.each do |user|
        userArray << user.name unless user == LeagueInfo::Users.current
        if user == LeagueInfo::Users.current
          user = "#{user.name} (Selected)"
          userArray << user
        end
      end
    if LeagueInfo::Users.all.count > 1
      user = prompt.select('Select an account', userArray, filter: true).gsub("(Selected)", '').strip
      LeagueInfo::Users.current = LeagueInfo::Users.find_by_name(user)
      start
    else
      start
    end

  end

  def matches
    LeagueInfo::Matches.get_matches(LeagueInfo::Users.current)
  end

  def goodbye
    puts 'See you soon!'.blue
  end
end
