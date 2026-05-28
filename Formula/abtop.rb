class Abtop < Formula
  desc "AI agent monitor for your terminal"
  homepage "https://github.com/graykode/abtop"
  version "0.4.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/graykode/abtop/releases/download/v0.4.6/abtop-aarch64-apple-darwin.tar.xz"
      sha256 "48ad9f7f1b5d3895f95c7184deb034792b364b6d70c41b51521cdcc8dcbcbd8c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/graykode/abtop/releases/download/v0.4.6/abtop-x86_64-apple-darwin.tar.xz"
      sha256 "7b07e96d69b770ff8919b57c3ef2bd1c1bd5314bd6a951b2364a9eb3c54a0921"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/graykode/abtop/releases/download/v0.4.6/abtop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bb18be0a10291a28a45c3cbc80afc39006a07741867c6627c1e1b767555f73f9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/graykode/abtop/releases/download/v0.4.6/abtop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4261405fb1ddea119dc66f88760551ca81f7e225bb1a709957fc6d363428bfbb"
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
