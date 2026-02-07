# Homebrew Tap for Thriven OS

## Install

```bash
# 1. Save your deploy token (get from admin)
mkdir -p ~/.config/thriven
echo 'YOUR_DEPLOY_TOKEN' > ~/.config/thriven/token

# 2. Install
brew tap thrive-intelligence/thriven
brew install thriven

# 3. Set up a project
mkdir my-project && cd my-project
thriven init
thriven doctor
claude
```

## One-liner (if you have your token)

```bash
mkdir -p ~/.config/thriven && echo 'YOUR_TOKEN' > ~/.config/thriven/token && brew tap thrive-intelligence/thriven && brew install thriven
```

## Update

```bash
brew upgrade thriven
```
