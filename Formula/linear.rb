class Linear < Formula
  desc "Agent-first Linear CLI with stable JSON contracts, dry-run previews, and workflow-safe automation"
  homepage "https://github.com/kyaukyuai/linear-cli"
  version "2.12.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kyaukyuai/linear-cli/releases/download/v2.12.3/linear-aarch64-apple-darwin.tar.xz"
      sha256 "1c3baaac21e506c3e9f34954e896f371999f20e571049c7ae65092d4e5bb1217"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kyaukyuai/linear-cli/releases/download/v2.12.3/linear-x86_64-apple-darwin.tar.xz"
      sha256 "41625bb858bd5a3ad9229de8788e3d20a7d9826319cbd2c1da045503e73dfab1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kyaukyuai/linear-cli/releases/download/v2.12.3/linear-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "812c7912646a724e2d61f83d04379b5fd8a55e136c753002a8e2a65a9724ff8a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kyaukyuai/linear-cli/releases/download/v2.12.3/linear-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "341ea14e4fff423dcfe885caf20a6ef7837497710326efc4abb52d4f0ad5416d"
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
