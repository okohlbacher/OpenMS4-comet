cask "openms4-comet" do
  arch arm: "arm64", intel: "x64"

  version "1.0.0-ci.2,c3c4d1b99a15"
  sha256 arm:   "089ad52975b7b9db77df0802d315a1942934b8a4632ad99d9c85ef4e67d0efeb",
         intel: "5ef0e2e84e368311511f8171c042698167fd1273efea4bdc6b5c262aca12c874"

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
