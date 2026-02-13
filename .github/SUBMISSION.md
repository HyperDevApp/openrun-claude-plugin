# 📤 Plugin Marketplace Submission

This document contains all information needed to submit the OpenRun plugin to Claude Code marketplaces.

## 🎯 Official Anthropic Marketplace Submission

### Submission Form

**Submit Here:** https://clau.de/plugin-directory-submission

### Submission Details

**Plugin Information:**
- **Plugin Name:** `openrun-plugin`
- **Display Name:** OpenRun Plugin for Claude Code
- **Repository URL:** https://github.com/HyperDevApp/openrun-claude-plugin
- **Version:** 1.0.0
- **License:** Apache-2.0
- **Category:** Deployment & DevOps

**Short Description (50 chars):**
```
Deploy apps with OpenRun using natural language
```

**Full Description (200 chars):**
```
Deploy web applications using OpenRun's declarative configuration directly from Claude Code. No MCP server required—uses Claude Code's native Bash tool for simple, transparent deployment.
```

**Long Description:**
```
OpenRun Plugin for Claude Code enables natural language deployment of web applications to OpenRun servers.

Key Features:
• Natural language deployment commands
• Automatic framework detection (Python, Node.js, Go, Rust, Static)
• Declarative GitOps configuration generation
• 5 production-ready example applications
• No MCP server dependency - uses native Bash integration
• Multi-environment support (dev, staging, production)
• Comprehensive documentation with terminal demos

Perfect for deploying internal tools, dashboards, APIs, and web apps with conversational commands like "Deploy this Streamlit app at /dashboard" or "Reload the API and promote to production".

Includes complete examples:
- Streamlit Dashboard (data visualization)
- FastAPI Service (REST API)
- Next.js Web App (full-stack React)
- Express API (Node.js backend)
- Static Site (HTML/CSS/JS)

Repository includes 1,700+ lines of documentation, installation guides for all platforms, and automated CI/CD validation.
```

**Keywords/Tags:**
```
deployment, openrun, gitops, starlark, devops, paas, containerization, infrastructure, python, nodejs, react, streamlit, fastapi, nextjs, express
```

**Author Information:**
- **Name:** Hyperdev
- **Email:** opensource@hyperdev.app
- **Website:** https://github.com/hyperdevapp

**Support & Documentation:**
- **Homepage:** https://github.com/HyperDevApp/openrun-claude-plugin
- **Documentation:** https://github.com/HyperDevApp/openrun-claude-plugin#readme
- **Quick Start:** https://github.com/HyperDevApp/openrun-claude-plugin/blob/main/.github/QUICKSTART.md
- **Complete Demo:** https://github.com/HyperDevApp/openrun-claude-plugin/blob/main/.github/DEMO.md
- **Installation Guide:** https://github.com/HyperDevApp/openrun-claude-plugin/blob/main/.github/INSTALLATION.md
- **Issues:** https://github.com/HyperDevApp/openrun-claude-plugin/issues

**System Requirements:**
- OpenRun CLI installed (https://openrun.dev)
- OpenRun server running
- No MCP server needed
- Works on macOS, Linux, Windows (WSL2)

**Installation Command:**
```bash
claude code plugin install https://github.com/HyperDevApp/openrun-claude-plugin
```

**Plugin Structure:**
```
openrun-plugin/
├── .claude-plugin/
│   └── plugin.json
├── skills/
│   └── openrun-deploy/
│       └── SKILL.md (600+ lines)
├── assets/
│   └── starlark-templates/ (3 templates)
├── examples/ (5 complete apps)
├── .github/
│   ├── DEMO.md
│   ├── QUICKSTART.md
│   ├── INSTALLATION.md
│   └── workflows/validate-plugin.yml
└── README.md
```

**Quality & Security:**
✅ No external dependencies beyond OpenRun CLI
✅ No MCP server required - uses native tools
✅ Apache 2.0 license (commercial-friendly)
✅ Comprehensive documentation (4,500+ lines)
✅ Production-ready examples
✅ GitHub Actions validation
✅ Open source and auditable

**Unique Selling Points:**
1. **No MCP Dependency:** First OpenRun plugin without MCP server
2. **Natural Language:** Deploy with conversational commands
3. **Framework Detection:** Auto-detects Python, Node, Go, Rust
4. **Complete Examples:** 5 production-ready applications included
5. **Comprehensive Docs:** 1,700+ lines of guides and demos
6. **Platform Support:** Works on all major platforms

---

## 🌐 Community Marketplaces

### Claude Code Commands Directory

**Submit Here:** https://claudecodecommands.directory/submit

**Submission Data:**
- Plugin URL: https://github.com/HyperDevApp/openrun-claude-plugin
- Category: Deployment Tools
- Description: Deploy apps with OpenRun using natural language
- Skills: openrun-deploy

### Claude Marketplaces

**Submit Here:** https://claudemarketplaces.com/

**Plugin Details:**
- Name: openrun-plugin
- Repository: HyperDevApp/openrun-claude-plugin
- Category: DevOps & Deployment
- Features: Natural language deployment, framework detection, GitOps
- Examples: 5 production-ready apps

---

## 📦 Self-Hosted Marketplace

We can also create our own marketplace for direct distribution.

### Create marketplace.json

Create `.claude-plugin/marketplace.json`:

```json
{
  "name": "openrun-plugins",
  "owner": {
    "name": "Hyperdev",
    "email": "opensource@hyperdev.app"
  },
  "metadata": {
    "description": "Official OpenRun plugins for Claude Code",
    "version": "1.0.0"
  },
  "plugins": [
    {
      "name": "openrun-plugin",
      "source": {
        "source": "github",
        "repo": "HyperDevApp/openrun-claude-plugin"
      },
      "description": "Deploy web applications using OpenRun's declarative configuration",
      "version": "1.0.0",
      "author": {
        "name": "Hyperdev",
        "email": "opensource@hyperdev.app"
      },
      "homepage": "https://github.com/HyperDevApp/openrun-claude-plugin",
      "repository": "https://github.com/HyperDevApp/openrun-claude-plugin",
      "license": "Apache-2.0",
      "keywords": [
        "deployment",
        "openrun",
        "gitops",
        "starlark",
        "devops"
      ],
      "category": "deployment"
    }
  ]
}
```

**Installation command for users:**
```bash
/plugin marketplace add HyperDevApp/openrun-claude-plugin
/plugin install openrun-plugin@openrun-plugins
```

---

## ✅ Pre-Submission Checklist

Before submitting, verify:

- [x] Plugin manifest (plugin.json) is valid
- [x] Skill definition (SKILL.md) is comprehensive
- [x] README is complete with usage examples
- [x] LICENSE file is present (Apache-2.0)
- [x] Examples are working and documented
- [x] GitHub repository is public
- [x] Repository has clear description
- [x] All links in documentation work
- [x] GitHub Actions validation passes
- [x] .gitignore excludes unnecessary files

**Validation Command:**
```bash
claude plugin validate .
```

---

## 📊 Submission Status Tracking

| Marketplace | Status | Submission Date | Approval Date | Notes |
|-------------|--------|----------------|---------------|-------|
| Official Anthropic | Pending | TBD | - | https://clau.de/plugin-directory-submission |
| Claude Code Commands | Pending | TBD | - | https://claudecodecommands.directory/submit |
| Claude Marketplaces | Pending | TBD | - | https://claudemarketplaces.com/ |
| Self-Hosted | Ready | N/A | N/A | Can deploy anytime |

---

## 🚀 Post-Submission

After approval:

1. **Announce on social media**
   - Twitter/X
   - LinkedIn
   - Dev.to
   - Hacker News

2. **Update README with installation badge**
   ```markdown
   [![Install](https://img.shields.io/badge/Install-Claude%20Code-purple)](https://code.claude.com/plugins/openrun-plugin)
   ```

3. **Create announcement blog post**
   - Features and benefits
   - Installation guide
   - Example workflows
   - Link to documentation

4. **Monitor feedback**
   - GitHub Issues
   - Community discussions
   - User feedback

---

## 📞 Support Contacts

**For submission questions:**
- Anthropic Support: via submission form
- Community: GitHub Issues
- Email: opensource@hyperdev.app

**For plugin issues:**
- GitHub Issues: https://github.com/HyperDevApp/openrun-claude-plugin/issues
- Documentation: https://github.com/HyperDevApp/openrun-claude-plugin
