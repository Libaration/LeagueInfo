require_relative 'lib/LeagueInfo/version'

Gem::Specification.new do |spec|
  spec.name          = "LeagueInfo"
  spec.version       = LeagueInfo::VERSION
  spec.authors       = ["Cristian Deleon"]
  spec.email         = ["libaration@gmail.com"]

  spec.summary       = %q{TODO: Write a short summary, because RubyGems requires one.}
  spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "github.com/kdkwdwkdnknk"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency 'colorize', '~> 0.8.1'
  spec.add_dependency 'json', '~> 2.1', '>= 2.1.0'
  spec.add_dependency 'nokogiri', '~> 1.10', '>= 1.10.10'
  spec.add_dependency 'pry', group: :development
  spec.add_dependency 'rake', '~> 12.0'
  spec.add_dependency 'tty-prompt', '~> 0.22.0'
  spec.add_dependency 'tty-table', '~> 0.11.0'
end
