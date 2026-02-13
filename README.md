# OpenRun Plugin for Claude Code

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Plugin-purple)](https://code.claude.com)
[![OpenRun](https://img.shields.io/badge/OpenRun-Compatible-green)](https://openrun.dev)

Deploy web applications using [OpenRun](https://openrun.dev)'s declarative configuration directly from Claude Code. No MCP server required—uses Claude Code's native Bash tool for simple, transparent operation.

## 🚀 Features

- **Natural Language Deployment**: Deploy apps using conversational commands
- **Declarative GitOps**: Generate and apply Starlark configurations automatically
- **Framework Detection**: Automatically identifies Python, Node.js, Go, and more
- **Template-Based**: Includes battle-tested Starlark templates
- **No MCP Required**: Uses Claude Code's built-in Bash tool for simplicity
- **Multi-Environment Support**: Deploy to dev, staging, and production with parameters
- **Production Examples**: 5 complete example applications ready to deploy

## 📚 Example Applications

This repository includes **5 production-ready example applications** you can deploy immediately:

| Example | Description | Tech Stack |
|---------|-------------|------------|
| [🎨 Streamlit Dashboard](./examples/streamlit-dashboard) | Interactive data visualization | Python, Pandas, NumPy |
| [⚡ FastAPI Service](./examples/fastapi-service) | Modern REST API with auto-docs | Python, FastAPI, Uvicorn |
| [⚛️ Next.js Web App](./examples/nextjs-webapp) | Full-stack React application | TypeScript, Next.js, Tailwind |
| [🟢 Express API](./examples/express-api) | Simple Node.js REST API | JavaScript, Express |
| [📄 Static Site](./examples/static-site) | Pure HTML/CSS/JS website | HTML5, CSS3, JavaScript |

**[View all examples →](./examples/)**

Each example includes complete source code, deployment configuration, and detailed documentation. Perfect for learning or as starting points for your projects!

## 📋 Prerequisites

Before installing this plugin, ensure you have:

1. **Claude Code**: Install from [code.claude.com](https://code.claude.com)
2. **OpenRun CLI**: Install OpenRun following the [official installation guide](https://openrun.dev/docs/installation/)
3. **OpenRun Server Running**: Start the server with `openrun server start`

### Quick OpenRun Installation

```bash
# Download and install OpenRun
curl -fsSL https://openrun.dev/install.sh | sh

# Start the OpenRun server
openrun server start
```

## 📦 Installation

### Option 1: Install from GitHub (Recommended)

```bash
claude code plugin install https://github.com/hyperdevapp/openrun-claude-plugin
```

### Option 2: Manual Installation

```bash
# Clone the repository
git clone https://github.com/hyperdevapp/openrun-claude-plugin.git

# Copy to Claude Code plugins directory
cp -r openrun-claude-plugin ~/.claude/plugins/

# Restart Claude Code
claude code restart
```

## 🎯 Usage

Once installed, Claude Code understands OpenRun deployment commands naturally. Here are some examples:

### Deploy a New Application

```
You: Deploy this directory as a Streamlit app at /dashboard
```

Claude will:
1. Analyze your project structure
2. Generate a Starlark configuration
3. Validate it with `--dry-run`
4. Deploy using `openrun apply`
5. Verify the deployment

### Deploy from Git Repository

```
You: Create an OpenRun app from github.com/myorg/api-service at /api using FastAPI
```

### List Running Applications

```
You: Show me all running OpenRun apps
```

### Update an Existing App

```
You: Reload the /dashboard app and promote it to production
```

### Create Development Environment

```
You: Deploy this directory in dev mode for local testing at /myapp-dev
```

### Multi-Environment Deployment

```
You: Deploy this app to staging with 2GB memory and debug mode enabled
```

## 📚 Example Workflows

### Basic Deployment

```
1. You: I want to deploy my Flask app
2. Claude: I'll help you deploy your Flask application. Let me check your project structure...
3. Claude: (analyzes files, generates Starlark config)
4. Claude: I've created a deployment configuration. Ready to deploy?
5. You: Yes
6. Claude: (runs openrun apply --approve deploy.star)
7. Claude: Your app is now running at /myapp
```

### Parameterized Deployment

```
You: Deploy this FastAPI app with custom port 9000 and 4 CPU cores

Claude will generate:
- Starlark config with parameters
- Apply with --param port=9000 --param cpu=4
```

### Troubleshooting

```
You: The app at /api isn't working

Claude will:
1. Check app status (openrun app list)
2. Review logs (openrun app logs /api)
3. Identify the issue
4. Suggest and apply fixes
```

## 🏗️ How It Works

This plugin adds an `openrun-deploy` skill that teaches Claude Code how to:

1. **Use OpenRun CLI**: Execute `openrun` commands via the Bash tool
2. **Generate Starlark**: Create valid OpenRun configurations
3. **Handle Errors**: Troubleshoot common deployment issues
4. **Follow Best Practices**: Use declarative workflows, validation, and verification

### Architecture

```
User Request
    ↓
Claude Code (with openrun-deploy skill)
    ↓
Bash Tool → openrun CLI commands
    ↓
OpenRun Server → Docker/Kubernetes
    ↓
Deployed Application
```

**Key Advantage**: No intermediate MCP server means:
- Simpler architecture
- Easier debugging (see raw commands)
- Fewer dependencies
- More transparent operation

## 📝 Starlark Templates

The plugin includes three production-ready templates:

### 1. Basic App (`basic_app.star`)

Simple single-app deployment:

```python
load("ace.in", "app")

app(
    path="/myapp",
    source="github.com/user/repo",
    container_opts={
        "cpus": "1",
        "memory": "512m",
        "port": "8080"
    }
)
```

### 2. Universal App (`universal_app.star`)

Parameterized configuration for multiple environments:

```python
load("ace.in", "app")
load("params.in", "param")

def main():
    port = param("port", default="8080", type="INT")
    cpu_limit = param("cpu", default="1", type="STRING")

    app(
        path="/myapp",
        source="github.com/user/repo",
        container_opts={
            "cpus": cpu_limit,
            "port": str(port)
        }
    )
```

### 3. Parameters Example (`params_example.star`)

Comprehensive parameter patterns and usage examples.

## 🔧 Supported Frameworks

OpenRun (and this plugin) supports:

**Python:**
- Streamlit
- Flask
- FastAPI
- Django

**Node.js:**
- Express
- Next.js
- React

**Other:**
- Go
- Rust
- Static sites

Claude will auto-detect your framework and suggest the appropriate configuration.

## 🛠️ Configuration

### Environment Variables

The plugin respects OpenRun's standard environment variables:

```bash
# OpenRun home directory (default: ~/.clhome)
export OPENRUN_HOME=/custom/path

# OpenRun configuration file
export OPENRUN_CONFIG=/path/to/openrun.toml
```

### Custom Templates

Add your own templates to `~/.claude/plugins/openrun-plugin/assets/starlark-templates/`:

```bash
cp my-template.star ~/.claude/plugins/openrun-plugin/assets/starlark-templates/
```

Claude will automatically discover and use custom templates.

## 🐛 Troubleshooting

### Plugin Not Working

1. Verify Claude Code recognizes the plugin:
   ```bash
   claude code plugin list
   ```

2. Check OpenRun CLI is accessible:
   ```bash
   which openrun
   openrun version
   ```

3. Ensure OpenRun server is running:
   ```bash
   openrun app list
   ```

### Common Issues

**"openrun: command not found"**
- Solution: Install OpenRun CLI and add to PATH

**"Socket connection failed"**
- Solution: Start OpenRun server: `openrun server start`

**"Starlark syntax error"**
- Solution: Claude will auto-fix syntax errors in generated configs

**"Permission denied"**
- Solution: Claude will add required permissions to the configuration

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Setup

```bash
# Clone the repository
git clone https://github.com/hyperdevapp/openrun-claude-plugin.git
cd openrun-claude-plugin

# Link to Claude Code for development
ln -s $(pwd) ~/.claude/plugins/openrun-plugin-dev

# Make changes and test
```

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

The Apache 2.0 license allows you to:
- ✅ Use the software for any purpose
- ✅ Distribute copies
- ✅ Modify the software
- ✅ Distribute modified versions
- ✅ Use it in commercial applications

## 🔗 Related Projects

- **OpenRun**: [openrundev/openrun](https://github.com/openrundev/openrun)
- **Claude Code**: [code.claude.com](https://code.claude.com)
- **Starlark Language**: [starlark-lang.org](https://starlark-lang.org)

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/hyperdevapp/openrun-claude-plugin/issues)
- **OpenRun Documentation**: [openrun.dev/docs](https://openrun.dev/docs/)
- **Claude Code Documentation**: [code.claude.com/docs](https://code.claude.com/docs/)

## 🙏 Acknowledgments

- Thanks to the [OpenRun team](https://github.com/openrundev) for creating an excellent declarative deployment platform
- Thanks to [Anthropic](https://anthropic.com) for Claude Code's extensibility system
- Inspired by the need for AI-driven infrastructure automation

## 📊 Project Status

This plugin is actively maintained and tested with:
- Claude Code v1.x+
- OpenRun v0.x+

Report issues or request features via [GitHub Issues](https://github.com/hyperdevapp/openrun-claude-plugin/issues).

---

**Made with ❤️ by [Hyperdev](https://github.com/hyperdevapp)**
