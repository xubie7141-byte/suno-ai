from datetime import datetime
from sqlalchemy import Column, String, Integer, Float, Boolean, DateTime, Text, ForeignKey, JSON
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship

Base = declarative_base()

class User(Base):
    __tablename__ = "users"

    id = Column(String, primary_key=True, index=True)
    username = Column(String, unique=True, index=True)
    email = Column(String, unique=True, index=True)
    password_hash = Column(String)
    avatar_url = Column(String, nullable=True)
    bio = Column(Text, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    musics = relationship("Music", back_populates="creator")
    creations = relationship("MusicCreation", back_populates="creator")
    favorites = relationship("Favorite", back_populates="user", cascade="all, delete-orphan")


class Music(Base):
    __tablename__ = "musics"

    id = Column(String, primary_key=True, index=True)
    title = Column(String, index=True)
    artist = Column(String, index=True)
    description = Column(Text, nullable=True)
    lyrics = Column(Text, nullable=True)
    cover_image_url = Column(String, nullable=True)
    music_url = Column(String, nullable=True)
    video_url = Column(String, nullable=True)
    genre = Column(String, index=True)
    mood = Column(String, index=True)
    duration = Column(Integer)  # 秒
    likes = Column(Integer, default=0)
    downloads = Column(Integer, default=0)
    user_id = Column(String, ForeignKey("users.id"), nullable=True)
    is_local_generation = Column(Boolean, default=False)
    created_at = Column(DateTime, default=datetime.utcnow, index=True)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    creator = relationship("User", back_populates="musics")
    favorites = relationship("Favorite", back_populates="music", cascade="all, delete-orphan")


class MusicCreation(Base):
    __tablename__ = "music_creations"

    id = Column(String, primary_key=True, index=True)
    title = Column(String, index=True)
    lyrics = Column(Text, nullable=True)
    genre = Column(String)
    mood = Column(String)
    instrument_choice = Column(String, nullable=True)
    singer_style = Column(String, nullable=True)
    tempo = Column(Integer, nullable=True)
    status = Column(String, default="draft", index=True)  # draft, generating, completed, failed
    error_message = Column(Text, nullable=True)
    generated_music_url = Column(String, nullable=True)
    generated_video_url = Column(String, nullable=True)
    cover_image_url = Column(String, nullable=True)
    user_id = Column(String, ForeignKey("users.id"), nullable=True)
    parameters = Column(JSON, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    completed_at = Column(DateTime, nullable=True)
    
    creator = relationship("User", back_populates="creations")


class Favorite(Base):
    __tablename__ = "favorites"

    id = Column(String, primary_key=True, index=True)
    user_id = Column(String, ForeignKey("users.id"))
    music_id = Column(String, ForeignKey("musics.id"))
    created_at = Column(DateTime, default=datetime.utcnow)
    
    user = relationship("User", back_populates="favorites")
    music = relationship("Music", back_populates="favorites")


class PlayHistory(Base):
    __tablename__ = "play_history"

    id = Column(String, primary_key=True, index=True)
    user_id = Column(String, ForeignKey("users.id"))
    music_id = Column(String, ForeignKey("musics.id"))
    played_at = Column(DateTime, default=datetime.utcnow)
