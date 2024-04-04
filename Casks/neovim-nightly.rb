cask 'neovim-nightly' do
  arch arm: 'arm64', intel: 'x86_64'

  version '0.10.0,2671,gdc110cba3'
  sha256 arm: '1c54b349ac01d36848e2d7685473da72dbf974942620dbfdcc8015757e24aaae',
         intel: '1c54b349ac01d36848e2d7685473da72dbf974942620dbfdcc8015757e24aa2e'

  url "https://github.com/neovim/neovim/releases/download/nightly/nvim-macos-#{arch}.tar.gz"
  name 'Neovim Nightly'
  desc 'Nightly build of the Neovim text editor'
  homepage 'https://github.com/neovim/neovim'

  livecheck do
    url 'https://github.com/neovim/neovim/releases/tag/nightly'
    regex(/(?:<code>[^<>]*?v)(\d+(?:\.\d+)+)[._-]dev[._-](\d+)[+-_](\w+)(?!:[^<>]*?Build)/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| "#{match.first},#{match.second},#{match.third}" }
    end
  end

  binary 'nvim-macos/bin/nvim'

  postflight do
    system_command 'xattr', args: ['-c', "#{staged_path}/nvim-macos-#{arch}/bin/nvim"]
  end
end
