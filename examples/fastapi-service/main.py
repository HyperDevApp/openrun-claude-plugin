"""
FastAPI Service Example
A REST API demonstrating OpenRun deployment with FastAPI
"""

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime
import uvicorn

# Initialize FastAPI
app = FastAPI(
    title="Task Management API",
    description="Example REST API deployed with OpenRun",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Data models
class Task(BaseModel):
    id: Optional[int] = None
    title: str
    description: Optional[str] = None
    completed: bool = False
    created_at: Optional[datetime] = None

class TaskUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    completed: Optional[bool] = None

# In-memory storage (replace with database in production)
tasks_db: List[Task] = [
    Task(id=1, title="Deploy with OpenRun", description="Deploy this API using OpenRun", completed=True, created_at=datetime.now()),
    Task(id=2, title="Test API endpoints", description="Verify all endpoints work correctly", completed=False, created_at=datetime.now()),
    Task(id=3, title="Add authentication", description="Implement JWT authentication", completed=False, created_at=datetime.now()),
]
task_counter = len(tasks_db)

# Routes
@app.get("/")
def read_root():
    """Root endpoint with API information"""
    return {
        "message": "Task Management API",
        "version": "1.0.0",
        "deployed_with": "OpenRun",
        "docs": "/docs",
        "endpoints": {
            "tasks": "/tasks",
            "health": "/health"
        }
    }

@app.get("/health")
def health_check():
    """Health check endpoint"""
    return {
        "status": "healthy",
        "timestamp": datetime.now().isoformat(),
        "tasks_count": len(tasks_db)
    }

@app.get("/tasks", response_model=List[Task])
def get_tasks(completed: Optional[bool] = None):
    """Get all tasks, optionally filtered by completion status"""
    if completed is None:
        return tasks_db
    return [task for task in tasks_db if task.completed == completed]

@app.get("/tasks/{task_id}", response_model=Task)
def get_task(task_id: int):
    """Get a specific task by ID"""
    for task in tasks_db:
        if task.id == task_id:
            return task
    raise HTTPException(status_code=404, detail="Task not found")

@app.post("/tasks", response_model=Task, status_code=201)
def create_task(task: Task):
    """Create a new task"""
    global task_counter
    task_counter += 1
    task.id = task_counter
    task.created_at = datetime.now()
    tasks_db.append(task)
    return task

@app.put("/tasks/{task_id}", response_model=Task)
def update_task(task_id: int, task_update: TaskUpdate):
    """Update an existing task"""
    for task in tasks_db:
        if task.id == task_id:
            if task_update.title is not None:
                task.title = task_update.title
            if task_update.description is not None:
                task.description = task_update.description
            if task_update.completed is not None:
                task.completed = task_update.completed
            return task
    raise HTTPException(status_code=404, detail="Task not found")

@app.delete("/tasks/{task_id}", status_code=204)
def delete_task(task_id: int):
    """Delete a task"""
    for i, task in enumerate(tasks_db):
        if task.id == task_id:
            tasks_db.pop(i)
            return
    raise HTTPException(status_code=404, detail="Task not found")

# Run with uvicorn
if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
