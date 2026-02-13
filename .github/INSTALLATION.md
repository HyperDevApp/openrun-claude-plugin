# 📦 Complete Installation Guide

Detailed step-by-step installation guide for the OpenRun Claude Code plugin.

## Table of Contents

- [System Requirements](#system-requirements)
- [Installing OpenRun](#installing-openrun)
- [Installing Claude Code](#installing-claude-code)
- [Installing the Plugin](#installing-the-plugin)
- [Verification](#verification)
- [Configuration](#configuration)
- [Platform-Specific Notes](#platform-specific-notes)
- [Troubleshooting](#troubleshooting)

---

## System Requirements

### Minimum Requirements

- **OS:** macOS 10.15+, Linux (Ubuntu 20.04+, Debian 10+), or Windows WSL2
- **RAM:** 4GB available
- **Disk:** 2GB free space
- **Network:** Internet connection for installation

### Required Software

- **Git:** Version 2.20+
- **Curl:** For downloading installers
- **Docker** (optional): For containerized deployments
  - Not required if using OpenRun's built-in container engine

### For Running Examples

| Example | Requirements |
|---------|-------------|
| Python apps | Python 3.10+ |
| Node.js apps | Node.js 18+ |
| Static sites | None (works everywhere) |

---

## Installing OpenRun

### macOS / Linux

#### Method 1: Automated Installer (Recommended)

```bash
# Download and run installer
curl -fsSL https://openrun.dev/install.sh | sh
```

**What this does:**
1. Downloads OpenRun binary for your platform
2. Installs to `~/clhome/bin/openrun`
3. Creates necessary directories
4. Sets up default configuration

**Expected Output:**
```
✓ Downloading OpenRun v0.9.0 for darwin-arm64
✓ Verifying checksum
✓ Installing to /Users/username/clhome/bin/openrun
✓ Setting executable permissions
✓ Creating configuration directory
✓ OpenRun installed successfully!

Add OpenRun to your PATH by adding this to ~/.zshrc or ~/.bashrc:

    export PATH="$HOME/clhome/bin:$PATH"

Then run:
    source ~/.zshrc  # or ~/.bashrc
    openrun version
```

#### Method 2: Manual Installation

```bash
# Create installation directory
mkdir -p ~/clhome/bin

# Download OpenRun binary (replace VERSION and PLATFORM)
VERSION="0.9.0"
PLATFORM="darwin-arm64"  # or linux-amd64, darwin-amd64
curl -L "https://github.com/openrundev/openrun/releases/download/v${VERSION}/openrun-${PLATFORM}" \
  -o ~/clhome/bin/openrun

# Make executable
chmod +x ~/clhome/bin/openrun

# Add to PATH
echo 'export PATH="$HOME/clhome/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

#### Method 3: Install from Source

```bash
# Requires Go 1.21+
git clone https://github.com/openrundev/openrun.git
cd openrun
make install
```

### Windows (WSL2)

```bash
# Open WSL2 terminal
wsl

# Follow Linux installation steps
curl -fsSL https://openrun.dev/install.sh | sh

# Add to PATH
echo 'export PATH="$HOME/clhome/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Verify Installation

```bash
# Check version
openrun version

# Expected output:
# openrun version v0.9.0

# Check help
openrun --help

# Should show available commands
```

### Initialize OpenRun

```bash
# Create default configuration
openrun server init

# Expected output:
# ✓ Created configuration at ~/clhome/openrun.toml
# ✓ Initialized database
# ✓ Ready to start server

# Start the server
openrun server start

# Expected output:
# ✓ Starting OpenRun server...
# ✓ Server listening on unix://~/clhome/run/openrun.sock
# ✓ Web UI available at http://localhost:3000
# ✓ Server running (PID: 12345)
```

---

## Installing Claude Code

### macOS

#### Method 1: Official Installer

```bash
# Download from official website
open https://code.claude.com

# Or use Homebrew (if available)
brew install --cask claude-code
```

#### Method 2: Direct Download

1. Visit [code.claude.com](https://code.claude.com)
2. Download `.dmg` file for macOS
3. Open `.dmg` and drag Claude Code to Applications
4. Launch from Applications folder

### Linux

```bash
# Download appropriate package
# For Debian/Ubuntu (.deb)
wget https://code.claude.com/download/linux/deb/stable -O claude-code.deb
sudo dpkg -i claude-code.deb
sudo apt-get install -f  # Install dependencies

# For Red Hat/Fedora (.rpm)
wget https://code.claude.com/download/linux/rpm/stable -O claude-code.rpm
sudo rpm -i claude-code.rpm

# For Arch Linux (AUR)
yay -S claude-code
```

### Windows (WSL2)

```bash
# Install in WSL2 environment
wsl

# Follow Linux installation steps
wget https://code.claude.com/download/linux/deb/stable -O claude-code.deb
sudo dpkg -i claude-code.deb
```

### Verify Claude Code Installation

```bash
# Check version
claude code --version

# Expected output:
# Claude Code version 1.x.x

# Test interactive mode
claude code

# Should open interactive prompt
```

---

## Installing the Plugin

### Method 1: Install from GitHub (Recommended)

```bash
# Install directly from GitHub
claude code plugin install https://github.com/HyperDevApp/openrun-claude-plugin

# Expected output:
# ✓ Downloading plugin from GitHub...
# ✓ Validating plugin structure...
# ✓ Installing to ~/.claude/plugins/openrun-plugin
# ✓ Plugin installed successfully!
#
# Available skills:
#   - openrun-deploy
```

### Method 2: Clone and Install Manually

```bash
# Clone repository
git clone https://github.com/HyperDevApp/openrun-claude-plugin.git
cd openrun-claude-plugin

# Copy to Claude plugins directory
mkdir -p ~/.claude/plugins
cp -r . ~/.claude/plugins/openrun-plugin

# Verify structure
ls ~/.claude/plugins/openrun-plugin

# Should show:
# .claude-plugin/
# skills/
# assets/
# LICENSE
# README.md
```

### Method 3: Symlink for Development

```bash
# For plugin development
git clone https://github.com/HyperDevApp/openrun-claude-plugin.git
cd openrun-claude-plugin

# Create symlink
ln -s $(pwd) ~/.claude/plugins/openrun-plugin-dev

# Changes to source automatically reflected
```

### Verify Plugin Installation

```bash
# List installed plugins
claude code plugin list

# Expected output:
# Installed plugins:
#   ✓ openrun-plugin (v1.0.0)
#     Path: ~/.claude/plugins/openrun-plugin
#     Skills: openrun-deploy
#     Author: Hyperdev

# Check plugin details
claude code plugin info openrun-plugin

# Expected output:
# Plugin: openrun-plugin
# Version: 1.0.0
# Description: Claude Code skill for OpenRun declarative deployment
# Skills:
#   - openrun-deploy: Deploy and manage web applications using OpenRun
# Templates: 3 Starlark templates available
```

---

## Verification

### Complete System Check

```bash
# Create verification script
cat > verify-setup.sh <<'EOF'
#!/bin/bash

echo "=== OpenRun Claude Code Plugin - System Verification ==="
echo

# Check OpenRun
echo "1. Checking OpenRun..."
if command -v openrun &> /dev/null; then
    echo "   ✓ OpenRun installed: $(openrun version)"
else
    echo "   ✗ OpenRun not found"
    exit 1
fi

# Check OpenRun server
echo "2. Checking OpenRun server..."
if openrun app list &> /dev/null; then
    echo "   ✓ OpenRun server is running"
else
    echo "   ✗ OpenRun server not running"
    echo "   Start with: openrun server start"
    exit 1
fi

# Check Claude Code
echo "3. Checking Claude Code..."
if command -v claude &> /dev/null; then
    echo "   ✓ Claude Code installed: $(claude code --version 2>&1 | head -1)"
else
    echo "   ✗ Claude Code not found"
    exit 1
fi

# Check plugin
echo "4. Checking OpenRun plugin..."
if claude code plugin list 2>&1 | grep -q "openrun-plugin"; then
    echo "   ✓ OpenRun plugin installed"
else
    echo "   ✗ OpenRun plugin not found"
    exit 1
fi

echo
echo "=== All checks passed! System ready to deploy ==="
EOF

chmod +x verify-setup.sh
./verify-setup.sh
```

### Test Deployment

```bash
# Quick test with static site example
cd /tmp
git clone https://github.com/HyperDevApp/openrun-claude-plugin.git
cd openrun-claude-plugin/examples/static-site

# Deploy using OpenRun directly
openrun apply --approve deploy.star

# Verify deployment
curl http://localhost/static

# Should return HTML content

# Clean up
openrun app delete /static
```

---

## Configuration

### OpenRun Configuration

Edit `~/clhome/openrun.toml`:

```toml
# Server configuration
[server]
listen = "unix://~/clhome/run/openrun.sock"
web_ui_port = 3000

# Container runtime
[runtime]
engine = "docker"  # or "podman", "containerd"

# Default app settings
[defaults]
cpu = "1"
memory = "512m"
```

### Claude Code Configuration

Edit `~/.claude/config.json`:

```json
{
  "plugins": {
    "enabled": true,
    "autoload": ["openrun-plugin"]
  },
  "terminal": {
    "shell": "/bin/bash"
  }
}
```

### Environment Variables

Add to `~/.zshrc` or `~/.bashrc`:

```bash
# OpenRun configuration
export OPENRUN_HOME="$HOME/clhome"
export OPENRUN_CONFIG="$HOME/clhome/openrun.toml"

# Add to PATH
export PATH="$HOME/clhome/bin:$PATH"

# Optional: Set default resources
export OPENRUN_DEFAULT_CPU="1"
export OPENRUN_DEFAULT_MEMORY="512m"
```

---

## Platform-Specific Notes

### macOS (Apple Silicon)

```bash
# Use ARM64 binaries
PLATFORM="darwin-arm64"

# If using Docker Desktop
# Enable "Use Rosetta for x86/amd64 emulation" in settings
```

### macOS (Intel)

```bash
# Use AMD64 binaries
PLATFORM="darwin-amd64"
```

### Linux (Ubuntu/Debian)

```bash
# Install additional dependencies
sudo apt-get update
sudo apt-get install -y curl git

# For Docker (optional)
sudo apt-get install -y docker.io
sudo usermod -aG docker $USER
```

### Linux (Red Hat/Fedora)

```bash
# Install dependencies
sudo dnf install -y curl git

# For Docker (optional)
sudo dnf install -y docker
sudo systemctl start docker
sudo usermod -aG docker $USER
```

### Windows (WSL2)

```bash
# Ensure WSL2 is properly configured
wsl --set-default-version 2

# Inside WSL2
sudo apt-get update
sudo apt-get install -y curl git

# Docker Desktop integration
# Enable "Use the WSL 2 based engine" in Docker Desktop settings
```

---

## Troubleshooting

### OpenRun Issues

#### Server won't start

```bash
# Check if port is available
lsof -i :3000

# Check if socket exists
ls -la ~/clhome/run/openrun.sock

# View server logs
openrun server logs

# Start in foreground for debugging
openrun server start --foreground
```

#### Binary not found

```bash
# Verify PATH
echo $PATH | grep clhome

# If not in PATH, add it
export PATH="$HOME/clhome/bin:$PATH"

# Make permanent
echo 'export PATH="$HOME/clhome/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### Claude Code Issues

#### Plugin not loading

```bash
# Check plugin directory
ls ~/.claude/plugins/openrun-plugin

# Verify plugin.json exists
cat ~/.claude/plugins/openrun-plugin/.claude-plugin/plugin.json

# Check Claude Code logs
claude code --verbose
```

#### Skill not available

```bash
# Verify skill directory
ls ~/.claude/plugins/openrun-plugin/skills/openrun-deploy

# Check SKILL.md exists
cat ~/.claude/plugins/openrun-plugin/skills/openrun-deploy/SKILL.md
```

### Permission Issues

```bash
# Fix plugin permissions
chmod -R 755 ~/.claude/plugins/openrun-plugin

# Fix OpenRun permissions
chmod -R 755 ~/clhome
chmod +x ~/clhome/bin/openrun
```

### Network Issues

```bash
# Test GitHub connectivity
curl -I https://github.com

# Test OpenRun connectivity
curl -I https://openrun.dev

# Check DNS
nslookup github.com
```

---

## Uninstallation

### Remove Plugin

```bash
# Remove plugin directory
rm -rf ~/.claude/plugins/openrun-plugin

# Verify removal
claude code plugin list
```

### Remove OpenRun

```bash
# Stop server
openrun server stop

# Remove binary and data
rm -rf ~/clhome

# Remove from PATH (edit ~/.zshrc or ~/.bashrc)
# Remove line: export PATH="$HOME/clhome/bin:$PATH"
```

### Remove Claude Code

#### macOS

```bash
# Remove application
rm -rf /Applications/Claude\ Code.app

# Remove user data
rm -rf ~/.claude
```

#### Linux

```bash
# Debian/Ubuntu
sudo apt-get remove claude-code

# Red Hat/Fedora
sudo dnf remove claude-code

# Remove user data
rm -rf ~/.claude
```

---

## Next Steps

After installation:

1. **Try the Quick Start:** [QUICKSTART.md](./QUICKSTART.md)
2. **Watch the Demo:** [DEMO.md](./DEMO.md)
3. **Deploy Examples:** See `examples/` directory
4. **Read Full Docs:** [README.md](../README.md)

## Getting Help

- **Issues:** [GitHub Issues](https://github.com/HyperDevApp/openrun-claude-plugin/issues)
- **OpenRun Docs:** [openrun.dev/docs](https://openrun.dev/docs/)
- **Claude Code Docs:** [code.claude.com/docs](https://code.claude.com/docs/)

---

**Installation complete! Ready to deploy! 🚀**
