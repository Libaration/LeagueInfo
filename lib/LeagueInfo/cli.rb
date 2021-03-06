require 'colorize'
require 'tty-prompt'
require 'pry'
require 'terminal-table'
class LeagueInfo::CLI
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
          { name:'Match History', value:'My Matches', disabled: "(No accounts saved)" }
      ]
      else
      choices = [
          { name:'Find a Champion', value:'Find a Champion'},
          { name:'Find a User', value:'Find a User' },
          { name:'Match History', value:'My Matches'},
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
    champion.img
    prompt = TTY::Prompt.new(active_color: :blue)
    choices = %w(Key Blurb Tags Stats)
    champattr = prompt.multi_select("Which attributes do you want to find out about?", choices)
    if champattr.count == 0
      puts 'Please make a selection!'.red
      sleep(1)
      attributes(champion)
      else
    champattr.each do |attr|
      puts "#{attr}: ".red + champion.send(attr.downcase).join('/').blue if attr == 'Tags'
      puts "#{attr}: ".red + champion.send(attr.downcase).blue unless attr == 'Tags' || attr == 'Stats'
      rows = Array.new.tap do |row|
        if attr == 'Stats'
          champion.send(attr.downcase).collect do |k, v,| #calls on instance stats variable which is a hash
            row << ["#{k.capitalize}".red, "#{v}".blue]
          end
        end
      end
      table = Terminal::Table.new :rows => rows, :headings => ['Stat', 'Value']
      table.align_column(1, :right)
      table.style = {:width => 50, :padding_left => 3, :border_x => "=", :border_i => "x", :all_separators => false}
      puts table  if attr == 'Stats'
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
  end

  def all_champions
    prompt = TTY::Prompt.new(active_color: :blue)
    champArray = Array.new.tap { |array| LeagueInfo::Champions.all.each { |champion| array << champion.name } }
    champion = prompt.select('What champion are you searching for? (You can type!)', champArray, filter: true)
    attributes(LeagueInfo::Champions.find_by_name(champion))
  end

  def find_user
    prompt = TTY::Prompt.new(active_color: :blue)
    user = prompt.ask('Enter your league username:', default: "Press Return for Random summoner")
    user = LeagueInfo::Getdata.get_random if user == 'Press Return for Random summoner'
    user = URI.escape user
    unsavedUser = LeagueInfo::Users.get_user(user)
    ['accountId', 'id', 'name', 'profileIconId', 'puuid', 'summonerLevel', 'rank'].each{|var| print "#{var}: ".capitalize.blue ; puts unsavedUser.send("#{var}")}
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
    totalGames = 0 ; wonGames = 0
    prompt = TTY::Prompt.new(active_color: :blue)
    LeagueInfo::Matches.get_matches(LeagueInfo::Users.current) if LeagueInfo::Matches.have_matches?(LeagueInfo::Users.current) == false # not the cleanest way to do this
    matchobjects = LeagueInfo::Matches.all_by_name(LeagueInfo::Users.current)
    kdaArray = LeagueInfo::Getdata.scrape_kda(LeagueInfo::Users.current.name)
    rows = []
    matchobjects.each_with_index do |match, i|
      match.friendlyResult == 'Win' ? outcome = 'WIN'.green + ' / LOSE' : outcome = 'WIN / ' + 'LOSE'.red
      if LeagueInfo::Champions.find_by_id(match.champPlayed.to_s) == nil
        championname = 'Not in database'
      else
        championname = LeagueInfo::Champions.find_by_id(match.champPlayed.to_s).name
      end
      rows << [match.friendlyResult == 'Win' ? "#{championname}".green : "#{championname}".red, "#{outcome}", "#{kdaArray[i][0]}".green + " / " + "#{kdaArray[i][1]}".red + " / " + "#{kdaArray[i][2]}"]
      totalGames += 1
      wonGames += 1 if match.friendlyResult == 'Win'
    end
    table = Terminal::Table.new :rows => rows, :headings => ['Champion'.blue, 'Result'.blue, 'K / D / A'.blue]
    table.style = {:width => 80, :padding_left => 3, :border_x => "=".blue, :border_i => "x", :all_separators => false}
    puts table
    winPercent = wonGames.to_f / totalGames * 100
    if winPercent > 50
      puts "       #{LeagueInfo::Users.current.name} is at a ".blue + "%#{winPercent.to_i}".green + " win rate in the last #{totalGames} games".blue
    else
      puts "       #{LeagueInfo::Users.current.name} is at a ".blue + "%#{winPercent.to_i}".red + " win rate in the last #{totalGames} games".blue
    end
      puts "#{LeagueInfo::Matches.most_played}".blue
    navkey = prompt.keypress("Press M to go back to the main menu. Press ESC to exit".yellow)
    case navkey
    when 'm'
      start
    when "\e"
      goodbye
    when "\r"
      start
    end
  end

  def goodbye
    puts 'See you soon!'.blue
  end
end
