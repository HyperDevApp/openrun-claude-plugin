# OpenRun deployment configuration for Express API
load("ace.in", "app")

app(
    path="/express-api",
    source="github.com/HyperDevApp/openrun-claude-plugin@main:examples/express-api",
    spec="node-express",
    container_opts={
        "cpus": "0.5",
        "memory": "256m",
        "port": "3000"
    },
    env={
        "NODE_ENV": "production"
    }
)
