require 'rbconfig'

gempath = File.dirname(__FILE__)
suffix  = case RbConfig::CONFIG["host_os"].downcase
when /darwin/
  "dylib"
when /mingw|mswin/
  "dll"
else
  # not windows or mac os, we assume linuxy
  "so"
end

LIBSPOTIFY_BIN = File.expand_path("../libspotify.#{binary}", gempath)
