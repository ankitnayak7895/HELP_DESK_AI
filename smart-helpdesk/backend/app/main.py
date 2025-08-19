from fastapi import FastAPI
from . import models, database,auth

# Create DB tables
models.Base.metadata.create_all(bind=database.engine)

app = FastAPI(title="Smart Helpdesk")

app.include_router(auth.router, prefix="/api/auth", tags=["Auth"])

@app.get("/healthz")
def health_check():
    return {"status": "ok"}

@app.get("/")
def root():
    return {"message": "Smart Helpdesk API is running 🚀"}
