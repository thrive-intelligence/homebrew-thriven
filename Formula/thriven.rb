class Thriven < Formula
  desc "Cognitive Operating System for Claude — skill activation, epistemic gating, hybrid DB"
  homepage "https://github.com/thrive-intelligence/thriven"
  license "Proprietary"
  version "1.0.1"

  # No source URL — installs from private PyPI (Gemfury)
  # Homebrew needs a URL, so we use a minimal bootstrap script
  url "https://raw.githubusercontent.com/thrive-intelligence/homebrew-thriven/main/bootstrap.py"
  sha256 :no_check

  depends_on "python@3.13"
  depends_on "node"

  def install
    # Create virtualenv
    venv = libexec/"venv"
    system "python3.13", "-m", "venv", venv.to_s
    pip = venv/"bin/pip"

    # Read deploy token
    token_file = Pathname.new("#{Dir.home}/.config/thriven/token")
    if token_file.exist?
      token = token_file.read.strip
    elsif ENV["THRIVEN_TOKEN"]
      token = ENV["THRIVEN_TOKEN"]
    else
      ohai "No Thriven deploy token found."
      ohai ""
      ohai "Get your token from your Thriven admin, then:"
      ohai "  mkdir -p ~/.config/thriven"
      ohai "  echo 'YOUR_TOKEN' > ~/.config/thriven/token"
      ohai "  brew reinstall thriven"
      ohai ""
      ohai "Or install with: THRIVEN_TOKEN=xxx brew install thriven"
      odie "Deploy token required."
    end

    # Install thriven-os from Gemfury
    system pip, "install", "thriven-os",
      "--index-url", "https://#{token}@pypi.fury.io/shaneatlas/",
      "--extra-index-url", "https://pypi.org/simple/"

    # Create wrapper script that uses the venv
    (bin/"thriven").write_env_script venv/"bin/thriven",
      PATH: "#{venv}/bin:$PATH"

    # Install Claude Code CLI if not present
    unless which("claude")
      system "npm", "install", "-g", "@anthropic-ai/claude-code"
    end
  end

  def post_install
    config_dir = Pathname.new("#{Dir.home}/.config/thriven")
    config_dir.mkpath unless config_dir.exist?
  end

  def caveats
    <<~EOS
      Thriven OS installed!

      Quick start:
        mkdir my-project && cd my-project
        thriven init
        thriven doctor
        claude

      Thriven activates automatically via .mcp.json.

      To update:  brew upgrade thriven
      Need help?  thriven doctor
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/thriven --version")
  end
end
