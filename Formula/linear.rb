class Linear < Formula
  desc "Agent-first Linear CLI with stable JSON contracts, dry-run previews, and workflow-safe automation"
  homepage "https://github.com/kyaukyuai/linear-cli"
  version "2.13.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kyaukyuai/linear-cli/releases/download/v2.13.0/linear-aarch64-apple-darwin.tar.xz"
      sha256 "5ae569cdabf25218e167cd41e54d627ba8a34f4496535f19ee7e740d59cc17bc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kyaukyuai/linear-cli/releases/download/v2.13.0/linear-x86_64-apple-darwin.tar.xz"
      sha256 "457c272f062020a7a53bb8f0b94c18bfb6f528ca61de5aea89ac3de31ffc34be"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kyaukyuai/linear-cli/releases/download/v2.13.0/linear-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1e9456ad6a17246add30ee8e324b02f12025ef26363877c032d7f383182cf6d3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kyaukyuai/linear-cli/releases/download/v2.13.0/linear-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5d134c8c6aeaa98932a7993900a1d5c6e6fbe5147ea5b7e7d02060a3da9d0aa2"
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
