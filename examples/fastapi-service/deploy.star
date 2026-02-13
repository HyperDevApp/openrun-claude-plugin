# OpenRun deployment configuration for FastAPI Service
load("ace.in", "app")
load("params.in", "param")

def main():
    # Configurable parameters
    api_port = param("port", default="8000", type="INT")
    cpu_limit = param("cpu", default="1", type="STRING")
    memory_limit = param("memory", default="512m", type="STRING")

    app(
        path="/api",
        source="github.com/HyperDevApp/openrun-claude-plugin@main:examples/fastapi-service",
        spec="python-fastapi",
        container_opts={
            "cpus": cpu_limit,
            "memory": memory_limit,
            "port": str(api_port)
        },
        env={
            "WORKERS": "2",
            "LOG_LEVEL": "info"
        }
    )

main()
