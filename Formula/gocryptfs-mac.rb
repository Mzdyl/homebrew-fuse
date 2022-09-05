require_relative "../require/macfuse"

class GocryptfsMac < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https://nuetzlich.net/gocryptfs/"
  url "https://github.com/rfjakob/gocryptfs/releases/download/v2.3/gocryptfs_v2.3_src-deps.tar.gz"
  sha256 "945e3287311547f9227f4a5b5d051fd6df8b8b41ce2a65f424de9829cc785129"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/gocryptfs-mac-2.3"
    sha256 cellar: :any, mojave: "b8304e57a71f41583174b0abec99942d2621ebdbcc0784b879ce746a100bd1cb"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on MacfuseRequirement
  depends_on :macos
  depends_on "openssl@1.1"

  def install
    setup_fuse
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/rfjakob/gocryptfs").install buildpath.children
    cd "src/github.com/rfjakob/gocryptfs" do
      system "./build.bash"
      bin.install "gocryptfs"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"encdir").mkpath
    pipe_output("#{bin}/gocryptfs -init #{testpath}/encdir", "password", 0)
    assert_predicate testpath/"encdir/gocryptfs.conf", :exist?
  end
end
