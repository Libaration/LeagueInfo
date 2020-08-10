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
    start
  end

  def start
    prompt = TTY::Prompt.new(active_color: :blue)
    prompt.on(:keypress) do |event|
      if event.value == '='
        all_champions
      end
    end
    response = prompt.select('Make a selection to begin.', ['Find a Champion', 'Find a User'])
    case response
    when 'Find a Champion'
      p 'findingchamp'
      champion = prompt.ask('What champion are you searching for?', default: 'Press = for a list').gsub!(/\W/,'')
    when 'Find a User'
      p 'findinguser'

    end
  end

  def all_champions
    LeagueInfo::Champions.all
  end
end
