# Express API Example

A simple REST API for user management built with Express.js.

## Features

- 🚀 Fast and lightweight
- 📝 RESTful design
- 🔄 CORS enabled
- 📊 Health check endpoint
- 🛠️ Error handling
- 📦 Easy to extend

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | API information |
| GET | `/health` | Health check with metrics |
| GET | `/users` | List all users |
| GET | `/users/:id` | Get specific user |
| POST | `/users` | Create new user |
| PUT | `/users/:id` | Update user |
| DELETE | `/users/:id` | Delete user |

## Local Development

```bash
npm install
npm run dev  # with nodemon
# or
npm start    # without auto-reload
```

## Deploy with OpenRun

### Using Claude Code Plugin

```
cd express-api
claude code
> Deploy this Express API at /express-api
```

### Manual Deployment

```bash
openrun apply --approve deploy.star
```

## Testing

```bash
# Get all users
curl http://localhost/express-api/users

# Create user
curl -X POST http://localhost/express-api/users \
  -H "Content-Type: application/json" \
  -d '{"name":"David","email":"david@example.com"}'

# Update user
curl -X PUT http://localhost/express-api/users/1 \
  -H "Content-Type: application/json" \
  -d '{"name":"Alice Updated"}'

# Delete user
curl -X DELETE http://localhost/express-api/users/1
```

## Configuration

Minimal resource requirements:
- CPU: 0.5 cores
- Memory: 256MB
- Port: 3000

## Tech Stack

- **Express.js** - Web framework
- **Node.js** - Runtime
