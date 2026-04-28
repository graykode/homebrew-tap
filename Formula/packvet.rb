class Packvet < Formula
  desc "Local pre-install guard that reviews package release diffs before installs"
  homepage "https://github.com/graykode/packvet"
  version "0.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/graykode/packvet/releases/download/v0.0.1/packvet-aarch64-apple-darwin.tar.xz"
      sha256 "9efa4ff6b0ca8e5cdd4428d5bf6b512a6a02be70436a6e81f1858823df228340"
    end
    if Hardware::CPU.intel?
      url "https://github.com/graykode/packvet/releases/download/v0.0.1/packvet-x86_64-apple-darwin.tar.xz"
      sha256 "9c58328c9aca5b6c92a64bfc91f9adc454e64c8402bed19b6a3c380a13f1eb5e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/graykode/packvet/releases/download/v0.0.1/packvet-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "90f5c9d89d959099231fd2b477026afb92fe6b5d787cb4a08edbf9c05a6bf717"
    end
    if Hardware::CPU.intel?
      url "https://github.com/graykode/packvet/releases/download/v0.0.1/packvet-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b9ff8df3278d5cdc352931c602cb026c72db4478e0c7cd75709b74c6d33df505"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
    bin.install "packvet" if OS.mac? && Hardware::CPU.arm?
    bin.install "packvet" if OS.mac? && Hardware::CPU.intel?
    bin.install "packvet" if OS.linux? && Hardware::CPU.arm?
    bin.install "packvet" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
