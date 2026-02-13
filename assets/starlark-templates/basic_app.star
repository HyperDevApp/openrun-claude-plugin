# Basic OpenRun Application Configuration
# This template provides a simple, straightforward app definition

load("ace.in", "app")

# Define your application
app(
    # URL path where the app will be accessible
    # Examples: "/", "/dashboard", "/api", "example.com:/"
    path="{{PATH_PREFIX}}",

    # Source location - either a git repository or local path
    # Examples: "github.com/user/repo", "gitlab.com/org/project", "."
    source="{{SOURCE_URL}}",

    # Optional: Specify the app framework/runtime
    # If omitted, OpenRun will attempt auto-detection
    # Examples: "python-streamlit", "node-express", "python-fastapi", "go"
    # spec="{{APP_SPEC}}",

    # Container resource limits and configuration
    container_opts={
        "cpus": "1",           # CPU limit (e.g., "0.5", "2")
        "memory": "512m",      # Memory limit (e.g., "256m", "1g")
        "port": "{{PORT}}"     # Container port (must match app's listen port)
    }
)
