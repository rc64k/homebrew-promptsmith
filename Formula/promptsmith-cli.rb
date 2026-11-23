class PromptsmithCli < Formula
  desc "Local-first tool to analyze, score and refine AI Prompts"
  homepage "https://github.com/rc64k/promptsmith-cli"
  license "MIT"
  version "1.0.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/rc64k/promptsmith-cli/releases/download/v#{version}/PromptSmith-cli-#{version}-macos-arm64.zip"
      sha256 "5a54cc3c58eb8251ecd7ee87c78ad5b4ee72fd5e8fd319837e4dfcf67c8645d2"
    else
      url "https://github.com/rc64k/promptsmith-cli/releases/download/v#{version}/PromptSmith-cli-#{version}-macos-x86_64.zip"
      sha256 "ab74a0a370b3bac6eceefe6b782386d197d599b3b9a07c69bfa6687fd9234bd4"
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
