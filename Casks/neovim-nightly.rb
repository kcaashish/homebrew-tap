cask 'neovim-nightly' do
  arch arm: 'arm64', intel: 'x86_64'

  version :latest
  sha256 :no_check

  url "https://github.com/neovim/neovim/releases/download/nightly/nvim-macos-#{arch}.tar.gz"
  name 'Neovim Nightly'
  desc 'Nightly build of the Neovim text editor'
  homepage 'https://neovim.io/'

  binary "nvim-macos-#{arch}/bin/nvim"

  postflight do
    system_command 'xattr', args: ['-c', "#{staged_path}/nvim-macos-#{arch}/bin/nvim"]
  end
end
