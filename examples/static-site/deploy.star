# OpenRun deployment configuration for Static Site
load("ace.in", "app")

app(
    path="/static",
    source="github.com/HyperDevApp/openrun-claude-plugin@main:examples/static-site",
    spec="static",
    container_opts={
        "cpus": "0.25",
        "memory": "128m",
        "port": "80"
    }
)
