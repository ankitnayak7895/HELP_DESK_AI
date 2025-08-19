from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker,declarative_base

# Using SQLite for simplicity
SQLALCHEMY_DATABASE_URL = "sqlite:///./helpdesk.db"

engine = create_engine(
    SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False}
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

# Dependency for DB session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()