from sqlalchemy import Column, Integer, String, DateTime, Enum
from .database import Base
from datetime import datetime
import enum

class UserRole(str, enum.Enum):
    admin = "admin"
    agent = "agent"
    user = "user"

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    email = Column(String, unique=True, index=True, nullable=False)
    password_hash = Column(String, nullable=False)
    role = Column(Enum(UserRole), default=UserRole.user)
    created_at = Column(DateTime, default=datetime.utcnow)
