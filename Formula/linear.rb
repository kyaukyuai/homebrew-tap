class Linear < Formula
  desc "Git-first Linear CLI with workspace-aware auth, issue workflows, and automation-friendly JSON output"
  homepage "https://github.com/kyaukyuai/linear-cli"
  version "2.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kyaukyuai/linear-cli/releases/download/v2.3.0/linear-aarch64-apple-darwin.tar.xz"
      sha256 "97be72790ab20627ec3e865b452677962ae793234957a1910673a7f9391d8371"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kyaukyuai/linear-cli/releases/download/v2.3.0/linear-x86_64-apple-darwin.tar.xz"
      sha256 "d8b2dd0d56f6f8c90c0f2fd8ee00dffb5b19b5b254780cad8bd293eb1977e25f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kyaukyuai/linear-cli/releases/download/v2.3.0/linear-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e6f598e984885d6a3b5ea254e30ca97b6aca40196c2bbaccafe2bf9444ccc52d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kyaukyuai/linear-cli/releases/download/v2.3.0/linear-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1f9ad033803806657db1c59781a2ae8500dd106329b956aa724d3118ce89260a"
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
