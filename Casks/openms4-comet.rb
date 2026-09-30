cask "openms4-comet" do
  arch arm: "arm64", intel: "x64"

  version "1.0.0-ci.8,5c5ccb049966"
  sha256 arm:   "bf4aae130a9f5b6002b4c9c16c5a85274ccd4e27596d7e5edd3c50a241caccc7",
         intel: "accad7d38ea4a77e9e45dbd2a03ebe16ef8bd99a2a2a1653959d5ef0364c13cd"

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
    next if core == "0529ec8bfe0785d546dab56f58456525ef0fef02"

    raise Cask::CaskError, "openms4-comet #{version.csv.first} was built against openms4-core 0529ec8bfe07, " \
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
