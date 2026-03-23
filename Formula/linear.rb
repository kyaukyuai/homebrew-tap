class Linear < Formula
  desc "Git-first Linear CLI with workspace-aware auth, issue workflows, and automation-friendly JSON output"
  homepage "https://github.com/kyaukyuai/linear-cli"
  version "2.7.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kyaukyuai/linear-cli/releases/download/v2.7.1/linear-aarch64-apple-darwin.tar.xz"
      sha256 "807640ce5e7b7a3e913f3a65bebd28e33760e4dfd270a08055b4dd30fb074478"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kyaukyuai/linear-cli/releases/download/v2.7.1/linear-x86_64-apple-darwin.tar.xz"
      sha256 "7e99a9bfe5becd573269c0a885b13d0f15b1bdacd35c40ccaa72852b83d29727"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kyaukyuai/linear-cli/releases/download/v2.7.1/linear-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a0de856bcbd819cb7c01c8add34cb055a4fac758458e6adc85efc70c11d4430c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kyaukyuai/linear-cli/releases/download/v2.7.1/linear-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0d22e0b2118485065c2394a93d3deadacd47fa777c07be8b13451a7bbcba1845"
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
