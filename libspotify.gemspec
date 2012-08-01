# encoding: utf-8

Gem::Specification.new do |gem|
  gem.name          = "libspotify"
  gem.authors       = ["Kim Burgestrand"]
  gem.email         = ["kim@burgestrand.se"]
  gem.description   = %q{A binary ruby gem for distribution of libspotify.}
  gem.homepage      = "github.com/Burgestrand/libspotify"
  gem.files         = `git ls-files`.split($/)
  gem.require_paths = ["lib"]

  gem.version       = "12.1.51"
  gem.platform      = Gem::Platform::RUBY
end
