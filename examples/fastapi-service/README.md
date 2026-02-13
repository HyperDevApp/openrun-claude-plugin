# FastAPI Service Example

A REST API for task management demonstrating OpenRun deployment with FastAPI.

## Features

- ✅ RESTful API design
- 📝 Automatic interactive docs (Swagger UI)
- 🔍 Alternative docs (ReDoc)
- 🚀 Fast, async performance
- ✨ Type validation with Pydantic
- 🔄 CORS enabled

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | API information |
| GET | `/health` | Health check |
| GET | `/tasks` | List all tasks |
| GET | `/tasks/{id}` | Get specific task |
| POST | `/tasks` | Create new task |
| PUT | `/tasks/{id}` | Update task |
| DELETE | `/tasks/{id}` | Delete task |

## Local Development

```bash
# Install dependencies
pip install -r requirements.txt

# Run locally
python main.py
# or
uvicorn main:app --reload
```

Open http://localhost:8000/docs for interactive API documentation.

## Deploy with OpenRun

### Method 1: Using Claude Code Plugin

```
cd fastapi-service
claude code
> Deploy this FastAPI app at /api
```

### Method 2: Manual Deployment

```bash
# Default configuration
openrun apply --approve deploy.star

# Custom configuration
openrun apply --approve --param port=9000 --param cpu=2 --param memory=1g deploy.star
```

### Method 3: Quick Deploy

```bash
openrun app create --approve --spec python-fastapi . /api
```

## Testing the API

### Using curl

```bash
# Get all tasks
curl http://localhost/api/tasks

# Create a task
curl -X POST http://localhost/api/tasks \
  -H "Content-Type: application/json" \
  -d '{"title":"New Task","description":"Test task"}'

# Update a task
curl -X PUT http://localhost/api/tasks/1 \
  -H "Content-Type: application/json" \
  -d '{"completed":true}'

# Delete a task
curl -X DELETE http://localhost/api/tasks/1
```

### Using the Interactive Docs

After deployment, visit:
- Swagger UI: `http://localhost/api/docs`
- ReDoc: `http://localhost/api/redoc`

## Configuration

### Parameters

Customize deployment via `deploy.star`:

```python
# deploy.star
openrun apply --approve \
  --param port=9000 \
  --param cpu=2 \
  --param memory=1g \
  deploy.star
```

### Environment Variables

- `WORKERS` - Number of uvicorn workers (default: 2)
- `LOG_LEVEL` - Logging level (default: info)

## Production Considerations

This example uses in-memory storage. For production:

1. **Add a database**:
   ```python
   # Add to requirements.txt
   sqlalchemy
   asyncpg  # for PostgreSQL
   ```

2. **Add authentication**:
   ```python
   from fastapi.security import OAuth2PasswordBearer
   ```

3. **Add rate limiting**:
   ```python
   from slowapi import Limiter
   ```

4. **Add monitoring**:
   ```python
   from prometheus_fastapi_instrumentator import Instrumentator
   ```

## Tech Stack

- **FastAPI** - Modern, fast web framework
- **Uvicorn** - ASGI server
- **Pydantic** - Data validation
