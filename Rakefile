desc "Build the libspotify gem for supported platforms"
task :build do
  require 'fileutils'

  root = File.dirname(__FILE__)
  bins = File.join(root, 'bin/')
  pkgs = File.join(root, 'pkg/')

  # We want the right binary location.
  require_relative 'lib/libspotify'

  # Maps platform to libspotify binary name.
  platforms =
  {
    "universal-darwin"  => "libspotify-darwin.dylib",
    "i686-linux"        => "libspotify-i686-linux.so",
    "x86_64-linux"      => "libspotify-x86_64-linux.so",
    Gem::Platform::RUBY => nil, # fallback platform
  }

  # Load our gem specification.
  original = Gem::Specification.load('libspotify.gemspec')

  # Now build the gem for each platform.
  platforms.each_pair do |platform, name|
    # Make sure we don’t break anything.
    spec = original.dup

    puts "Building for platform #{platform}."
    spec.platform = platform

    if name.nil? # pure ruby build
      spec.files.delete(LIBSPOTIFY_BIN)
    else
      source_binary = File.join(bins, name)
      FileUtils.cp(source_binary, LIBSPOTIFY_BIN, verbose: true)
    end

    # Move the build binary to the pkg/ directory.
    gempath = Gem::Builder.new(spec).build
    gemname = File.basename(gempath, ".gem")
    gemname << "-#{platform}.gem"

    FileUtils.mkdir_p(pkgs, verbose: true)
    FileUtils.mv(gempath, File.join(pkgs, gemname), verbose: true)
  end
end

desc "Launch an IRB console with the gem loaded."
task :console do
  exec 'irb -Ilib -rlibspotify'
end

task :default => :console
