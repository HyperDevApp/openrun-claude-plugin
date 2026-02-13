# OpenRun Plugin Examples

This directory contains production-ready example applications demonstrating OpenRun deployment with the Claude Code plugin.

## 📚 Available Examples

### 1. [Streamlit Dashboard](./streamlit-dashboard) 📊
**Language:** Python | **Use Case:** Data Visualization

Interactive analytics dashboard with real-time metrics and charts. Perfect for:
- Business intelligence dashboards
- Data exploration tools
- Admin panels
- ML model interfaces

**Deploy:** `claude code` → "Deploy this Streamlit app at /dashboard"

---

### 2. [FastAPI Service](./fastapi-service) 🚀
**Language:** Python | **Use Case:** REST API

Modern REST API with automatic documentation and async support. Perfect for:
- Microservices architecture
- API backends
- Data services
- Integration endpoints

**Deploy:** `claude code` → "Deploy this FastAPI app at /api"

**Features:**
- Interactive Swagger UI at `/api/docs`
- Automatic data validation
- Async/await support
- CORS enabled

---

### 3. [Next.js Web App](./nextjs-webapp) ⚛️
**Language:** TypeScript/React | **Use Case:** Full-Stack Web App

Full-featured Next.js application with TypeScript and Tailwind CSS. Perfect for:
- Marketing websites
- Web applications
- Admin interfaces
- Customer portals

**Deploy:** `claude code` → "Deploy this Next.js app at /webapp"

**Features:**
- Server-side rendering
- App Router (Next.js 14)
- Tailwind CSS styling
- TypeScript type safety
- Responsive design

---

### 4. [Express API](./express-api) 🟢
**Language:** JavaScript/Node.js | **Use Case:** Simple REST API

Lightweight REST API with Express.js. Perfect for:
- Quick prototypes
- Simple backends
- Webhook handlers
- Proxy services

**Deploy:** `claude code` → "Deploy this Express API at /express-api"

**Features:**
- Minimal dependencies
- Easy to understand
- Low resource usage
- Fast startup

---

### 5. [Static Site](./static-site) 📄
**Language:** HTML/CSS/JS | **Use Case:** Static Content

Pure HTML/CSS/JS static website. Perfect for:
- Documentation sites
- Landing pages
- Portfolio sites
- Status pages

**Deploy:** `claude code` → "Deploy this static site at /static"

**Features:**
- Zero runtime dependencies
- Lightning fast
- Minimal resources (128MB RAM!)
- Easy to customize

---

## 🚀 Quick Start

### Prerequisites

1. **Install OpenRun:**
   ```bash
   curl -fsSL https://openrun.dev/install.sh | sh
   openrun server start
   ```

2. **Install Claude Code Plugin:**
   ```bash
   claude code plugin install https://github.com/HyperDevApp/openrun-claude-plugin
   ```

### Deploy Any Example

1. **Navigate to example:**
   ```bash
   cd examples/streamlit-dashboard  # or any other example
   ```

2. **Deploy with Claude Code:**
   ```bash
   claude code
   ```

3. **Ask Claude to deploy:**
   ```
   You: Deploy this application at /dashboard
   Claude: I'll analyze your project and deploy it...
   ```

4. **Access your app:**
   ```
   http://localhost/dashboard
   ```

### Manual Deployment

Each example includes a `deploy.star` file for manual deployment:

```bash
cd examples/streamlit-dashboard
openrun apply --approve deploy.star
```

## 📊 Resource Comparison

| Example | CPU | Memory | Startup Time | Complexity |
|---------|-----|--------|--------------|------------|
| Static Site | 0.25 | 128MB | < 1s | ⭐ |
| Express API | 0.5 | 256MB | < 2s | ⭐⭐ |
| Streamlit | 1 | 512MB | ~5s | ⭐⭐⭐ |
| FastAPI | 1 | 512MB | ~3s | ⭐⭐⭐ |
| Next.js | 1 | 1GB | ~10s | ⭐⭐⭐⭐ |

## 🎯 Choosing the Right Example

### For Data & Analytics
→ **Streamlit Dashboard**
- Built-in widgets
- Easy data visualization
- Python ecosystem

### For APIs
→ **FastAPI** (modern) or **Express** (simple)
- FastAPI: Type safety, auto-docs, async
- Express: Minimal, flexible, widely known

### For Web Apps
→ **Next.js**
- Full-stack React
- Server-side rendering
- Modern development experience

### For Simple Sites
→ **Static Site**
- No runtime needed
- Ultra-fast
- Easy to maintain

## 🔧 Customization

Each example is designed to be customized:

### 1. Clone the example
```bash
cp -r examples/streamlit-dashboard my-dashboard
cd my-dashboard
```

### 2. Modify the code
Edit the source files to match your needs.

### 3. Update deployment config
Edit `deploy.star`:
```python
app(
    path="/my-custom-path",
    source=".",  # Local development
    # ... other settings
)
```

### 4. Deploy
```bash
openrun apply --approve deploy.star
```

## 📖 Learning Path

**Beginner:**
1. Start with **Static Site** - understand the basics
2. Try **Express API** - add backend logic
3. Deploy both and connect them

**Intermediate:**
4. Build a **Streamlit Dashboard** - work with data
5. Create a **FastAPI Service** - modern API patterns
6. Connect dashboard to your API

**Advanced:**
7. Build a **Next.js Web App** - full-stack application
8. Connect all services together
9. Add authentication, databases, monitoring

## 🛠️ Development Tips

### Local Testing

Each example can run locally before deploying:

```bash
# Python examples
pip install -r requirements.txt
python app.py  # or streamlit run app.py

# Node.js examples
npm install
npm run dev

# Static site
# Just open index.html in browser
```

### Hot Reload Development

Deploy in dev mode for instant updates:

```bash
openrun app create --dev --approve . /myapp-dev
```

Changes to source files automatically trigger reloads.

### Environment Variables

Set environment-specific variables in `deploy.star`:

```python
app(
    # ...
    env={
        "DATABASE_URL": "postgresql://...",
        "API_KEY": "your-key",
        "DEBUG": "false"
    }
)
```

### Multi-Environment Deployment

Use parameters for different environments:

```bash
# Development
openrun apply --approve --param environment=dev deploy.star

# Staging
openrun apply --approve --param environment=staging deploy.star

# Production
openrun apply --approve --param environment=production deploy.star
```

## 🐛 Troubleshooting

### "Connection refused"
→ Ensure OpenRun server is running: `openrun app list`

### "Port already in use"
→ Check other apps: `openrun app list`
→ Change port in `deploy.star`

### "Build failed"
→ Check logs: `openrun app logs /your-app`
→ Verify dependencies in requirements.txt or package.json

### "Permission denied"
→ Add required permissions in `deploy.star`:
```python
permissions=[
    permission("net.dial", "api.example.com:443")
]
```

## 🤝 Contributing

Found an issue or want to add an example?

1. Fork the repository
2. Create your example in `examples/new-example/`
3. Include:
   - Complete source code
   - `deploy.star` configuration
   - Detailed `README.md`
   - Requirements/dependencies file
4. Submit a pull request

### Example Template Structure

```
examples/your-example/
├── deploy.star          # OpenRun configuration
├── README.md            # Documentation
├── requirements.txt     # Python deps
├── package.json         # Node deps
└── src/                 # Source code
```

## 📚 Additional Resources

- [OpenRun Documentation](https://openrun.dev/docs/)
- [Claude Code Plugin Guide](https://github.com/HyperDevApp/openrun-claude-plugin)
- [Starlark Language Guide](https://starlark-lang.org/)

## 📄 License

All examples are licensed under Apache 2.0 - feel free to use them as starting points for your projects!

---

**Questions?** Open an issue at [github.com/HyperDevApp/openrun-claude-plugin/issues](https://github.com/HyperDevApp/openrun-claude-plugin/issues)
