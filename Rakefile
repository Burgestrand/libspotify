desc "Build the libspotify gem for supported platforms"
task :build do
  require 'fileutils'

  root = File.dirname(__FILE__)
  bins = File.join(root, 'bin/')
  pkgs = File.join(root, 'pkg/')
  FileUtils.mkdir_p(pkgs, verbose: true)

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

  # output bling.
  puts

  # Now build the gem for each platform.
  gempaths = platforms.each_pair.map do |platform, name|
    # Make sure we don’t break anything.
    spec = original.dup

    print "[#{platform}]: "
    spec.platform = platform

    if name.nil? # pure ruby build
      spec.files.delete('libspotify.library')
      FileUtils.rm(LIBSPOTIFY_BIN, verbose: true)
    else
      source_binary = File.join(bins, name)
      begin
        FileUtils.cp(source_binary, LIBSPOTIFY_BIN, verbose: true)
      rescue Errno::ENOENT
        puts "Missing #{source_binary}. Cannot build for #{platform}."
        exit(false)
      end
    end

    # Annoying.
    Gem.configuration.verbose = false

    # Move the build binary to the pkg/ directory.
    gemname = Gem::Builder.new(spec).build
    File.join(pkgs, File.basename(gemname)).tap do |gempath|
      FileUtils.mv(gemname, gempath)
    end
  end

  puts
  puts "All gems successfully built. To publish, do:"
  gempaths.each do |path|
    puts "  gem push pkg/#{File.basename(path)}"
  end
  puts "Do not forget to push to GitHub as well."
end

desc "Launch an IRB console with the gem loaded."
task :console do
  exec 'irb -Ilib -rlibspotify'
end

task :default => :console
