class Linear < Formula
  desc "Agent-first Linear CLI with stable JSON contracts, dry-run previews, and workflow-safe automation"
  homepage "https://github.com/kyaukyuai/linear-cli"
  version "3.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kyaukyuai/linear-cli/releases/download/v3.1.0/linear-aarch64-apple-darwin.tar.xz"
      sha256 "3a36db07612b614606db4358ee1e0daddb9b2a54febf69b54c154f4006dc158b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kyaukyuai/linear-cli/releases/download/v3.1.0/linear-x86_64-apple-darwin.tar.xz"
      sha256 "9e2d4464fedb83a086b9f88a91a1675cc7e96c653e574ebaa938c4572b417614"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kyaukyuai/linear-cli/releases/download/v3.1.0/linear-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6d435547188929922c54e7ed02c4dab30f409b6b2000d6fd4bfebb8cb323e797"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kyaukyuai/linear-cli/releases/download/v3.1.0/linear-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e8b80cbeb638ea0b8cbb6bf210d4b530cb73430a6657684873c6900c41ee6550"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "linear" if OS.mac? && Hardware::CPU.arm?
    bin.install "linear" if OS.mac? && Hardware::CPU.intel?
    bin.install "linear" if OS.linux? && Hardware::CPU.arm?
    bin.install "linear" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
