class Linear < Formula
  desc "Agent-first Linear CLI with stable JSON contracts, dry-run previews, and workflow-safe automation"
  homepage "https://github.com/kyaukyuai/linear-cli"
  version "3.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kyaukyuai/linear-cli/releases/download/v3.0.0/linear-aarch64-apple-darwin.tar.xz"
      sha256 "6beaf9b06e258618d6883be200341a3fe2bd67770283e19220bda2cb92358233"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kyaukyuai/linear-cli/releases/download/v3.0.0/linear-x86_64-apple-darwin.tar.xz"
      sha256 "8a1bbeef7ef528277d8223e9487851b7241ba0a4e84702089545335f0db8b3e9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kyaukyuai/linear-cli/releases/download/v3.0.0/linear-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e7da0fd61505e50b0aae4be7bb6c8676b2de66f58ccda1a1433a9266ccb93152"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kyaukyuai/linear-cli/releases/download/v3.0.0/linear-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c47490916c61ff62dbef38e5e2749b5f1191b54c26e2bc8079450e12f9f88479"
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
