from pydantic_settings import BaseSettings
from typing import Optional

class Settings(BaseSettings):
    # 应用配置
    app_name: str = "Suno AI Music Generator"
    debug: bool = True
    
    # 服务器配置
    host: str = "0.0.0.0"
    port: int = 8000
    
    # 数据库配置
    database_url: str = "sqlite:///./suno_ai.db"
    
    # Redis配置
    redis_url: Optional[str] = None
    
    # CORS配置
    cors_origins: list = ["*"]
    
    # API配置
    api_title: str = "Suno AI API"
    api_version: str = "1.0.0"
    
    # AI模型路径
    musicgen_model: str = "facebook/musicgen-medium"
    stable_diffusion_model: str = "runwayml/stable-diffusion-v1-5"
    
    # 文件存储
    upload_dir: str = "./uploads"
    max_upload_size: int = 500 * 1024 * 1024  # 500MB
    
    class Config:
        env_file = ".env"
        case_sensitive = False

settings = Settings()
