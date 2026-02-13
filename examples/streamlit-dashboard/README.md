# Streamlit Dashboard Example

A simple analytics dashboard demonstrating OpenRun deployment with Streamlit.

## Features

- 📊 Interactive data visualization
- 🎛️ Dynamic filters and controls
- 📈 Real-time metric calculations
- 📱 Responsive layout

## Local Development

```bash
# Install dependencies
pip install -r requirements.txt

# Run locally
streamlit run app.py
```

Open http://localhost:8501 in your browser.

## Deploy with OpenRun

### Method 1: Using Claude Code Plugin

```
cd streamlit-dashboard
claude code
> Deploy this as a Streamlit app at /dashboard
```

Claude will:
1. Detect it's a Streamlit app
2. Generate the OpenRun configuration
3. Deploy to your OpenRun server

### Method 2: Manual Deployment

```bash
# From this directory
openrun apply --approve deploy.star
```

### Method 3: Quick Deploy

```bash
openrun app create --approve --spec python-streamlit . /dashboard
```

## Configuration

The deployment uses:
- **Port**: 8501 (Streamlit default)
- **Memory**: 512MB
- **CPUs**: 1 core

Customize in `deploy.star`:
```python
container_opts={
    "cpus": "2",          # More CPU
    "memory": "1g",       # More memory
    "port": "8501"
}
```

## Environment Variables

- `STREAMLIT_SERVER_HEADLESS=true` - Run without browser auto-open
- `STREAMLIT_SERVER_PORT=8501` - Server port

## Access

After deployment, access at:
- Local OpenRun: `http://localhost/dashboard`
- Production: `https://yourdomain.com/dashboard`

## Tech Stack

- **Streamlit** - Interactive dashboards
- **Pandas** - Data manipulation
- **NumPy** - Numerical computing
