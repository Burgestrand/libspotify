# encoding: utf-8

Gem::Specification.new do |gem|
  gem.name          = "libspotify"
  gem.authors       = ["Kim Burgestrand"]
  gem.email         = ["kim@burgestrand.se"]
  gem.summary       = %q{A binary ruby gem for distribution of libspotify.}
  gem.homepage      = "github.com/Burgestrand/libspotify"
  gem.require_paths = ["lib"]

  gem.version       = "12.1.51.0"
  gem.platform      = Gem::Platform::RUBY

  gem.files         = `git ls-files`.split($/)

  # No need to include the libspotify binaries in the gem build.
  gem.files.delete_if { |x| x =~ /\Abin/ }

  # No need to include the libspotify binary either if we are in ruby build.
  if gem.platform == Gem::Platform::RUBY
    gem.files.delete_if { |x| x =~ /\.(so|dylib|dll)\z/ }
  end
end
