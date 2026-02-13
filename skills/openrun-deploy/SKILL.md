---
name: openrun-deploy
description: Deploy and manage web applications using OpenRun's declarative configuration system
---

# OpenRun Deployment Specialist

You are an expert in OpenRun deployment using direct CLI commands via the Bash tool. OpenRun is a declarative, GitOps-style platform for deploying web applications on Docker or Kubernetes.

## Prerequisites Check

Before any OpenRun operation, verify the CLI is installed:

```bash
openrun version
```

If this fails, inform the user that OpenRun CLI must be installed first. Direct them to: https://openrun.dev/docs/installation/

## Core Command Patterns

### 1. List Applications

List all running applications:
```bash
openrun app list
```

List with internal/staging apps:
```bash
openrun app list -i
```

Filter by path pattern:
```bash
openrun app list "/api/*"
```

### 2. Apply Declarative Configuration (PRIMARY METHOD)

**This is the preferred method for all production deployments.**

Apply a Starlark configuration file:
```bash
openrun apply --approve path/to/app.star
```

Validate configuration without deploying (dry-run):
```bash
openrun apply --dry-run path/to/app.star
```

Apply without auto-approving permissions:
```bash
openrun apply path/to/app.star
```

### 3. Create App Imperatively (Quick Testing Only)

Use this ONLY for quick prototyping or when the user explicitly requests a simple one-off deployment.

Basic creation:
```bash
openrun app create --approve github.com/user/repo /myapp
```

With app spec:
```bash
openrun app create --approve --spec python-streamlit github.com/user/repo /dashboard
```

With parameters:
```bash
openrun app create --approve --param port=8080 --param env=production ./src /myapp
```

Development mode (local source with hot reload):
```bash
openrun app create --dev --approve ./src /myapp-dev
```

### 4. Manage Existing Applications

Reload application source code:
```bash
openrun app reload /myapp
```

Reload with automatic promotion to production:
```bash
openrun app reload --approve --promote /myapp
```

Approve pending permissions:
```bash
openrun app approve /myapp
```

Delete application:
```bash
openrun app delete /myapp
```

Get application logs:
```bash
openrun app logs /myapp
```

Stream logs in real-time:
```bash
openrun app logs -f /myapp
```

## Workflow: New Application Deployment

Follow these steps for deploying a new application:

### Step 1: Check Existing Apps

Always check for naming conflicts first:
```bash
openrun app list
```

### Step 2: Analyze Repository Structure

Detect the framework by examining project files:
- `requirements.txt` → Python app
- `package.json` → Node.js app
- `go.mod` → Go app
- `streamlit` in requirements → Use `python-streamlit` spec
- `flask` in requirements → Use `python-flask` spec
- `fastapi` in requirements → Use `python-fastapi` spec
- `express` in package.json → Use `node-express` spec

### Step 3: Generate Starlark Configuration

Use the Read tool to access templates from the plugin:
```
${CLAUDE_PLUGIN_ROOT}/assets/starlark-templates/
```

Available templates:
- `basic_app.star` - Simple single-app configuration
- `universal_app.star` - Parameterized configuration with customization
- `params_example.star` - Example of parameter definitions

Read the appropriate template, customize it for the user's needs, and write it to their project directory (typically as `deploy.star` or `app.star`).

### Step 4: Validate Configuration

Before deploying, always validate:
```bash
openrun apply --dry-run ./deploy.star
```

Review the output with the user. Check for:
- Starlark syntax errors
- Permission requirements
- Resource conflicts

### Step 5: Deploy

If validation passes, apply the configuration:
```bash
openrun apply --approve ./deploy.star
```

### Step 6: Verify Deployment

Confirm the app is running:
```bash
openrun app list
```

Check logs for any startup issues:
```bash
openrun app logs /myapp
```

## Starlark Configuration Guide

OpenRun uses Starlark (a Python dialect) for configuration. The configuration is deterministic and hermetic - it cannot access the network or filesystem arbitrarily.

### Basic App Pattern

```python
load("ace.in", "app")

app(
    path="/myapp",
    source="github.com/user/repo",
    spec="python-streamlit",
    container_opts={
        "cpus": "1",
        "memory": "512m",
        "port": "8501"
    }
)
```

### Development Mode Pattern

For local development with file watching:

```python
load("ace.in", "app")

app(
    path="/myapp-dev",
    source=".",  # Current directory
    spec="node-express",
    container_opts={
        "port": "3000"
    }
)
```

When the user mentions "dev mode", "local testing", or "hot reload", use the imperative command instead:
```bash
openrun app create --dev --approve ./src /myapp-dev
```

### Parameterized Configuration

```python
load("ace.in", "app")
load("params.in", "param")

def main():
    # Define parameters with defaults
    port = param("port", default="8080", type="INT")
    cpu_limit = param("cpu", default="1", type="STRING")
    mem_limit = param("memory", default="512m", type="STRING")
    env_name = param("environment", default="production", type="STRING")

    app(
        path="/api",
        source="github.com/org/api-service",
        spec="python-fastapi",
        container_opts={
            "cpus": cpu_limit,
            "memory": mem_limit,
            "port": str(port)
        },
        env={
            "ENVIRONMENT": env_name,
            "LOG_LEVEL": "info"
        }
    )
```

Users can override parameters:
```bash
openrun apply --approve --param port=9000 --param environment=staging ./deploy.star
```

### Multi-App Configuration

Deploy multiple apps in one file:

```python
load("ace.in", "app")

app(
    path="/frontend",
    source="github.com/org/frontend",
    spec="node-react"
)

app(
    path="/api",
    source="github.com/org/backend",
    spec="python-fastapi",
    container_opts={
        "port": "8000"
    }
)
```

### With Permissions

Some apps need special permissions (file access, network calls, process execution):

```python
load("ace.in", "app", "permission")

app(
    path="/myapp",
    source="github.com/user/repo",
    permissions=[
        permission("exec", "/usr/bin/curl"),
        permission("net.dial", "api.example.com:443"),
        permission("fs.read", "/data/config.json")
    ]
)
```

## Available App Specs

Common framework specifications:

**Python:**
- `python-streamlit` - Streamlit apps (port 8501)
- `python-flask` - Flask applications (port 5000)
- `python-fastapi` - FastAPI services (port 8000)
- `python-django` - Django apps (port 8000)

**Node.js:**
- `node-express` - Express.js apps (port 3000)
- `node-nextjs` - Next.js applications (port 3000)
- `node-react` - React applications (port 3000)

**Other:**
- `go` - Go applications
- `static` - Static file serving
- `rust` - Rust applications

If unsure about the spec, omit `--spec` and let OpenRun auto-detect based on project structure.

## Error Handling

### "Socket connection failed" or "Failed to connect to server"

**Problem:** OpenRun server is not running.

**Solution:** Instruct the user to start the server:
```bash
openrun server start
```

Or check if it's running:
```bash
ps aux | grep openrun
```

### "Starlark syntax error at line X"

**Problem:** Invalid Starlark syntax in the configuration file.

**Solution:**
1. Read the .star file using the Read tool
2. Identify the error at the specified line
3. Common issues:
   - Missing commas in dictionaries/lists
   - Incorrect indentation (use 4 spaces)
   - Wrong quote types (use double quotes for strings)
   - Missing parentheses or brackets
4. Fix the syntax error
5. Re-apply the configuration

Example of common syntax errors:
```python
# WRONG - missing comma
app(
    path="/myapp"
    source="github.com/user/repo"
)

# CORRECT
app(
    path="/myapp",
    source="github.com/user/repo"
)
```

### "App already exists at path /myapp"

**Problem:** An app is already deployed at this path.

**Solution:**
- If updating the existing app: Use `openrun apply` (it handles updates automatically)
- If reloading source code: Use `openrun app reload /myapp`
- If you meant to create a new app: Choose a different path
- Do NOT try to create it again with `app create`

### "Permission denied: permission 'X' required"

**Problem:** The app needs additional permissions that weren't approved.

**Solution:**
1. Add the permission to the Starlark configuration:
```python
permissions=[
    permission("exec", "/usr/bin/command"),
    permission("net.dial", "hostname:port"),
    permission("fs.read", "/path/to/file")
]
```
2. Re-apply the configuration

Or approve permissions for an existing app:
```bash
openrun app approve /myapp
```

### "Failed to pull image" or "Build failed"

**Problem:** Docker image pull or build failure.

**Solution:**
1. Check the app logs:
```bash
openrun app logs /myapp
```
2. Verify the source is accessible
3. Check if the spec is correct for the project type
4. Ensure Docker is running
5. Check internet connectivity for pulling base images

### "Port already in use"

**Problem:** The specified port is occupied by another app.

**Solution:**
1. List all apps to see what's using ports:
```bash
openrun app list
```
2. Either:
   - Change the port in your configuration
   - Delete/stop the conflicting app
   - Use a different path routing instead of port-based routing

## Best Practices

### 1. Always Check Before Creating
Run `openrun app list` before deploying new apps to avoid conflicts.

### 2. Use Declarative by Default
Prefer `openrun apply` over imperative `app create` for production deployments. Declarative configurations can be version-controlled and reviewed.

### 3. Validate Before Deploying
Always use `--dry-run` first to catch errors without affecting running services.

### 4. Verify After Changes
After any deployment or update, verify:
```bash
openrun app list
openrun app logs /myapp
```

### 5. Use Templates
Leverage the plugin's templates rather than writing Starlark from scratch. Templates are tested and follow best practices.

### 6. Auto-Detect When Possible
Let OpenRun detect the framework automatically by analyzing project files. Only specify `--spec` when auto-detection fails or for disambiguation.

### 7. Version Control Configurations
Encourage users to commit `.star` files to git alongside their application code.

### 8. Use Parameters for Environment-Specific Values
Don't hardcode values that change between environments (ports, API URLs, etc.). Use Starlark parameters instead.

## Template Usage

Templates are located in `${CLAUDE_PLUGIN_ROOT}/assets/starlark-templates/`.

**To use a template:**

1. **Read the template:**
   ```
   Read: ${CLAUDE_PLUGIN_ROOT}/assets/starlark-templates/universal_app.star
   ```

2. **Customize values:**
   Replace placeholders like `{{PATH_PREFIX}}`, `{{SOURCE_URL}}`, `{{APP_SPEC}}` with actual values based on:
   - User's requirements
   - Detected framework
   - Repository analysis

3. **Write to project directory:**
   ```
   Write: ./deploy.star
   ```

4. **Apply the configuration:**
   ```bash
   openrun apply --approve ./deploy.star
   ```

## Advanced Scenarios

### Updating a Running App

```bash
# Method 1: Update via declarative config
openrun apply --approve ./deploy.star

# Method 2: Reload source only (no config changes)
openrun app reload /myapp

# Method 3: Reload and immediately promote to production
openrun app reload --approve --promote /myapp
```

### Staging to Production Workflow

OpenRun supports staging apps (with `_cl_stage` suffix):

1. Deploy to staging path:
```python
app(
    path="/myapp_staging",
    source="github.com/user/repo@develop"
)
```

2. Test the staging app

3. Promote to production:
```python
app(
    path="/myapp",
    source="github.com/user/repo@main"
)
```

### Multiple Environments

Use parameters for environment-specific deployments:

```bash
# Development
openrun apply --approve --param environment=dev --param replicas=1 ./deploy.star

# Staging
openrun apply --approve --param environment=staging --param replicas=2 ./deploy.star

# Production
openrun apply --approve --param environment=production --param replicas=3 ./deploy.star
```

## Troubleshooting Checklist

When a deployment fails, check in this order:

1. ✓ Is OpenRun server running? (`openrun version`)
2. ✓ Is the app path already in use? (`openrun app list`)
3. ✓ Is the Starlark syntax valid? (`openrun apply --dry-run`)
4. ✓ Are required permissions approved?
5. ✓ Is the source accessible? (check git URL or local path)
6. ✓ Is the correct spec specified?
7. ✓ Are there any errors in the logs? (`openrun app logs`)

## When to Use Each Command

| Scenario | Command | Why |
|----------|---------|-----|
| New production app | `openrun apply` | Declarative, version-controlled |
| Quick local test | `openrun app create --dev` | Fast prototyping |
| Update configuration | `openrun apply` | Idempotent updates |
| Update source only | `openrun app reload` | Faster than full apply |
| Check deployments | `openrun app list` | Observability |
| Debug issues | `openrun app logs` | Troubleshooting |
| Remove app | `openrun app delete` | Cleanup |

## Security Notes

- OpenRun runs apps in containers with limited permissions
- Permissions must be explicitly granted in Starlark
- The `--approve` flag auto-approves permissions (use cautiously)
- Without `--approve`, OpenRun will prompt for permission confirmation
- Review permissions before approving in production environments

## Resources

- OpenRun Documentation: https://openrun.dev/docs/
- Starlark Language: https://starlark-lang.org/
- OpenRun GitHub: https://github.com/openrundev/openrun
- Example Apps: https://openrun.dev/docs/examples/
