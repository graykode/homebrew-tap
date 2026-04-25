class Abtop < Formula
  desc "AI agent monitor for your terminal"
  homepage "https://github.com/graykode/abtop"
  version "0.3.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/graykode/abtop/releases/download/v0.3.7/abtop-aarch64-apple-darwin.tar.xz"
      sha256 "e3287e262db68060ec6631840ae3863cc6722019df46c69fa0cf59127a9b877f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/graykode/abtop/releases/download/v0.3.7/abtop-x86_64-apple-darwin.tar.xz"
      sha256 "8402d5c86a302eb8098535e4c4e1b03929ec5b386afc897206b2128edbc815c4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/graykode/abtop/releases/download/v0.3.7/abtop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e1e94a7da986dff2df3bca31b16faa28fbc6c335963acf126bc5cce627be6eb6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/graykode/abtop/releases/download/v0.3.7/abtop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b2f0dc9ae9c991f672ea5258732ebbcd4e5715f601953209598a96affdc9117c"
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
