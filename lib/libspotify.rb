module Libspotify
  VERSION = "12.1.51"
  GEM_VERSION = "#{VERSION}.4"

  # Maps platform to libspotify binary name.
  PLATFORMS = {
    "universal-darwin" => %w"universal-darwin",
    "x86-linux"        => %w"x86-linux",
    "x86_64-linux"     => %w"x86_64-linux",
    "arm-linux"        => %w"armv6-linux armv6hf-linux",
    "x86-mingw32"      => %w"x86-windows.dll",
  }

  class << self
    # @return [String] full path to libspotify binary.
    def binary_path
      File.expand_path("../bin/#{release_name}", File.dirname(__FILE__))
    end

    # @return [String] name of libspotify binary.
    def release_name
      host_platform = Gem::Platform.new(host_string)

      _, binaries = PLATFORMS.find do |platform, _|
        Gem::Platform.new(platform) === host_platform
      end

      binaries ||= []

      binary = if binaries.length == 1
        binaries[0]
      elsif host_cpu =~ /armv(\d+)(hf)?/
        host_version = $1.to_i
        host_hf = $2

        matches = PLATFORMS["arm-linux"].select do |bin|
          version, hf = bin.match(/armv(\d+)(hf)?/)[1..2]
          hf == host_hf && version.to_i <= host_version
        end

        matches.max_by { |bin| bin[/armv(\d+)/, 1].to_i }
      else
        nil # no rules for matching binaries, what to do?
      end

      binary || host_string
    end

    private

    # @return [String] platform name of the host, even on jruby
    def host_string
      "#{host_cpu}-#{host_os}"
    end

    # @return [String] host cpu, even on jruby
    def host_cpu
      case RbConfig::CONFIG["host_cpu"]
      when /86_64/
        "x86_64"
      when /86/
        "x86"
      when /arm/
        hf = "hf" if hard_float?
        "armv#{arm_version}#{hf}"
      else
        RbConfig::CONFIG["host_cpu"]
      end
    end

    # @return [String] host os, even on jruby
    def host_os
      case RbConfig::CONFIG["host_os"]
      when /darwin/
        "darwin"
      when /linux/
        "linux"
      when /mingw|mswin/
        "mingw32"
      else
        RbConfig::CONFIG["host_os"]
      end
    end

    # @return [Integer, nil] ARM instruction set version
    def arm_version
      File.read("/proc/cpuinfo")[/ARMv(\d+)/i, 1].to_i
    end

    # @return [Boolean] true if on a hard floating point OS of arm
    def hard_float?
      `readelf -a #{RbConfig.ruby}`.match(/Tag_ABI_VFP_args/)
    end
  end
end

LIBSPOTIFY_BIN = Libspotify.binary_path
