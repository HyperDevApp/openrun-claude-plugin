# Example: Using Parameters in OpenRun
# This file demonstrates various parameter patterns and types

load("ace.in", "app")
load("params.in", "param")

def main():
    # String parameters
    api_url = param("api_url", default="https://api.example.com", type="STRING")
    database_host = param("db_host", default="localhost", type="STRING")

    # Integer parameters
    port = param("port", default="8080", type="INT")
    worker_count = param("workers", default="4", type="INT")

    # Boolean-like parameters (Starlark doesn't have native booleans in params)
    # Use string and convert in code
    debug_mode = param("debug", default="false", type="STRING")

    # Resource limits
    cpu_limit = param("cpu", default="2", type="STRING")
    memory_limit = param("memory", default="1g", type="STRING")

    # Build environment variables
    env_vars = {
        "API_URL": api_url,
        "DATABASE_HOST": database_host,
        "WORKER_COUNT": str(worker_count),
        "DEBUG": debug_mode
    }

    # Application definition
    app(
        path="/myapp",
        source="github.com/user/repo",
        container_opts={
            "cpus": cpu_limit,
            "memory": memory_limit,
            "port": str(port)
        },
        env=env_vars
    )

main()

# Usage examples:
#
# Use defaults:
#   openrun apply --approve params_example.star
#
# Override single parameter:
#   openrun apply --approve --param port=9000 params_example.star
#
# Override multiple parameters:
#   openrun apply --approve \
#     --param port=9000 \
#     --param workers=8 \
#     --param memory=2g \
#     --param debug=true \
#     params_example.star
#
# Environment-specific deployment:
#   # Development
#   openrun apply --approve --param debug=true --param workers=2 params_example.star
#
#   # Production
#   openrun apply --approve --param debug=false --param workers=8 --param memory=4g params_example.star
