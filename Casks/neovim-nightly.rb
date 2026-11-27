cask "neovim-nightly" do
  arch arm: "arm64", intel: "x86_64"

  version "0.13.0-dev-2211-g8cf55994e9"
  sha256 arm:   "d332f5018d9602da93d7f29397fe1bd8307bfc6093ca94f80fa5d2627bd60399",
         intel: "9a931eb3148cc267d967665cb712893201b4980b92b4a2160ac99d2738d98d24"

  # Neovim deletes and recreates its `nightly` release every night, so the files
  # behind its download URLs change daily and cannot be pinned to a checksum.
  # The bump workflow copies each build into a release on this tap instead, once
  # it matches the SHA-256 GitHub reports for Neovim's own upload.
  url "https://github.com/kcaashish/homebrew-tap/releases/download/neovim-nightly-#{version}/nvim-macos-#{arch}.tar.gz"
  name "Neovim Nightly"
  desc "Nightly build of the Neovim text editor"
  homepage "https://neovim.io/"

  # Check Neovim itself, not the copies above. The `nightly` tag is reused for
  # every build, so the version lives in the release body
  # (`NVIM v0.13.0-dev-1596+g28ff47b8a4`) rather than in the tag.
  #
  # The version must not contain commas. It becomes the Caskroom directory name,
  # which is where `$VIMRUNTIME` is resolved from, and `runtimepath` is a
  # comma-separated option: a comma in the path splits VIMRUNTIME into garbage
  # fragments and Neovim can no longer find its own Lua runtime modules.
  livecheck do
    url "https://github.com/neovim/neovim"
    regex(/NVIM\s+v?(\d+(?:\.\d+)+)-dev-(\d+)\+(g\h+)/i)
    strategy :github_releases do |json, regex|
      json.filter_map do |release|
        next if release["tag_name"] != "nightly"

        match = release["body"]&.match(regex)
        next if match.blank?

        "#{match[1]}-dev-#{match[2]}-#{match[3]}"
      end
    end
  end

  binary "nvim-macos-#{arch}/bin/nvim"

  postflight_steps do
    run "/usr/bin/xattr", args: ["-c", "nvim-macos-#{arch}/bin/nvim"], chdir: "."
  end
end
