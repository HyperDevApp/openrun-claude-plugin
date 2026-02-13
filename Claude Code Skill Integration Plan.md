# **Architectural Blueprint: Integrating OpenRun as a Native Capability in Claude Code**

## **1\. Executive Summary**

The convergence of declarative infrastructure and agentic artificial intelligence represents a paradigm shift in modern DevOps. As organizations transition from imperative scripting to intent-based systems, the ability of AI agents to not only generate configuration but also orchestrate its deployment becomes a critical operational requirement. This report provides an exhaustive technical blueprint and implementation plan for integrating **OpenRun**—an open-source, declarative web application deployment platform—into **Claude Code**, Anthropic's agentic command-line interface (CLI).

The integration proposed herein leverages the **Model Context Protocol (MCP)** and Claude Code's **Plugin System** to create a unified interface where natural language commands translate directly into rigorous, GitOps-compliant deployment actions.1 By encapsulating OpenRun’s Starlark-based configuration logic and CLI executable within a structured Claude Code plugin, we effectively grant the AI agent "hands" to manipulate infrastructure on single-node Docker hosts or Kubernetes clusters.1

This document serves as a comprehensive implementation guide, detailing the architectural requirements, security boundaries, and precise code artifacts necessary to construct this integration. It creates a bridge between the cognitive capabilities of Claude Code and the deterministic execution model of OpenRun, effectively creating an autonomous Site Reliability Engineer (SRE) capable of managing internal tool lifecycles. The resulting artifact is a GitHub repository structure that functions as a "plug-and-play" skill for any Claude Code user operating an OpenRun server.

## **2\. Theoretical Framework and Technology Stack**

To understand the integration strategy, one must first dissect the two core technologies involved: the OpenRun deployment architecture and the Claude Code extensibility model. The synergy between these tools lies in their shared philosophy of "configuration as code" and "declarative intent," yet they operate in fundamentally different domains—one in deterministic execution, the other in probabilistic reasoning.

### **2.1 OpenRun: The Declarative Execution Engine**

OpenRun distinguishes itself from traditional Platform-as-a-Service (PaaS) solutions, such as AWS App Runner or Google Cloud Run, by offering a self-hosted, declarative model that runs on standard hardware.1 Its architecture is built around a client-server model written in Go, which simplifies the deployment of containerized web applications. Unlike imperative tools that require a sequence of commands to reach a desired state, OpenRun employs a reconciliation loop similar to Kubernetes, but optimized for single-node efficiency and internal tooling.3

#### **2.1.1 The Starlark Configuration Layer**

At the heart of OpenRun is **Starlark**, a dialect of Python originally developed for the Bazel build system.4 Unlike YAML, which is purely data-serialization, Starlark allows for hermetic execution and logic within configuration files. This is a critical advantage for an AI agent integration.

The choice of Starlark over YAML is pivotal for AI-driven infrastructure. Large Language Models (LLMs) excel at generating Pythonic code due to the vast amount of Python in their training data. OpenRun’s choice of Starlark means that Claude Code can generate complex deployment logic (loops, conditionals, variable substitutions) more reliably than it can generate deeply nested, whitespace-sensitive YAML structures often found in Kubernetes Helm charts.4 Furthermore, Starlark's hermetic nature ensures that the configuration evaluation is deterministic; it cannot access the network or filesystem arbitrarily, providing a safety layer against hallucinated malicious code.6

The integration focuses on manipulating two primary file types:

* **app.star**: The application definition file, which dictates routing, container specifications, and permissions.  
* **params.star**: The parameter definition file, allowing for environment-specific variable injection.

#### **2.1.2 The CLI Command Structure and Idempotency**

The openrun binary serves as the primary interface for the plugin. Key commands that the plugin must wrap include:

* **openrun apply**: The GitOps workhorse. It takes a Starlark file (.ace or .star) and synchronizes the system state to match. This command is idempotent, meaning it can be run multiple times without side effects, making it safe for AI agents to retry in failure scenarios.7  
* **openrun app create**: An imperative command for ad-hoc app instantiation, useful for quick prototyping.  
* **openrun app list**: An observability command to retrieve the current state, essential for the agent to verify its actions.  
* **openrun server start**: The initialization command, typically managed by systemd or Docker, but theoretically accessible to the agent for restart scenarios.8

### **2.2 Claude Code: The Agentic Interface**

Claude Code is not merely a chatbot; it is a terminal-integrated agent capable of executing tools and manipulating the local filesystem. Its extensibility is governed by the Plugin System, which organizes capabilities into discrete units.2

#### **2.2.1 The Plugin Anatomy**

A Claude Code plugin is a directory structure containing specific metadata and functional components. To add OpenRun as a skill, we must construct a plugin with the following components 9:

1. **.claude-plugin/plugin.json**: The manifest file defining identity, version, and capabilities.  
2. **SKILL.md**: A natural language definition that "teaches" Claude the semantic meaning of OpenRun operations and when to employ them.11  
3. **MCP Server**: A standardized server (typically utilizing stdio) that exposes the openrun CLI commands as structured tools (e.g., openrun\_deploy, openrun\_status).13

#### **2.2.2 The Model Context Protocol (MCP)**

The Model Context Protocol (MCP) is the connective tissue of this integration. It standardizes how the agent discovers and utilizes tools. Instead of hardcoding prompt engineering to "run this bash command," we define an MCP server that advertises tools with strict, typed schemas (e.g., "This tool requires a string argument 'path' corresponding to a valid filesystem location"). Claude Code then calls these tools, and the MCP server executes the underlying OpenRun binary, parsing the output back into a format the model can understand.15 This replaces fragile screen-scraping with structured data exchange.

## ---

**3\. Integration Architecture: The "OpenRun-Bridge" Plugin**

We define the solution as a custom plugin named **openrun-bridge**. This plugin acts as a bidirectional translation layer between the probabilistic intent of the user (via Claude) and the deterministic execution of the OpenRun server.

### **3.1 Architectural Principles**

The design of the openrun-bridge is guided by three architectural principles:

1. **Least Privilege via Proxy:** The plugin does not run with root privileges. It runs as the user, communicating with the OpenRun server via a Unix domain socket. This respects the security boundaries of the host system.  
2. **Cognitive Decoupling:** The logic for *how* to deploy (the CLI commands) is separated from the logic of *what* to deploy (the Starlark templates). The MCP server handles the "how," while the SKILL.md and template assets handle the "what."  
3. **Observability First:** The plugin prioritizes retrieving system state (list, status) before and after any mutation (apply, create). This ensures the agent works with grounded truth rather than assumed state.

### **3.2 Component Interaction Diagram**

The data flow for a deployment task follows this distinct sequence:

1. **User Intent:** The user types a command such as "Deploy the current repo as a staging app using the Python spec."  
2. **Cognitive Parsing (Skill Layer):** Claude reads the SKILL.md file to understand that "deploy" maps to creating an app.star file and executing openrun apply. It identifies the necessary parameters (source path, app name) from the conversation history.  
3. **Tool Selection (MCP Layer):** Claude decides to call the openrun\_apply tool exposed by the bundled MCP server. It formulates the JSON payload for the tool call.  
4. **Execution (MCP Server Layer):** The Python-based MCP server receives the request, validates the input types, and spawns a subprocess executing the openrun binary.  
5. **Infrastructure Mutation (OpenRun Layer):** The OpenRun server (running locally or in a container) accepts the command via the socket, pulls the necessary Docker image, or builds the application from source using Kaniko (if on Kubernetes) or local Docker.3  
6. **Feedback Loop:** The CLI output (stdout/stderr) is captured by the MCP server and returned to Claude. Claude interprets the success or failure, potentially attempting self-correction (e.g., fixing a Starlark syntax error) before reporting back to the user.

### **3.3 Directory Structure**

The proposed plugin structure is rigorous and compliant with Anthropic's plugin specifications.10 This directory tree represents the "GitHub repository" required by the user's request.

| Path | Purpose |
| :---- | :---- |
| openrun-bridge/ | Root directory of the repository. |
| ├──.claude-plugin/ | Directory for plugin metadata. |
| │ └── plugin.json | The Manifest file defining the plugin identity and MCP server entry point. |
| ├── skills/ | Directory containing cognitive instructions. |
| │ └── openrun-deploy/ | The specific skill package. |
| │ └── SKILL.md | The cognitive instruction file teaching Claude about OpenRun. |
| ├── server/ | Directory containing the MCP server code. |
| │ ├── server.py | The Python implementation of the MCP server. |
| │ ├── pyproject.toml | Python dependencies (mcp, uv) definition. |
| │ └── README.md | Documentation for the server component. |
| ├── assets/ | Directory for static resources used by the agent. |
| │ └── starlark-templates/ | Reference Starlark templates for Claude to copy/modify. |
| │ ├── basic\_app.star | A generic template for simple web apps. |
| │ └── utils.star | Utility functions for Starlark configuration. |
| └── README.md | General documentation for the plugin repository. |

## ---

**4\. Implementation Phase 1: The Plugin Manifest**

The plugin.json file is the entry point for the integration. It tells Claude Code that this package exists, what version it is, and critically, how to bootstrap the bundled MCP server.

### **4.1 Schema Design and Execution Strategy**

We utilize the mcpServers key to define the execution environment. A critical design decision here is the use of uv, a modern Python package and project manager. We assume the user has Python installed (a prerequisite for many Claude Code workflows). Using uv allows us to run the server in an isolated environment without polluting the user's global Python packages.18

The manifest must also handle environment variables. The openrun CLI relies on finding its configuration file (openrun.toml) and the database socket. We pass the user's home directory via ${HOME} to ensure the CLI functions correctly within the plugin's context.

### **4.2 Code Artifact: openrun-bridge/.claude-plugin/plugin.json**

JSON

{  
  "name": "openrun-bridge",  
  "version": "1.0.0",  
  "description": "Integrates OpenRun declarative deployment capabilities directly into Claude Code. Enables gitops-style application management, starlark configuration generation, and system observability.",  
  "author": {  
    "name": "OpenRun Integration Team",  
    "email": "integration@openrun.dev",  
    "url": "https://github.com/openrundev/openrun"  
  },  
  "license": "Apache-2.0",  
  "mcpServers": {  
    "openrun-cli": {  
      "command": "uv",  
      "args": \[  
        "run",  
        "--with",  
        "mcp\[cli\]",  
        "python",  
        "${CLAUDE\_PLUGIN\_ROOT}/server/server.py"  
      \],  
      "env": {  
        "OPENRUN\_HOME": "${HOME}/clhome",  
        "OPENRUN\_CONFIG": "${HOME}/clhome/openrun.toml",  
        "PATH": "${PATH}:${HOME}/clhome/bin"  
      }  
    }  
  },  
  "keywords": \[  
    "deployment",  
    "openrun",  
    "gitops",  
    "starlark",  
    "infrastructure",  
    "containers",  
    "devops"  
  \]  
}

### **4.3 Analysis of the Manifest**

* **Variable Expansion:** The use of ${CLAUDE\_PLUGIN\_ROOT} is essential. When Claude Code installs a plugin, it copies it to a cache directory. Hardcoding paths would break the installation. This variable ensures the plugin can find its own server.py regardless of where it is installed.13  
* **Path Augmentation:** We explicitly append ${HOME}/clhome/bin to the PATH environment variable. This ensures that if the user installed OpenRun in the default location but didn't add it to their global path, the plugin can still locate the openrun binary.  
* **Dependency Management:** The args array uses uv run \--with mcp\[cli\]. This instructs uv to download the mcp library on the fly if it's missing, execute the script, and then clean up. This "zero-install" experience is vital for a smooth plugin user experience (UX).

## ---

**5\. Implementation Phase 2: The Execution Layer (MCP Server)**

While the manifest points the way, the **MCP Server** is the engine that performs the work. We implement this server in Python using the mcp SDK (specifically the FastMCP class). This server wraps the openrun binary, providing a structured API over the raw CLI.14

### **5.1 Why Python Wrapper?**

Although OpenRun is written in Go, writing the plugin in Python is strategic:

1. **Text Processing:** Python excels at parsing the semi-structured text output of CLI tools.  
2. **Ecosystem:** The mcp Python SDK is mature and easy to read, making the plugin maintainable by a wider audience.  
3. **Runtime Availability:** Python is ubiquitous in the AI/ML environments where Claude Code users operate.

### **5.2 Server Architecture**

The server implements a set of tools that map to OpenRun capabilities. We do not expose *every* flag; rather, we expose the "happy path" workflows that are most relevant to an AI agent. The server handles:

* **Command Construction:** Building the list of arguments for subprocess.run.  
* **Error Sanitization:** Capturing stderr and presenting it as a meaningful error message to the agent, enabling self-correction.  
* **Idempotency Checks:** Ensuring that operations like "create app" check if the app exists first (or handle the "already exists" error gracefully).

### **5.3 Code Artifact: openrun-bridge/server/server.py**

Python

import os  
import subprocess  
import json  
import logging  
from typing import List, Optional, Dict, Any, Union

\# Import the FastMCP class from the official SDK  
from mcp.server.fastmcp import FastMCP

\# Initialize the MCP Server with a descriptive name  
mcp \= FastMCP("OpenRun Integration")

\# Configure logging  
logging.basicConfig(level=logging.INFO)  
logger \= logging.getLogger(\_\_name\_\_)

\# Constants  
OPENRUN\_BIN \= "openrun"

def \_run\_command(args: List\[str\], cwd: Optional\[str\] \= None) \-\> str:  
    """  
    Helper to run openrun commands and capture output.  
      
    This function handles the low-level subprocess execution, environment   
    propagation, and error capturing. It returns the stdout if successful,   
    or a formatted error string if the return code is non-zero.  
    """  
    try:  
        \# Construct the command  
        cmd \= \+ args  
          
        logger.info(f"Executing command: {' '.join(cmd)}")  
          
        \# Execute the subprocess  
        result \= subprocess.run(  
            cmd,  
            capture\_output=True,  
            text=True,  
            cwd=cwd,  
            \# Pass through system environment variables to ensure  
            \# OPENRUN\_HOME and other configs are visible.  
            env=os.environ  
        )  
          
        \# Check for failure  
        if result.returncode\!= 0:  
            error\_msg \= f"Error executing openrun (Exit Code {result.returncode}):\\n"  
            error\_msg \+= f"Stderr: {result.stderr.strip()}\\n"  
            error\_msg \+= f"Stdout: {result.stdout.strip()}"  
            return error\_msg  
          
        \# Return success output  
        return result.stdout.strip()  
          
    except FileNotFoundError:  
        return (  
            "Error: 'openrun' binary not found. "  
            "Please ensure OpenRun is installed and available in the PATH."  
        )  
    except Exception as e:  
        return f"System Error executing OpenRun command: {str(e)}"

@mcp.tool()  
def openrun\_version() \-\> str:  
    """  
    Get the version of the installed OpenRun CLI and Server.  
    Useful for connectivity checks and verifying installation status.  
    """  
    return \_run\_command(\["version"\])

@mcp.tool()  
def openrun\_list(glob\_pattern: str \= "\*", internal: bool \= False) \-\> str:  
    """  
    List running applications on the OpenRun server.  
      
    Args:  
        glob\_pattern: Filter apps by path (default '\*').   
                      Examples: '/api/\*', 'example.com:\*'.  
        internal: If True, show internal/staging apps (e.g., those with \_cl\_stage suffix).  
    """  
    args \= \["app", "list"\]  
    if internal:  
        args.append("-i")  
    args.append(glob\_pattern)  
    return \_run\_command(args)

@mcp.tool()  
def openrun\_apply(file\_path: str, approve: bool \= True, dry\_run: bool \= False) \-\> str:  
    """  
    Apply a declarative Starlark configuration file to the OpenRun server.  
    This is the primary method for deploying apps in a GitOps workflow.  
      
    Args:  
        file\_path: Absolute or relative path to the.star or.ace file.  
        approve: Automatically approve permissions required by the app (default True).  
                 Set to False to review permissions manually.  
        dry\_run: If True, simulate the apply without making changes to the server.  
                 Useful for validating Starlark syntax before deployment.  
    """  
    args \= \["apply"\]  
    if approve:  
        args.append("--approve")  
    if dry\_run:  
        args.append("--dry-run")  
    args.append(file\_path)  
      
    return \_run\_command(args)

@mcp.tool()  
def openrun\_app\_create(  
    path: str,   
    source: str,   
    spec: Optional\[str\] \= None,   
    dev: bool \= False,  
    approve: bool \= True,  
    params: Optional\] \= None  
) \-\> str:  
    """  
    Imperatively create a new app. This is useful for ad-hoc creations  
    where a full Starlark config file hasn't been generated yet.  
      
    Args:  
        path: The URL path for the app (e.g., '/dashboard' or 'domain.com:/').  
        source: Git URL (e.g., 'github.com/org/repo') or local path (e.g., './src').  
        spec: Optional app spec template (e.g., 'python-streamlit', 'node-express').  
              If omitted, OpenRun attempts auto-detection.  
        dev: Enable development mode. In dev mode, local source changes trigger   
             live reloads, and git is not required for local paths.  
        approve: Auto-approve permissions (default True).  
        params: Dictionary of app parameters to set (e.g., {"port": "8080"}).  
    """  
    args \= \["app", "create"\]  
    if dev:  
        args.append("--dev")  
    if approve:  
        args.append("--approve")  
    if spec:  
        args.extend(\["--spec", spec\])  
          
    \# Handle parameters  
    if params:  
        for k, v in params.items():  
            args.extend(\["--param", f"{k}\={v}"\])  
          
    args.append(source)  
    args.append(path)  
      
    return \_run\_command(args)

@mcp.tool()  
def openrun\_app\_approve(path\_glob: str) \-\> str:  
    """  
    Approve permissions for an existing app.   
    Use this if an app is stuck in a 'Pending Approval' state after a failed update  
    or if 'approve=False' was used during creation.  
      
    Args:  
        path\_glob: The app identifier (e.g., '/myapp').  
    """  
    return \_run\_command(\["app", "approve", path\_glob\])

@mcp.tool()  
def openrun\_app\_reload(path\_glob: str, promote: bool \= False) \-\> str:  
    """  
    Reload source code for an app.  
      
    Args:  
        path\_glob: The app identifier.  
        promote: If True, immediately promote staging changes to production  
                 after the reload is successful.  
    """  
    args \= \["app", "reload"\]  
    if promote:  
        args.extend(\["--approve", "--promote"\])  
    args.append(path\_glob)  
    return \_run\_command(args)

@mcp.tool()  
def openrun\_app\_delete(path\_glob: str) \-\> str:  
    """  
    Delete an application. Use with caution.  
      
    Args:  
        path\_glob: The app identifier to delete.  
    """  
    return \_run\_command(\["app", "delete", path\_glob\])

if \_\_name\_\_ \== "\_\_main\_\_":  
    \# Start the server using stdio transport (default)  
    mcp.run()

### **5.4 Code Artifact: openrun-bridge/server/pyproject.toml**

To support uv, we define the dependencies strictly.

Ini, TOML

\[project\]  
name \= "openrun-mcp-server"  
version \= "0.1.0"  
description \= "MCP Server implementation for OpenRun CLI wrapper"  
requires-python \= "\>=3.10"  
dependencies \= \[  
    "mcp\[cli\]\>=1.0.0"  
\]

\[build-system\]  
requires \= \["hatchling"\]  
build-backend \= "hatchling.build"

### **5.5 Detailed Analysis of the MCP Implementation**

The server.py implementation incorporates several advanced patterns:

* **Abstraction of Complexity:** The openrun\_apply tool abstracts away the CLI flag complexity. By defaulting approve=True, we streamline the agent's workflow, relying on the user's initial intent to authorize the deployment. However, we expose dry\_run as a first-class citizen. This allows Claude to "simulate" a deployment, show the diff to the user, and then execute the real deployment in a subsequent turn—a critical pattern for building trust in AI ops.  
* **Parameter Injection:** The openrun\_app\_create tool includes a params argument typed as Dict\[str, str\]. This allows the agent to intelligently map user requests (e.g., "Set the port to 9090") directly to the \--param port=9090 CLI syntax without needing to hallucinate the flag format.  
* **Return Value Management:** The \_run\_command helper captures both stdout and stderr. This is non-negotiable for Starlark debugging. If OpenRun fails, it prints detailed stack traces to stderr. The agent needs this exact text to pinpoint the line number of a syntax error and self-correct the configuration file.

## ---

**6\. Implementation Phase 3: The Cognitive Layer (SKILL.md)**

While the MCP server provides the *ability* to run commands, the **Skill** provides the *intelligence* to use them correctly. The SKILL.md file is a prompt engineering artifact that shapes the agent's behavior, teaching it the specific dialect of Starlark used by OpenRun and the operational heuristics of the platform.

### **6.1 The Role of the Skill**

The OpenRun skill must bridge the gap between abstract user requests ("fix the prod app") and concrete Starlark syntax. It serves as a reference manual for the agent, containing:

1. **Starlark Syntax Guide:** Short, high-signal examples of valid ace.app definitions.  
2. **Workflow Heuristics:** Instructions on when to use \--dev mode (local source) vs production mode (git source).  
3. **Troubleshooting Decision Trees:** Explicit instructions on how to handle specific error codes (e.g., "permission denied" vs "syntax error").

### **6.2 Code Artifact: openrun-bridge/skills/openrun-deploy/SKILL.md**

## ---

**name: openrun-deploy description: Comprehensive skill for managing OpenRun applications, creating Starlark configurations, and executing deployment workflows. allowed-tools: \[openrun-cli\]**

# **OpenRun Deployment Specialist**

You are an expert in OpenRun, the declarative GitOps deployment platform. Your goal is to assist users in deploying internal tools and web applications by generating valid Starlark configuration and executing OpenRun CLI commands via the available tools.

## **Core Capabilities & Tool Selection**

1. **Declarative Deployment (openrun\_apply)**: The PREFERRED method for all production deployments. Uses .star or .ace files to define state.  
2. **Imperative Management (openrun\_app\_create)**: Use ONLY for quick prototyping, one-off checks, or when the user explicitly asks to "just run this folder".  
3. **Observability (openrun\_list)**: Use this BEFORE making changes to check for naming conflicts, and AFTER changes to verify success.

## **Starlark Configuration Guide**

OpenRun apps are defined in Starlark (a Python dialect). You must generate code following these specific patterns. Do not use standard Python libraries (like os or sys) as the environment is hermetic.

### **Pattern 1: Basic App Definition (app.star)**

Use this for custom apps where you define the handler logic inline.python

load("ace.in", "app", "permission")

def handler(req):

return {"body": "Hello OpenRun"}

app \= ace.app(

"myapp",

routes \= \[ace.api("/", handler)\],

permissions \=

)

\#\#\# Pattern 2: Git-Based App (Production)  
Use this when deploying from a repository.

\`\`\`python  
load("ace.in", "app")

app(  
    path="/dashboard",  
    source="\[github.com/myorg/dashboard-app\](https://github.com/myorg/dashboard-app)",  
    spec="python-streamlit", \# Use app specs for frameworks  
    container\_opts={  
        "cpus": "1",   
        "memory": "512m",  
        "port": "8501"   
    }  
)

## **Operational Workflows**

### **1\. New App Deployment Strategy**

* **Step 1**: Analyze the repository or local directory to determine the framework (Streamlit, Flask, Go, Node).  
* **Step 2**: Generate a deploy.star file using the appropriate AppSpec.  
* **Step 3**: Use openrun\_apply(file\_path="deploy.star", dry\_run=True) to validate.  
* **Step 4**: If valid, run openrun\_apply(file\_path="deploy.star", approve=True).  
* **Step 5**: Verify deployment using openrun\_list.

### **2\. Development Mode Strategy**

If the user mentions "dev mode", "local testing", or "hot reload":

* You MUST use the dev=True flag in openrun\_app\_create.  
* Set the source to the absolute path of the local directory, not a git URL.

### **3\. Permission Management**

OpenRun uses a security sandbox. If an app fails with "permission denied":

* Analyze the error log. It will usually state "Permission X required".  
* If using Starlark, add the permission to the permissions list in app.star.  
* If imperative, or to fix a stuck app, run openrun\_app\_approve.

## **Error Handling Guide**

* **"Socket connection failed"**: The OpenRun server is likely not running. Remind the user to run openrun server start in a separate terminal (you cannot start the server yourself).  
* **"Starlark syntax error"**: Re-read the deploy.star file, fix the syntax (watch for trailing commas or indentation), and re-apply.  
* **"App already exists"**: Check if the user wants to update it. If so, use openrun\_apply (which updates) or openrun\_app\_reload. Do not try to create it again.

## **Best Practices**

* Always check openrun\_list before picking an app path to ensure it is available.  
* When creating containerized apps, always try to identify the correct port and set it in container\_opts or params.

\#\#\# 6.3 Insight: Prompt Engineering as Infrastructure  
The \`SKILL.md\` acts as the "operating manual" for the agent. By explicitly defining the "Operational Workflows," we prevent the agent from flailing. For instance, the instruction to "Use \`dry\_run=True\` to validate" enforces a safe-by-default behavior that protects the user's infrastructure from malformed configs. The "Starlark Configuration Guide" is essentially a few-shot learning prompt embedded in the plugin, giving the model concrete examples of the domain-specific language (DSL) it needs to generate.

\---

\#\# 7\. Packaging and Asset Management

To further assist the agent, we include static assets. These are template files that the agent can read and copy, ensuring that generated configurations start from a known-good state.

\#\#\# 7.1 Code Artifact: \`openrun-bridge/assets/starlark-templates/universal\_app.star\`

This template covers 90% of use cases (Python/Node/Go web apps), allowing the agent to perform variable substitution rather than generating code from scratch.

\`\`\`python  
\# Universal OpenRun App Template  
load("ace.in", "app")  
load("params.in", "param")

def main(path\_prefix="/"):  
    \# Define customizable parameters for the deployment  
    \# These can be overridden via CLI \--param flags or params.star  
    container\_port \= param("port", default="8080", type="INT")  
    cpu\_limit \= param("cpu", default="1", type="STRING")  
    mem\_limit \= param("memory", default="512m", type="STRING")  
      
    \# Define the application  
    app(  
        path \= path\_prefix,  
          
        \# Auto-detect source from the current directory context  
        \# In gitops workflows, this will be replaced by the git URL  
        source \= ".",   
          
        \# Container configuration  
        container\_opts \= {  
            "cpus": cpu\_limit,  
            "memory": mem\_limit,  
            "port": str(container\_port)  
        },  
          
        \# Environment variables passed to the container  
        env \= {  
            "NODE\_ENV": "production",  
            "LOG\_LEVEL": "info"  
        },  
          
        \# Permissions required by the app  
        \# Empty by default, populated by Agent analysis  
        permissions \=  
    )

## **8\. Operational Workflows and Security Analysis**

Integrating an infrastructure tool into an AI agent requires strict security boundaries. OpenRun and Claude Code both utilize sandboxing, creating a "double sandbox" scenario that must be navigated carefully.

### **8.1 The Double Sandbox Challenge**

1. **Claude Code Sandbox:** Restricts the agent from writing files outside the project root or accessing arbitrary network endpoints.20  
2. **OpenRun Sandbox:** The OpenRun server restricts what system commands a deployed app can run (e.g., blocking rm \-rf / via exec.in plugin permissions).21

### **8.2 The Privileged Socket Solution**

The plugin operates at the **Control Plane** level. It does not run *inside* the OpenRun app containers; it talks to the OpenRun **Management Server**.

* **Constraint:** The openrun CLI communicates with the server via a Unix Domain Socket (typically clhome/run/openrun.sock).  
* **Configuration:** The plugin's plugin.json sets OPENRUN\_HOME to ensure the CLI can find this socket.  
* **Security Implication:** The agent (Claude) essentially has administrative control over the OpenRun server. Therefore, the openrun-bridge plugin should generally be installed with **user scope** (global) rather than **project scope**, ensuring only the trusted owner of the machine activates it.

### **8.3 Operational Scenario: The "Fix and Deploy" Loop**

Consider a scenario where a user reports a bug in a live application.

| Step | Actor | Action | Mechanism |
| :---- | :---- | :---- | :---- |
| 1 | User | Request: "Fix the bug in the disk usage app logic." | Prompt |
| 2 | Claude | **Diagnosis**: Reads main.go source code. | Native read\_file tool |
| 3 | Claude | **Patch**: Applies the fix to the code. | Native edit\_file tool |
| 4 | Claude | **Discovery**: Finds the app identifier (/disk\_usage). | MCP openrun\_list |
| 5 | Claude | **Deployment**: Triggers a reload with promotion. | MCP openrun\_app\_reload(path="/disk\_usage", promote=True) |
| 6 | OpenRun | **Build**: Rebuilds the container/binary. | OpenRun Server Internal |
| 7 | Claude | **Verification**: Confirms version increment. | MCP openrun\_list |

This workflow demonstrates the power of the integration: the agent handles the entire lifecycle from code edit to infrastructure update without the user context-switching to a terminal.

## ---

**9\. Future Roadmap and Kubernetes Scaling**

The proposed integration is robust, but the OpenRun project is evolving. A key strength of this architecture is its transparency regarding the backend execution environment.

### **9.1 Scaling to Kubernetes**

OpenRun supports a Kubernetes backend where openrun apply triggers a Kaniko build and a Kubernetes Deployment update instead of a local Docker run.3

* **Plugin Impact:** Minimal. Because the plugin wraps the declarative apply command, the agent does not need "Kubernetes awareness." It does not need to know kubectl syntax or Helm charts.  
* **Architectural Benefit:** This decouples the AI agent from the complexity of the orchestration layer. The agent speaks "OpenRun Starlark," and OpenRun translates that to "Kubernetes YAML." This significantly reduces the cognitive load on the model and the potential for hallucination-induced cluster errors.

### **9.2 Advanced Dynamic Tooling**

A future enhancement to the server.py could involve dynamic tool generation. Instead of hardcoding the tools, the server could parse the JSON output of openrun app list-specs to dynamically generate MCP tools for every available AppSpec (e.g., create\_streamlit\_app, create\_fastapi\_app). This would allow the plugin to self-update its capabilities as the underlying OpenRun installation gains new framework supports.

## **10\. Conclusion**

The integration of OpenRun into Claude Code via the Model Context Protocol represents a high-impact productivity multiplier for internal tool development. By wrapping the deterministic, declarative nature of OpenRun's Starlark engine with the semantic understanding of Claude Code, we create a system where infrastructure management becomes a conversation rather than a sequence of manual shell commands.

The implementation detailed above—comprising a strictly typed MCP server, a context-rich Skill definition, and a compliant Plugin manifest—provides a production-ready blueprint. It respects security boundaries through socket-based access control and leverages the strengths of both platforms: OpenRun’s rigorous execution and Claude’s flexible reasoning. This openrun-bridge plugin effectively turns Claude Code into a Tier-1 operator for self-hosted PaaS infrastructure, bridging the gap between intent and implementation.

#### **Works cited**

1. openrundev/openrun: Open source alternative to Google Cloud Run and AWS App Runner. Easily deploy web apps declaratively. \- GitHub, accessed February 13, 2026, [https://github.com/openrundev/openrun](https://github.com/openrundev/openrun)  
2. Discover and install prebuilt plugins through marketplaces \- Claude Code Docs, accessed February 13, 2026, [https://code.claude.com/docs/en/discover-plugins](https://code.claude.com/docs/en/discover-plugins)  
3. OpenRun: Declarative web app deployment : r/kubernetes \- Reddit, accessed February 13, 2026, [https://www.reddit.com/r/kubernetes/comments/1qypboz/openrun\_declarative\_web\_app\_deployment/](https://www.reddit.com/r/kubernetes/comments/1qypboz/openrun_declarative_web_app_deployment/)  
4. Python as a Configuration Language Using Starlark \- openrun.dev, accessed February 13, 2026, [https://openrun.dev/blog/starlark/](https://openrun.dev/blog/starlark/)  
5. Resources | Starlark Programming Language, accessed February 13, 2026, [https://starlark-lang.org/resources.html](https://starlark-lang.org/resources.html)  
6. Python as a Configuration Language (via Starlark) : r/programming \- Reddit, accessed February 13, 2026, [https://www.reddit.com/r/programming/comments/1o8hia6/python\_as\_a\_configuration\_language\_via\_starlark/](https://www.reddit.com/r/programming/comments/1o8hia6/python_as_a_configuration_language_via_starlark/)  
7. Quick Start – OpenRun \- Internal Tools Deployment Platform, accessed February 13, 2026, [https://openrun.dev/docs/quickstart/](https://openrun.dev/docs/quickstart/)  
8. Installation – OpenRun \- App Deployment Simplified, accessed February 13, 2026, [https://openrun.dev/docs/installation/](https://openrun.dev/docs/installation/)  
9. claude-code/plugins/README.md at main · anthropics/claude-code ..., accessed February 13, 2026, [https://github.com/anthropics/claude-code/blob/main/plugins/README.md](https://github.com/anthropics/claude-code/blob/main/plugins/README.md)  
10. Create plugins \- Claude Code Docs, accessed February 13, 2026, [https://code.claude.com/docs/en/plugins](https://code.claude.com/docs/en/plugins)  
11. How to Build Claude Skills: Lesson Plan Generator Tutorial \- Codecademy, accessed February 13, 2026, [https://www.codecademy.com/article/how-to-build-claude-skills](https://www.codecademy.com/article/how-to-build-claude-skills)  
12. Extend Claude with skills \- Claude Code Docs, accessed February 13, 2026, [https://code.claude.com/docs/en/skills](https://code.claude.com/docs/en/skills)  
13. Connect Claude Code to tools via MCP, accessed February 13, 2026, [https://code.claude.com/docs/en/mcp](https://code.claude.com/docs/en/mcp)  
14. How to Build a Python MCP Server to Consult a Knowledge Base \- Auth0, accessed February 13, 2026, [https://auth0.com/blog/build-python-mcp-server-for-blog-search/](https://auth0.com/blog/build-python-mcp-server-for-blog-search/)  
15. Add MCP Servers to Claude Code with Docker MCP Toolkit (Docker Tutorial), accessed February 13, 2026, [https://www.youtube.com/watch?v=1Tu0c1zuz70](https://www.youtube.com/watch?v=1Tu0c1zuz70)  
16. Power BI Modeling MCP Server — Step-by-Step Implementation Guide, accessed February 13, 2026, [https://medium.com/@michael.hannecke/power-bi-modeling-mcp-server-step-by-step-implementation-guide-b7209d6d2506](https://medium.com/@michael.hannecke/power-bi-modeling-mcp-server-step-by-step-implementation-guide-b7209d6d2506)  
17. ivan-magda/claude-code-plugin-template \- GitHub, accessed February 13, 2026, [https://github.com/ivan-magda/claude-code-plugin-template](https://github.com/ivan-magda/claude-code-plugin-template)  
18. Building a Simple MCP Server in Python Using the MCP Python SDK \- GitHub, accessed February 13, 2026, [https://github.com/ruslanmv/Simple-MCP-Server-with-Python](https://github.com/ruslanmv/Simple-MCP-Server-with-Python)  
19. A Quick Introduction to Model Context Protocol (MCP) in Python \- Medium, accessed February 13, 2026, [https://medium.com/@adev94/a-quick-introduction-to-model-context-protocol-mcp-in-python-bee6d36334ec](https://medium.com/@adev94/a-quick-introduction-to-model-context-protocol-mcp-in-python-bee6d36334ec)  
20. Sandboxing \- Claude Code Docs, accessed February 13, 2026, [https://code.claude.com/docs/en/sandboxing](https://code.claude.com/docs/en/sandboxing)  
21. Application Security – OpenRun \- App Deployment Simplified, accessed February 13, 2026, [https://openrun.dev/docs/applications/appsecurity/](https://openrun.dev/docs/applications/appsecurity/)