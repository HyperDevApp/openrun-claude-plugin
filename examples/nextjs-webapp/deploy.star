# OpenRun deployment configuration for Next.js Web App
load("ace.in", "app")

app(
    path="/webapp",
    source="github.com/HyperDevApp/openrun-claude-plugin@main:examples/nextjs-webapp",
    spec="node-nextjs",
    container_opts={
        "cpus": "1",
        "memory": "1g",
        "port": "3000"
    },
    env={
        "NODE_ENV": "production"
    }
)
