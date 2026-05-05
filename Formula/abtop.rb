class Abtop < Formula
  desc "AI agent monitor for your terminal"
  homepage "https://github.com/graykode/abtop"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/graykode/abtop/releases/download/v0.4.1/abtop-aarch64-apple-darwin.tar.xz"
      sha256 "ad44fed6d4d3da6a7caec1dc0be76b0e58c54711af9f7acaeb07cb4d8e55047a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/graykode/abtop/releases/download/v0.4.1/abtop-x86_64-apple-darwin.tar.xz"
      sha256 "5714aec2239ceed6d08796eee9ea01abdb0646be7fa1a5e471356c7a64922151"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/graykode/abtop/releases/download/v0.4.1/abtop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8f01aa427a6ba4800df71750d0e9aa56e4731cb3c32a64f5c60e5e12a459303d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/graykode/abtop/releases/download/v0.4.1/abtop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a6d40584e682eb510bca3eb96efd49abac20ccc7eef9c1080e48115bfc7b374d"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-pc-windows-gnu":    {},
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
