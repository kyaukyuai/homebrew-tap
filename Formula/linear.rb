class Linear < Formula
  desc "Git-first Linear CLI with workspace-aware auth, issue workflows, and automation-friendly JSON output"
  homepage "https://github.com/kyaukyuai/linear-cli"
  version "2.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kyaukyuai/linear-cli/releases/download/v2.9.0/linear-aarch64-apple-darwin.tar.xz"
      sha256 "7b2be9e0a52d22ae447709ab2c07eaa4e1ca934e172346a049d08f1563282fae"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kyaukyuai/linear-cli/releases/download/v2.9.0/linear-x86_64-apple-darwin.tar.xz"
      sha256 "bea619dd71e451dd38784e5f92490879bc0bf51c43ce892b0620f9e49c4b9c79"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kyaukyuai/linear-cli/releases/download/v2.9.0/linear-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "db1107cf7c75240e0d657678afcb5be5df8296447a940fabade79d60dbac16b9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kyaukyuai/linear-cli/releases/download/v2.9.0/linear-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "90d0a4d39997fce161c94c70232403205579085a6a3cf9dff9f900dd57ce8a7a"
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
