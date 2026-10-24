cask "portscope" do
  version "0.2.2"
  sha256 "884938b3865eae1ab5d0235b7a50e51956d4ef21b6a087a99b5056050fc21c8c"

  url "https://github.com/xiaoyuhen/portscope/releases/download/v#{version}/PortScope-#{version}.zip"
  name "PortScope"
  desc "Menu bar app that shows what is listening on your ports"
  homepage "https://github.com/xiaoyuhen/portscope"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :sonoma

  app "PortScope.app"

  # PortScope is ad-hoc signed, not notarized: without this, Gatekeeper
  # refuses to open the downloaded copy.
  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/PortScope.app"],
        writable_paths: ["PortScope.app"],
        writable_base:  :appdir
  end

  uninstall quit: [
    "com.portscope.app",
    "io.github.xiaoyuhen.portscope",
  ]

  zap trash: [
    "~/Library/Logs/PortScope",
    "~/Library/Preferences/com.portscope.app.plist",
    "~/Library/Preferences/io.github.xiaoyuhen.portscope.plist",
  ]
end
