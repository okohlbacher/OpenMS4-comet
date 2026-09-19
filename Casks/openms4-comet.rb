cask "openms4-comet" do
  arch arm: "arm64", intel: "x64"

  version "1.0.0-ci.6,82fd4b262ba0"
  sha256 arm:   "682a58656d7b9935b2199717f2c7f0b93f44a1445330c2442dea8d90598665d3",
         intel: "9ff98c49afc812e187d3f944b759fd7b7855649204a3e461990b808ddae6ce66"

  url "https://github.com/okohlbacher/OpenMS4-comet/releases/download/" \
      "comet-v#{version.csv.first}/OpenMS4-comet-macos-#{arch}-Homebrew-#{version.csv.second}.tar.gz"
  name "OpenMS 4 comet tools"
  desc "Command-line mass-spectrometry tools built against the OpenMS Core SDK"
  homepage "https://github.com/okohlbacher/OpenMS4-comet"

  depends_on formula: "okohlbacher/openms4-core/openms4-core"
  depends_on macos: :sequoia

  payload = "OpenMS4-comet-macos-#{arch}-Homebrew-#{version.csv.second}"
  binary "#{payload}/bin/CometAdapter"

  # libOpenMS has no versioned name, so a payload only runs with the Core it was built against.
  preflight do
    config = "#{HOMEBREW_PREFIX}/opt/openms4-core/lib/cmake/OpenMS/OpenMSConfig.cmake"
    core = File.exist?(config) ? File.read(config)[/set\(OpenMS_SOURCE_REVISION "([0-9a-f]{40})"\)/, 1] : nil
    next if core == "7d90cec8718d28518527acc10b495550f106de26"

    raise Cask::CaskError, "openms4-comet #{version.csv.first} was built against openms4-core 7d90cec8718d, " \
                           "but the installed openms4-core is #{core&.slice(0, 12) || "unknown"}. " \
                           "Install the openms4-comet release built for the installed Core."
  end

  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "."],
        chdir:          ".",
        writable_paths: ["."]
  end
end
