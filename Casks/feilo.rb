cask "feilo" do
  version "0.1.3"
  sha256 "7925d6c92763bb6c12f5adbb79f9e58c1c7fea8eb9e9c11775122491fd8b013b"

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
