# Universal OpenRun Application Template
# This template uses parameters for flexible, environment-specific deployments

load("ace.in", "app")
load("params.in", "param")

def main():
    # Define customizable parameters with defaults
    # These can be overridden via CLI: --param key=value

    # Container resource parameters
    container_port = param("port", default="8080", type="INT")
    cpu_limit = param("cpu", default="1", type="STRING")
    mem_limit = param("memory", default="512m", type="STRING")

    # Application parameters
    app_path = param("path", default="{{PATH_PREFIX}}", type="STRING")
    app_source = param("source", default="{{SOURCE_URL}}", type="STRING")
    app_spec = param("spec", default="{{APP_SPEC}}", type="STRING")

    # Environment-specific parameters
    environment = param("environment", default="production", type="STRING")
    log_level = param("log_level", default="info", type="STRING")

    # Define the application
    app(
        path=app_path,
        source=app_source,
        spec=app_spec,

        # Container configuration using parameters
        container_opts={
            "cpus": cpu_limit,
            "memory": mem_limit,
            "port": str(container_port)
        },

        # Environment variables passed to the container
        env={
            "ENVIRONMENT": environment,
            "LOG_LEVEL": log_level,
            "NODE_ENV": environment,  # For Node.js apps
            "PYTHON_ENV": environment  # For Python apps
        },

        # Permissions required by the app
        # Add as needed for your application
        permissions=[]
    )

# Execute the main function
main()
