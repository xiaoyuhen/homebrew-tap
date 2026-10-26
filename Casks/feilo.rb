cask "feilo" do
  version "0.1.2"
  sha256 "290d409fc87db769e54b4b7c97d62e5322e1a10a19f33fb3ee4b16b9e14992cf"

  url "https://github.com/xiaoyuhen/feilo-releases/releases/download/v#{version}/Feilo-#{version}.zip"
  name "Feilo"
  desc "Menu bar app that polishes selected text with any LLM, in English or German"
  homepage "https://github.com/xiaoyuhen/feilo-releases"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :sonoma

  app "Feilo.app"

  # Feilo is signed with its own certificate but not notarized: without
  # this, Gatekeeper refuses to open the downloaded copy.
  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/Feilo.app"],
        writable_paths: ["Feilo.app"],
        writable_base:  :appdir
  end

  uninstall quit:       "io.github.xiaoyuhen.feilo",
            login_item: "Feilo"

  zap trash: [
    "~/Library/Application Support/Feilo",
    "~/Library/Preferences/io.github.xiaoyuhen.feilo.plist",
  ]
end
