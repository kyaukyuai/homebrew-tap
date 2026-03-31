class Linear < Formula
  desc "Agent-first Linear CLI with stable JSON contracts, dry-run previews, and workflow-safe automation"
  homepage "https://github.com/kyaukyuai/linear-cli"
  version "2.12.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kyaukyuai/linear-cli/releases/download/v2.12.2/linear-aarch64-apple-darwin.tar.xz"
      sha256 "76083090b7d4a55c79323a6655d1ce2d49fa36fea7af25f10901c77340f7cc34"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kyaukyuai/linear-cli/releases/download/v2.12.2/linear-x86_64-apple-darwin.tar.xz"
      sha256 "b04af2d6cd03cc0703cbc369cf8429e1fd799d59d65bd40571fb7715e16d8d77"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kyaukyuai/linear-cli/releases/download/v2.12.2/linear-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "57918f4522bb4f84775a866bdfe79a58a74259e220e66f0aa8bcda48dc173c43"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kyaukyuai/linear-cli/releases/download/v2.12.2/linear-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c500eb42ebc6f6a73c2470e2455d86fd70a62e4fc089919e3276446c2cc38950"
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
