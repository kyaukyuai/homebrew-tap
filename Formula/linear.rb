class Linear < Formula
  desc "Git-first Linear CLI with workspace-aware auth, issue workflows, and automation-friendly JSON output"
  homepage "https://github.com/kyaukyuai/linear-cli"
  version "2.9.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kyaukyuai/linear-cli/releases/download/v2.9.1/linear-aarch64-apple-darwin.tar.xz"
      sha256 "369e2c05f98ea161c7e9f4c9ee8ff7afd666ebccbc7483cb69bf014bd3943811"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kyaukyuai/linear-cli/releases/download/v2.9.1/linear-x86_64-apple-darwin.tar.xz"
      sha256 "fb2d7d07e469b9d3879c35e9800c7965429942558e07568fc1b29c54ed1eeff0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kyaukyuai/linear-cli/releases/download/v2.9.1/linear-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a36ca58a81217c318eb1c5fdad1a3c292c20bd53b388fbc3a392d2e4ad614cf7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kyaukyuai/linear-cli/releases/download/v2.9.1/linear-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fb1413f8474ee6b193e3eb28f0d76c4017a0899e9ecc18479d5749f47d82adab"
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
