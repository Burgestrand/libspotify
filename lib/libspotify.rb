module Libspotify
  VERSION = "12.1.51"
  GEM_VERSION = "#{VERSION}.2"

  module_function

  def binary_path
    File.expand_path("../bin/#{release_name}", File.dirname(__FILE__))
  end

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
        v  = $1
        hf = "hf" if hard_float?
        "armv#{v}#{hf}-linux"
      end
    else
      "unknown-%s-%s" % RbConfig::CONFIG.values_at("host_cpu", "host_os")
    end
  end

  def hard_float?
    `readelf -a #{RbConfig.ruby}`.match(/Tag_ABI_VFP_args/)
  end
end

LIBSPOTIFY_BIN = Libspotify.binary_path
