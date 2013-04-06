# encoding: utf-8
require File.expand_path('../lib/libspotify', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "libspotify"
  gem.authors       = ["Kim Burgestrand"]
  gem.email         = ["kim@burgestrand.se"]
  gem.summary       = %q{A binary ruby gem for distribution of libspotify.}
  gem.homepage      = "https://github.com/Burgestrand/libspotify"
  gem.require_paths = ["lib"]
  gem.files         = `git ls-files`.split($/)

  gem.version       = Libspotify::GEM_VERSION
  gem.platform      = Gem::Platform::RUBY
end
