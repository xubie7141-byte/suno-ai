from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class UserBase(BaseModel):
    username: str
    email: str

class UserCreate(UserBase):
    password: str

class User(UserBase):
    id: str
    avatar_url: Optional[str] = None
    bio: Optional[str] = None
    created_at: datetime

    class Config:
        from_attributes = True


class MusicBase(BaseModel):
    title: str
    artist: str
    genre: str
    mood: str
    duration: int
    description: Optional[str] = None
    lyrics: Optional[str] = None

class MusicCreate(MusicBase):
    pass

class Music(MusicBase):
    id: str
    cover_image_url: Optional[str] = None
    music_url: Optional[str] = None
    video_url: Optional[str] = None
    likes: int = 0
    downloads: int = 0
    is_favorite: bool = False
    created_at: datetime
    user_id: Optional[str] = None

    class Config:
        from_attributes = True


class MusicCreationBase(BaseModel):
    title: str
    lyrics: Optional[str] = None
    genre: str
    mood: str
    instrument_choice: Optional[str] = None
    singer_style: Optional[str] = None
    tempo: Optional[int] = None

class MusicCreationCreate(MusicCreationBase):
    pass

class MusicCreation(MusicCreationBase):
    id: str
    status: str
    error_message: Optional[str] = None
    generated_music_url: Optional[str] = None
    generated_video_url: Optional[str] = None
    cover_image_url: Optional[str] = None
    created_at: datetime
    completed_at: Optional[datetime] = None

    class Config:
        from_attributes = True
