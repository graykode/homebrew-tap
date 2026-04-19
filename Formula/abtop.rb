class Abtop < Formula
  desc "AI agent monitor for your terminal"
  homepage "https://github.com/graykode/abtop"
  version "0.2.14"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/graykode/abtop/releases/download/v0.2.14/abtop-aarch64-apple-darwin.tar.xz"
      sha256 "a431eddd94617e8f620563d17165a5553ba265b6a58f216d5b09cc6ee1b444e9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/graykode/abtop/releases/download/v0.2.14/abtop-x86_64-apple-darwin.tar.xz"
      sha256 "6ad80cd0fff744c2f703bb5d0a09c64e310c9de67891b2cef05131ff57b2eef4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/graykode/abtop/releases/download/v0.2.14/abtop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "95f00f012623356d94f2bdef44df820602a908b57ccf10efcc225ca79b81b9d4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/graykode/abtop/releases/download/v0.2.14/abtop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "abd9e13d3ca0cf35eb4e076d144851dc400aa91f6594c917b193fcd6a257c3a7"
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
