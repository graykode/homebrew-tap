class Abtop < Formula
  desc "AI agent monitor for your terminal"
  homepage "https://github.com/graykode/abtop"
  version "0.2.13"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/graykode/abtop/releases/download/v0.2.13/abtop-aarch64-apple-darwin.tar.xz"
      sha256 "6edc5a2a70e6fd6d3012f5516eb1dfed16a6ed34d7ccbe3342cb326ffeceebba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/graykode/abtop/releases/download/v0.2.13/abtop-x86_64-apple-darwin.tar.xz"
      sha256 "9c5c48d32c4460c744d1f873c3590e68315ae8cd81225d1c5816c1d12dc6b668"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/graykode/abtop/releases/download/v0.2.13/abtop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9278108503ffabdf1201c350d22229c84e9c4570fb68fd1613ec6dabf24fc57b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/graykode/abtop/releases/download/v0.2.13/abtop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "443fe8aac59ae9dbd2d05785e1c5973e7bd196794499b4eb4bc3f6dce6ae5920"
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
    bin.install "abtop" if OS.mac? && Hardware::CPU.arm?
    bin.install "abtop" if OS.mac? && Hardware::CPU.intel?
    bin.install "abtop" if OS.linux? && Hardware::CPU.arm?
    bin.install "abtop" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
