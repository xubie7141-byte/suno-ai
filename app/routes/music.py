from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.db.database import get_db
from app.services.music_service import MusicService, FavoriteService
from app.schemas.schemas import Music
from typing import List

router = APIRouter(prefix="/api/music", tags=["music"])

@router.get("/", response_model=List[Music])
async def get_music_list(
    page: int = 1,
    page_size: int = 20,
    genre: str = None,
    mood: str = None,
    db: Session = Depends(get_db)
):
    """获取音乐列表"""
    skip = (page - 1) * page_size
    musics = MusicService.get_musics(
        db,
        skip=skip,
        limit=page_size,
        genre=genre,
        mood=mood
    )
    return musics

@router.get("/{music_id}", response_model=Music)
async def get_music(music_id: str, db: Session = Depends(get_db)):
    """获取单个音乐详情"""
    music = MusicService.get_music(db, music_id)
    if not music:
        raise HTTPException(status_code=404, detail="Music not found")
    return music

@router.post("/generate")
async def generate_music(
    title: str,
    lyrics: str,
    genre: str,
    mood: str,
    instrument_choice: str = None,
    singer_style: str = None,
    tempo: int = None,
    db: Session = Depends(get_db)
):
    """生成音乐"""
    # TODO: 集成MusicGen生成音乐
    # 这里返回一个占位符响应
    return {
        "status": "generating",
        "generation_id": "gen_123456",
        "message": "音乐生成中，请稍候..."
    }

@router.get("/generation/{generation_id}")
async def get_generation_status(generation_id: str):
    """获取生成状态"""
    # TODO: 检查生成任务状态
    return {
        "status": "completed",
        "music_url": "/uploads/generated_music.mp3",
        "video_url": "/uploads/generated_video.mp4"
    }
