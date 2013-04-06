require "libspotify"

describe Libspotify do
  describe "binary_path" do
    subject(:release_name) { File.basename(Libspotify.binary_path) }

    before do
      os, cpu = example.description.split(":", 2)
      stub_const("RbConfig::CONFIG", "host_os" => os, "host_cpu" => cpu)
    end

    specify "darwin:i686" do
      release_name.should eq "universal-darwin"
    end

    specify "darwin:x86_64" do
      release_name.should eq "universal-darwin"
    end

    specify "linux-gnu:i686" do
      release_name.should eq "i686-linux"
    end

    specify "linux-gnu:x86_64" do
      release_name.should eq "x86_64-linux"
    end

    context "soft float" do
      before { Libspotify.stub(hard_float?: false) }

      specify "linux-gnueabi:armv5l" do
        release_name.should eq "armv5-linux"
      end

      specify "linux-gnueabi:armv6l" do
        release_name.should eq "armv5-linux"
      end

      specify "linux-gnueabi:armv7l" do
        release_name.should eq "armv5-linux"
      end
    end

    context "hard float" do
      before { Libspotify.stub(hard_float?: true) }

      specify "linux-gnueabi:armv5l" do
        release_name.should eq "armv5hf-linux"
      end

      specify "linux-gnueabi:armv6l" do
        release_name.should eq "armv5hf-linux"
      end

      specify "linux-gnueabi:armv7l" do
        release_name.should eq "armv5hf-linux"
      end
    end

    specify "weird-os:weird-cpu" do
      release_name.should eq "unknown-weird-cpu-weird-os"
    end
  end

  specify "LIBSPOTIFY_BIN is equivalent to #binary_path" do
    LIBSPOTIFY_BIN.should eq Libspotify.binary_path
  end

  specify "GEM_VERSION" do
    Libspotify::GEM_VERSION.should eq "12.1.51.2"
  end

  specify "VERSION" do
    Libspotify::VERSION.should eq "12.1.51"
  end
end
