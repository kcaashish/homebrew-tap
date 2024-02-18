cask 'neovim-nightly' do
    version :latest
    sha256 :no_check

    url 'https://github.com/neovim/neovim/releases/download/nightly/nvim-macos.tar.gz'
    name 'Neovim Nightly'
    desc 'Nightly build of the Neovim text editor'
    homepage 'https://neovim.io/'

    binary 'nvim-macos/bin/nvim'
  end