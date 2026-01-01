from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.db.database import get_db
from app.services.music_service import FavoriteService
from typing import List

router = APIRouter(prefix="/api/favorites", tags=["favorites"])

@router.get("/")
async def get_favorites(
    page: int = 1,
    page_size: int = 20,
    user_id: str = None,
    db: Session = Depends(get_db)
):
    """获取收藏列表"""
    if not user_id:
        raise HTTPException(status_code=401, detail="User not authenticated")
    
    skip = (page - 1) * page_size
    favorites = FavoriteService.get_user_favorites(db, user_id, skip, page_size)
    return {"data": favorites, "total": len(favorites)}

@router.post("/")
async def add_favorite(
    music_id: str,
    user_id: str = None,
    db: Session = Depends(get_db)
):
    """添加收藏"""
    if not user_id:
        raise HTTPException(status_code=401, detail="User not authenticated")
    
    favorite = FavoriteService.add_favorite(db, user_id, music_id)
    return {"status": "success", "favorite_id": favorite.id}

@router.delete("/{music_id}")
async def remove_favorite(
    music_id: str,
    user_id: str = None,
    db: Session = Depends(get_db)
):
    """删除收藏"""
    if not user_id:
        raise HTTPException(status_code=401, detail="User not authenticated")
    
    FavoriteService.remove_favorite(db, user_id, music_id)
    return {"status": "success"}
