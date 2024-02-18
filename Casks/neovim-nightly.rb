cask 'neovim-nightly' do
    version :latest
    sha256 :no_check

    url 'https://github.com/neovim/neovim/releases/download/nightly/nvim-macos.tar.gz'
    name 'Neovim Nightly'
    homepage 'https://neovim.io/'

    binary 'nvim-macos/bin/nvim', target: 'nvim'
  end