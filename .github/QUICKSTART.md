# ⚡ Quick Start Guide

Get up and running with the OpenRun Claude Code plugin in under 5 minutes.

## 🚀 Installation (2 minutes)

### 1. Install OpenRun

```bash
curl -fsSL https://openrun.dev/install.sh | sh
export PATH="$HOME/clhome/bin:$PATH"
openrun server start
```

### 2. Install Plugin

```bash
claude code plugin install https://github.com/HyperDevApp/openrun-claude-plugin
```

## 🎯 First Deployment (3 minutes)

### Try an Example

```bash
# Clone the repository
git clone https://github.com/HyperDevApp/openrun-claude-plugin.git
cd openrun-claude-plugin/examples/streamlit-dashboard

# Start Claude Code
claude code

# Ask Claude to deploy
```

**In Claude Code terminal:**
```
You: Deploy this Streamlit app at /dashboard

Claude: [Analyzes project, generates config, deploys]

✓ Deployed at http://localhost/dashboard
```

### Deploy Your Own App

```bash
# Navigate to your project
cd ~/my-python-app

# Start Claude Code
claude code
```

**In Claude Code terminal:**
```
You: Deploy this app at /myapp

Claude: [Auto-detects framework, deploys]

✓ Your app is live!
```

## 📝 Common Commands

| Task | Command |
|------|---------|
| **List apps** | `openrun app list` |
| **View logs** | `openrun app logs /myapp` |
| **Reload app** | `openrun app reload /myapp` |
| **Delete app** | `openrun app delete /myapp` |

## 🎓 What to Try Next

1. **Deploy all 5 examples:**
   - Streamlit Dashboard → `/dashboard`
   - FastAPI Service → `/api`
   - Next.js Web App → `/webapp`
   - Express API → `/express-api`
   - Static Site → `/static`

2. **Use natural language:**
   ```
   "Deploy this with 2GB memory and 4 CPU cores"
   "Reload the API and promote to production"
   "Show me the logs for the dashboard"
   ```

3. **Read the full demo:**
   - [DEMO.md](./DEMO.md) - Complete walkthrough
   - [INSTALLATION.md](./INSTALLATION.md) - Detailed setup

## ❓ Quick Troubleshooting

**Server not running?**
```bash
openrun server start
```

**Plugin not found?**
```bash
claude code plugin list
```

**App won't deploy?**
```bash
openrun app list  # Check for conflicts
openrun app logs /myapp  # Check logs
```

## 🔗 Resources

- **Examples:** `/examples` directory
- **Full Demo:** [DEMO.md](./DEMO.md)
- **OpenRun Docs:** [openrun.dev/docs](https://openrun.dev/docs/)
- **Get Help:** [GitHub Issues](https://github.com/HyperDevApp/openrun-claude-plugin/issues)

---

**That's it! You're ready to deploy apps with natural language! 🎉**
