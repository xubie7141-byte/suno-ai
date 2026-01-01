import torch
from diffusers import StableDiffusionPipeline
import logging

logger = logging.getLogger(__name__)

class ImageGenerationService:
    """图像生成服务 - 使用Stable Diffusion"""
    
    def __init__(self, model_name: str = "runwayml/stable-diffusion-v1-5"):
        self.model_name = model_name
        self.device = "cuda" if torch.cuda.is_available() else "cpu"
        self.pipeline = None
        self._load_model()
    
    def _load_model(self):
        """加载Stable Diffusion模型"""
        try:
            logger.info(f"Loading model {self.model_name}")
            self.pipeline = StableDiffusionPipeline.from_pretrained(
                self.model_name,
                torch_dtype=torch.float16 if torch.cuda.is_available() else torch.float32
            )
            self.pipeline = self.pipeline.to(self.device)
            logger.info("Model loaded successfully")
        except Exception as e:
            logger.error(f"Error loading model: {e}")
            raise
    
    async def generate_image(
        self,
        prompt: str,
        num_inference_steps: int = 50,
        guidance_scale: float = 7.5,
        height: int = 512,
        width: int = 512
    ) -> dict:
        """
        生成图像
        
        Args:
            prompt: 文本描述
            num_inference_steps: 推理步数
            guidance_scale: 引导尺度
            height: 图像高度
            width: 图像宽度
        
        Returns:
            生成的图像
        """
        try:
            image = self.pipeline(
                prompt,
                height=height,
                width=width,
                num_inference_steps=num_inference_steps,
                guidance_scale=guidance_scale,
            ).images[0]
            
            return {
                "image": image,
                "prompt": prompt,
            }
        except Exception as e:
            logger.error(f"Error generating image: {e}")
            raise
    
    def save_image(self, image, file_path: str):
        """保存图像"""
        try:
            image.save(file_path)
            logger.info(f"Image saved to {file_path}")
        except Exception as e:
            logger.error(f"Error saving image: {e}")
            raise
