from fastapi import APIRouter, HTTPException
from app.services.avatar_service import AvatarService
from app.services.copywriting_service import CopywritingService
from app.services.video_service import VideoGenerationService
from app.services.image_generation import ImageGenerationService
from app.services.ppt_service import PptService

router = APIRouter(prefix="/api/ai-tools", tags=["ai-tools"])

# 初始化服务
avatar_service = AvatarService()
copywriting_service = CopywritingService()
video_service = VideoGenerationService()
image_service = ImageGenerationService()
ppt_service = PptService()

# ============ AI数字人 ============
@router.post("/avatar/create")
async def create_avatar(
    avatar_type: str,
    voice_style: str,
    name: str = None
):
    """创建虚拟形象"""
    try:
        result = await avatar_service.create_avatar(avatar_type, voice_style, name)
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/avatar/generate-video")
async def generate_avatar_video(
    avatar_id: str,
    script: str,
    audio_url: str = None
):
    """生成虚拟形象视频"""
    try:
        result = await avatar_service.generate_avatar_video(avatar_id, script, audio_url)
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# ============ AI文案 ============
@router.post("/copywriting/generate")
async def generate_copywriting(
    copywriting_type: str,
    product_name: str,
    description: str = None
):
    """生成营销文案"""
    try:
        result = await copywriting_service.generate_copywriting(
            copywriting_type, product_name, description
        )
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# ============ AI视频 ============
@router.post("/video/generate")
async def generate_video(
    video_type: str,
    script: str,
    duration: int = 30
):
    """生成视频"""
    try:
        result = await video_service.generate_video(video_type, script, duration)
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# ============ AI绘画 ============
@router.post("/image/generate")
async def generate_image(
    prompt: str,
    style: str = "realistic"
):
    """生成图片"""
    try:
        result = await image_service.generate_image(
            prompt=prompt,
            num_inference_steps=50,
            guidance_scale=7.5
        )
        return {
            "status": "generated",
            "prompt": prompt,
            "style": style,
            "image_url": "/uploads/generated_image.png",
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# ============ AI PPT ============
@router.post("/ppt/generate")
async def generate_ppt(
    topic: str,
    slide_count: int = 10,
    outline: str = None
):
    """生成PPT演示文稿"""
    try:
        result = await ppt_service.generate_ppt(topic, slide_count, outline or "")
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# ============ 系统 ============
@router.get("/status")
async def get_status():
    """获取AI工具状态"""
    return {
        "avatar": "ready",
        "copywriting": "ready",
        "video": "ready",
        "image": "ready",
        "ppt": "ready",
    }
