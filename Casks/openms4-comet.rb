cask "openms4-comet" do
  arch arm: "arm64", intel: "x64"

  version "1.0.0-ci.1,e6147e19dd5e"
  sha256 arm:   "1c6d22bb9afdf3bc28e61c9a718a2fed2ae618e20f96274169650a4c5131e6d6",
         intel: "b15b9ed7f7420117b0c0da6f23b4a70634a1ec2f61ca55180a9001ca215731e0"

  url "https://github.com/okohlbacher/OpenMS4-comet/releases/download/" \
      "comet-v#{version.csv.first}/OpenMS4-comet-macos-#{arch}-Homebrew-#{version.csv.second}.tar.gz"
  name "OpenMS 4 comet tools"
  desc "Command-line mass-spectrometry tools built against the OpenMS Core SDK"
  homepage "https://github.com/okohlbacher/OpenMS4-comet"

  depends_on formula: "okohlbacher/openms4-core/openms4-core"
  depends_on macos: :sequoia

  payload = "OpenMS4-comet-macos-#{arch}-Homebrew-#{version.csv.second}"
  binary "#{payload}/bin/CometAdapter"

  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "."],
        chdir:          ".",
        writable_paths: ["."]
  end
end
