# OpenRun deployment configuration for Streamlit Dashboard
load("ace.in", "app")

app(
    path="/dashboard",
    source="github.com/HyperDevApp/openrun-claude-plugin@main:examples/streamlit-dashboard",
    spec="python-streamlit",
    container_opts={
        "cpus": "1",
        "memory": "512m",
        "port": "8501"
    },
    env={
        "STREAMLIT_SERVER_HEADLESS": "true",
        "STREAMLIT_SERVER_PORT": "8501"
    }
)
