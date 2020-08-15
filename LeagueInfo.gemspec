require_relative 'lib/LeagueInfo/version'

Gem::Specification.new do |spec|
  spec.name          = "LeagueInfo"
  spec.version       = LeagueInfo::VERSION
  spec.authors       = ["Cristian Deleon"]
  spec.email         = ["libaration@gmail.com"]

  spec.summary       = %q{RIOT API Ruby implementation}
  spec.homepage      = "https://github.com/Libaration/LeagueInfo"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Libaration/LeagueInfo"
  spec.metadata["changelog_uri"] = "https://github.com/Libaration/LeagueInfo/blob/master/CHANGELOG.MD"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency 'colorize', '~> 0.8.1'
  spec.add_dependency 'dotenv', '~> 2.7', '>= 2.7.6'
  spec.add_dependency 'json', '~> 2.1', '>= 2.1.0'
  spec.add_dependency 'nokogiri', '~> 1.10', '>= 1.10.10'
  spec.add_dependency 'pry'
  spec.add_dependency 'rake', '~> 12.0'
  spec.add_dependency 'terminal-table', '~> 1.8'
  spec.add_dependency 'tty-progressbar', '~> 0.17.0'
  spec.add_dependency 'tty-prompt'
end
