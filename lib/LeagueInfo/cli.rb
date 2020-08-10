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
    response = prompt.select('Make a selection to begin.', ['Find a Champion', 'Find a User'])
    case response
    when 'Find a Champion'
      prompt.on(:keypress) do |event|
        if event.value == '='
          all_champions #used to show list found better method
        end
      end
      championselected = all_champions
      attributes(LeagueInfo::Champions.find_by_name(championselected))
    when 'Find a User'
      p 'findinguser'
    end
  end

  def attributes(champion)
    prompt = TTY::Prompt.new(active_color: :blue)
    choices = %w(Key Blurb Tags)
    #binding.pry
    prompt.multi_select("Which attributes do you want to find out about?", choices)
  end

  def all_champions
    prompt = TTY::Prompt.new(active_color: :blue)
    champArray = []
    #LeagueInfo::Champions.all.each{ |champion| puts "#{champion.name}".blue}
    LeagueInfo::Champions.all.each{ |champion| champArray << champion.name}
    prompt.select('What champion are you searching for? (You can type!)', champArray, filter: true)
  end
end
