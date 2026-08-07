class PromptsmithCli < Formula
  desc "Local-first AI prompt refining tool: score, analyze, and refine prompts before they cost tokens"
  homepage "https://github.com/pr0z4k/promptsmith-cli"
  version "1.0.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/pr0z4k/promptsmith-cli/releases/download/v#{version}/PromptSmith-cli-#{version}-macos-arm64.zip"
      sha256 "47c693971a11737c32d52d06b328cdde0367e5f87478a7b013954f7f9ccb4d92"
    else
      url "https://github.com/pr0z4k/promptsmith-cli/releases/download/v#{version}/PromptSmith-cli-#{version}-macos-x86_64.zip"
      sha256 "e6845f1aa0308a0bb9b2e0c71f77120f873ef11ca0de5f3e3075ba9d71b32849"
    end
  end

  def install
    # The zip's top level is PromptSmith-cli-<version>-<platform>-<arch>/,
    # containing the PromptSmith-cli executable alongside _internal/ (the
    # frozen Python runtime + locally-compiled llama-cpp-python/ggml native
    # libraries) and editable config.yaml/templates/profiles/models
    # directories that the executable expects to find as siblings at
    # runtime. Install the whole tree into libexec and symlink just the
    # executable into bin - copying the executable alone would break at
    # first run looking for _internal/.
    libexec.install Dir["*"]
    bin.install_symlink libexec/"PromptSmith-cli" => "promptsmith"
  end

  def caveats
    <<~EOS
      This build is not yet code-signed or notarized. On first run macOS
      Gatekeeper will likely block it. If so, run once:
        xattr -dr com.apple.quarantine #{opt_libexec}
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/promptsmith --version")
  end
end
