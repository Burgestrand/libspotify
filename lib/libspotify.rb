module Libspotify
  VERSION = "12.1.51"
  GEM_VERSION = "#{VERSION}.3"

  module_function

  # @return [String] full path to libspotify binary.
  def binary_path
    File.expand_path("../bin/#{release_name}", File.dirname(__FILE__))
  end

  # @api private
  # @return [String] name of libspotify binary.
  def release_name
    case RbConfig::CONFIG["host_os"]
    when /darwin/
      "universal-darwin"
    when /linux/
      case RbConfig::CONFIG["host_cpu"]
      when /86_64/
        "x86_64-linux"
      when /86/
        "i686-linux"
      when /armv(\d+)?/
        hf = "hf" if hard_float?
        "armv5#{hf}-linux"
      end
    when /mingw|mswin/
      "windows.dll"
    else
      "unknown-%s-%s" % RbConfig::CONFIG.values_at("host_cpu", "host_os")
    end
  end

  # @api private
  # @return [Boolean] true if on a hard floating point OS of arm
  def hard_float?
    `readelf -a #{RbConfig.ruby}`.match(/Tag_ABI_VFP_args/)
  end
end

LIBSPOTIFY_BIN = Libspotify.binary_path
