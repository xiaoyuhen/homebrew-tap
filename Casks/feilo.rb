cask "feilo" do
  version "0.1.0"
  sha256 "4a72683c12003cad59cbe813e4a5331d86f408e79355972a3138a63737eb38c5"

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
