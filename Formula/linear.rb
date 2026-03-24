class Linear < Formula
  desc "Git-first Linear CLI with workspace-aware auth, issue workflows, and automation-friendly JSON output"
  homepage "https://github.com/kyaukyuai/linear-cli"
  version "2.8.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kyaukyuai/linear-cli/releases/download/v2.8.1/linear-aarch64-apple-darwin.tar.xz"
      sha256 "4c0bec40f3eee5e562b849acc6620ba0133843931e3eb5b23cb28c9185dbbd61"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kyaukyuai/linear-cli/releases/download/v2.8.1/linear-x86_64-apple-darwin.tar.xz"
      sha256 "acc5ad3e77797cd17fb5b1b9a4208bdf9dc680e1f44db40c6958d4f8a310eb3d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kyaukyuai/linear-cli/releases/download/v2.8.1/linear-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5745ab312081ec789b93b17cb87c1d5de0be67093ba52702a05a5d9b91c307bb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kyaukyuai/linear-cli/releases/download/v2.8.1/linear-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "696cec70c117a424f29050c3d63a26bee9e63bdcf4651c91f1a3a2f73f304c87"
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
