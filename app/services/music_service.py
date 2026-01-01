from sqlalchemy.orm import Session
from app.models.database import Music, Favorite
from app.schemas.schemas import Music as MusicSchema
from uuid import uuid4
from datetime import datetime

class MusicService:
    """音乐服务"""
    
    @staticmethod
    def get_music(db: Session, music_id: str) -> Music:
        """获取单个音乐"""
        return db.query(Music).filter(Music.id == music_id).first()
    
    @staticmethod
    def get_musics(
        db: Session,
        skip: int = 0,
        limit: int = 20,
        genre: str = None,
        mood: str = None,
        sort_by: str = "created_at"
    ) -> list:
        """获取音乐列表"""
        query = db.query(Music)
        
        if genre:
            query = query.filter(Music.genre == genre)
        if mood:
            query = query.filter(Music.mood == mood)
        
        if sort_by == "popular":
            query = query.order_by(Music.likes.desc())
        elif sort_by == "recent":
            query = query.order_by(Music.created_at.desc())
        
        return query.offset(skip).limit(limit).all()
    
    @staticmethod
    def create_music(db: Session, music_data: dict, user_id: str = None) -> Music:
        """创建音乐记录"""
        music = Music(
            id=str(uuid4()),
            title=music_data.get("title"),
            artist=music_data.get("artist"),
            description=music_data.get("description"),
            lyrics=music_data.get("lyrics"),
            cover_image_url=music_data.get("cover_image_url"),
            music_url=music_data.get("music_url"),
            video_url=music_data.get("video_url"),
            genre=music_data.get("genre"),
            mood=music_data.get("mood"),
            duration=music_data.get("duration", 0),
            user_id=user_id,
            is_local_generation=music_data.get("is_local_generation", False),
            created_at=datetime.utcnow()
        )
        db.add(music)
        db.commit()
        db.refresh(music)
        return music
    
    @staticmethod
    def update_music(db: Session, music_id: str, music_data: dict) -> Music:
        """更新音乐信息"""
        music = db.query(Music).filter(Music.id == music_id).first()
        if music:
            for key, value in music_data.items():
                if hasattr(music, key):
                    setattr(music, key, value)
            music.updated_at = datetime.utcnow()
            db.commit()
            db.refresh(music)
        return music


class FavoriteService:
    """收藏服务"""
    
    @staticmethod
    def add_favorite(db: Session, user_id: str, music_id: str) -> Favorite:
        """添加收藏"""
        favorite = Favorite(
            id=str(uuid4()),
            user_id=user_id,
            music_id=music_id,
            created_at=datetime.utcnow()
        )
        db.add(favorite)
        db.commit()
        db.refresh(favorite)
        return favorite
    
    @staticmethod
    def remove_favorite(db: Session, user_id: str, music_id: str):
        """删除收藏"""
        db.query(Favorite).filter(
            Favorite.user_id == user_id,
            Favorite.music_id == music_id
        ).delete()
        db.commit()
    
    @staticmethod
    def get_user_favorites(db: Session, user_id: str, skip: int = 0, limit: int = 20):
        """获取用户收藏列表"""
        return db.query(Music).join(
            Favorite, Music.id == Favorite.music_id
        ).filter(
            Favorite.user_id == user_id
        ).offset(skip).limit(limit).all()
    
    @staticmethod
    def is_favorite(db: Session, user_id: str, music_id: str) -> bool:
        """检查是否收藏"""
        return db.query(Favorite).filter(
            Favorite.user_id == user_id,
            Favorite.music_id == music_id
        ).first() is not None
