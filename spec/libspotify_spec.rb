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
      release_name.should eq "x86-linux"
    end

    specify "linux-gnu:x86_64" do
      release_name.should eq "x86_64-linux"
    end

    context "soft float" do
      before { Libspotify.stub(hard_float?: false) }

      specify "linux-gnueabi:armv5l" do
        Libspotify.stub(arm_version: 5)
        release_name.should eq "armv5-linux"
      end

      specify "linux-gnueabi:armv6l" do
        Libspotify.stub(arm_version: 6)
        release_name.should eq "armv6-linux"
      end

      specify "linux-gnueabi:armv7l" do
        Libspotify.stub(arm_version: 7)
        release_name.should eq "armv6-linux"
      end
    end

    context "hard float" do
      before { Libspotify.stub(hard_float?: true) }

      specify "linux-gnueabi:armv5l" do
        Libspotify.stub(arm_version: 5)
        release_name.should eq "armv5hf-linux"
      end

      specify "linux-gnueabi:armv6l" do
        Libspotify.stub(arm_version: 6)
        release_name.should eq "armv6hf-linux"
      end

      specify "linux-gnueabi:armv7l" do
        Libspotify.stub(arm_version: 7)
        release_name.should eq "armv6hf-linux"
      end
    end

    specify "linux:weird-cpu" do
      release_name.should eq "weird-cpu-linux"
    end

    specify "weird-os:weird-cpu" do
      release_name.should eq "weird-cpu-weird-os"
    end
  end

  specify "LIBSPOTIFY_BIN is equivalent to #binary_path" do
    LIBSPOTIFY_BIN.should eq Libspotify.binary_path
  end

  specify "GEM_VERSION" do
    Libspotify::GEM_VERSION.should match(/\A#{Regexp.quote(Libspotify::VERSION)}/)
  end

  specify "VERSION" do
    Libspotify::VERSION.should eq "12.1.51"
  end
end
