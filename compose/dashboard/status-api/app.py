from datetime import datetime, timezone
import socket

from fastapi import FastAPI

from providers.system import get_system

app = FastAPI(
    title="Homelab Status API",
    version="0.1.0"
)


@app.get("/health")
def health():
    return {
        "status": "ok"
    }


@app.get("/api/status")
def status():
    return {
        **get_system()
    }