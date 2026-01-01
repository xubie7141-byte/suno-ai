import torch
import torchaudio
from transformers import AutoProcessor, MusicgenForConditionalGeneration
import logging

logger = logging.getLogger(__name__)

class MusicGenerationService:
    """音乐生成服务 - 使用MusicGen模型"""
    
    def __init__(self, model_name: str = "facebook/musicgen-medium"):
        self.model_name = model_name
        self.device = "cuda" if torch.cuda.is_available() else "cpu"
        self.model = None
        self.processor = None
        self._load_model()
    
    def _load_model(self):
        """加载MusicGen模型"""
        try:
            logger.info(f"Loading model {self.model_name} on device {self.device}")
            self.processor = AutoProcessor.from_pretrained(self.model_name)
            self.model = MusicgenForConditionalGeneration.from_pretrained(self.model_name)
            self.model = self.model.to(self.device)
            logger.info("Model loaded successfully")
        except Exception as e:
            logger.error(f"Error loading model: {e}")
            raise
    
    async def generate_music(
        self,
        description: str,
        duration: int = 30,
        temperature: float = 1.0,
        top_k: int = 250,
        top_p: float = 0.0
    ) -> dict:
        """
        生成音乐
        
        Args:
            description: 音乐描述文本
            duration: 生成时长（秒）
            temperature: 温度参数（控制随机性）
            top_k: Top-K采样参数
            top_p: Top-P采样参数
        
        Returns:
            生成的音乐信息
        """
        try:
            # 准备输入
            inputs = self.processor(
                text=[description],
                padding=True,
                return_tensors="pt",
            )
            
            # 移到设备
            inputs = {k: v.to(self.device) for k, v in inputs.items()}
            
            # 生成音乐
            with torch.no_grad():
                audio_values = self.model.generate(
                    **inputs,
                    max_new_tokens=int(duration * 50),  # 大约50个token每秒
                    do_sample=True,
                    top_k=top_k,
                    top_p=top_p,
                    temperature=temperature,
                )
            
            # 处理输出
            sampling_rate = self.model.config.sample_rate
            
            return {
                "audio_data": audio_values.cpu().numpy(),
                "sampling_rate": sampling_rate,
                "duration": duration,
            }
        except Exception as e:
            logger.error(f"Error generating music: {e}")
            raise
    
    def save_audio(self, audio_data, sampling_rate: int, file_path: str):
        """保存音频文件"""
        try:
            import numpy as np
            audio_tensor = torch.from_numpy(np.array(audio_data)).float()
            torchaudio.save(file_path, audio_tensor, sampling_rate)
            logger.info(f"Audio saved to {file_path}")
        except Exception as e:
            logger.error(f"Error saving audio: {e}")
            raise
