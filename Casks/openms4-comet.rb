cask "openms4-comet" do
  arch arm: "arm64", intel: "x64"

  version "1.0.0-ci.7,6c53e752092d"
  sha256 arm:   "09462216a6952e5abef94c91fba62d978a1c7884019195b23fe43de9e6c2dfb3",
         intel: "666487c037105cf0373117414af2a4444ac86c8833a794acf431ecd864e3c81b"

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
    next if core == "83ce20da78337b0b329f5c634e52226585e4788d"

    raise Cask::CaskError, "openms4-comet #{version.csv.first} was built against openms4-core 83ce20da7833, " \
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
