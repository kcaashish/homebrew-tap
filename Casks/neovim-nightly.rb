cask "neovim-nightly" do
  arch arm: "arm64", intel: "x86_64"

  version "0.13.0-dev-1788-g09e4491a53"
  sha256 arm:   "d1853056b98cd0228cae2ac9080165a7e324d0b3927a6132eaffc3b1ecb2fb82",
         intel: "8e3ebbe212286a1a56e7f952040c8b4d8648d0534035eae41964958644ca976a"

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
