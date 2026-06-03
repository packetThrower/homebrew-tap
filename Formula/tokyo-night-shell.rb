class TokyoNightShell < Formula
  desc "Coordinated Tokyo Night theme for WezTerm, Starship, and Zellij"
  homepage "https://github.com/packetThrower/tokyo-night-shell"
  license "MIT"
  head "https://github.com/packetThrower/tokyo-night-shell.git", branch: "main"

  depends_on "starship"

  def install
    bin.install "bin/tokyo-night-shell"
    pkgshare.install "wezterm", "starship", "shell", "zellij"
  end

  def caveats
    <<~EOS
      Tokyo Night Shell installs CLI + source configs, but doesn't touch your
      home directory by itself. To activate the theme in $HOME and wire ~/.zshrc:

          tokyo-night-shell init

      That step will also install WezTerm and the JetBrainsMono Nerd Font via
      Homebrew if they're not already present (they're cask installs, not
      formula deps, so brew doesn't pull them automatically).

      To swap the focus accent later:

          tokyo-night-shell swap orange
          tokyo-night-shell swap blue       # back to default

      To remove the theme from $HOME (leaves WezTerm/Starship/font installed):

          tokyo-night-shell uninstall
    EOS
  end

  test do
    assert_match(/^\d+\.\d+\.\d+/, shell_output("#{bin}/tokyo-night-shell --version"))
    assert_match "tokyo-night-shell", shell_output("#{bin}/tokyo-night-shell --help")
  end
end
