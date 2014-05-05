desc "Build the libspotify gem for supported platforms"
task :build do
  require "rubygems/package"
  require "fileutils"

  root = File.dirname(__FILE__)
  bins = File.join(root, "bin/")
  pkgs = File.join(root, "pkg/")
  FileUtils.mkdir_p(pkgs, verbose: true)

  # We want the right binary location.
  require_relative "lib/libspotify"

  platforms = Libspotify::PLATFORMS.dup
  platforms[Gem::Platform::RUBY] = [] # fallback platform
  platforms["universal-java"] = platforms.values.flatten.uniq

  # Maps binaries to system path.
  binaries =
  {
    "universal-darwin" => "libspotify-12.1.51-Darwin-universal/libspotify-12.1.51-Darwin-universal/libspotify.framework/Versions/Current/libspotify",
    "x86-linux"        => "libspotify-12.1.51-Linux-i686-release/lib/libspotify.so",
    "x86_64-linux"     => "libspotify-12.1.51-Linux-x86_64-release/lib/libspotify.so",
    "armv5-linux"      => "libspotify-12.1.51-Linux-armv5-release/lib/libspotify.so",
    "armv6hf-linux"    => "libspotify-12.1.103-Linux-armv6-bcm2708hardfp-release/lib/libspotify.so",
    # armv5 works on both armv6 and armv7, so we always use armv5.
    "armv6-linux"      => "libspotify-12.1.51-Linux-armv6-release/lib/libspotify.so",
    "armv7-linux"      => "libspotify-12.1.51-Linux-armv7-release/lib/libspotify.so",
    "x86-windows"      => "libspotify-12.1.51-win32-release/lib/libspotify.dll",
  }

  # Load our gem specification.
  original = Gem::Specification.load("libspotify.gemspec")

  # Now build the gem for each platform.
  gempaths = platforms.each_pair.map do |platform, source_binaries|
    # Make sure we don’t break anything.
    spec = original.dup

    puts
    puts "[#{platform}]"
    spec.platform = platform

    if source_binaries.empty?
      puts "Pure ruby build."
      spec.post_install_message = <<-MSG.gsub(/ {2,}/, " ")
        Binary libspotify gem could not be installed. You will need to install libspotify separately.
        If you are on ARM (e.g. Raspberry PI), you might want to install the gem with explicit --platform:
        $> gem install libspotify --platform arm-linux
      MSG
    else
      source_binaries.each do |binary|
        src_name  = "bin/#{binaries[binary]}"
        dest_name = "bin/#{binary}"
        FileUtils.cp(src_name, dest_name, verbose: true)
        spec.files << dest_name
      end
    end

    # Move the build binary to the pkg/ directory.
    gemname = Gem::Package.build(spec)
    File.join(pkgs, File.basename(gemname)).tap do |gempath|
      FileUtils.mv(gemname, gempath, verbose: true)
    end
  end

  puts
  puts "All gems successfully built. To publish, do:"
  gempaths.each do |path|
    puts "  gem push pkg/#{File.basename(path)}"
  end

  puts
  puts "Do not forget to tag and push to GitHub as well."
end

desc "Download all known libspotify releases and unpack them"
task :download do
  urls = %w[
    https://developer.spotify.com/download/libspotify/libspotify-12.1.64-iOS-universal.zip
    https://developer.spotify.com/download/libspotify/libspotify-12.1.51-Android-arm-release.tar.gz
    https://developer.spotify.com/download/libspotify/libspotify-12.1.51-win32-release.zip
    https://developer.spotify.com/download/libspotify/libspotify-12.1.51-Darwin-universal.zip
    https://developer.spotify.com/download/libspotify/libspotify-12.1.51-Linux-i686-release.tar.gz
    https://developer.spotify.com/download/libspotify/libspotify-12.1.51-Linux-x86_64-release.tar.gz
    https://developer.spotify.com/download/libspotify/libspotify-12.1.51-Linux-armv5-release.tar.gz
    https://developer.spotify.com/download/libspotify/libspotify-12.1.51-Linux-armv6-release.tar.gz
    https://developer.spotify.com/download/libspotify/libspotify-12.1.51-Linux-armv7-release.tar.gz
    https://developer.spotify.com/download/libspotify/libspotify-12.1.103-Linux-armv6-bcm2708hardfp-release.tar.gz
  ]

  Dir.chdir "bin" do
    urls.map do |url|
      Thread.new do
        unless File.exist?(File.basename(url))
          sh "curl", "-O", "-s", url
        else
          puts "Skipping #{url}."
        end
      end
    end.map(&:join)

    Dir["./*.zip"].each do |zipfile|
      sh "unzip", zipfile, "-d", File.basename(zipfile, ".zip")
    end

    Dir["./*.tar.gz"].each do |tarfile|
      sh "tar", "xvfz", tarfile
    end
  end
end

desc "Launch an IRB console with the gem loaded."
task :console do
  exec "irb -Ilib -rlibspotify"
end

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new("spec") do |task|
  task.ruby_opts = "-W2"
end

task :default => :spec
