from transformers import pipeline, AutoTokenizer, AutoModelForCausalLM
import logging

logger = logging.getLogger(__name__)

class CopywritingService:
    """文案生成服务 - 使用GPT类模型"""
    
    def __init__(self):
        self.model_name = "gpt2"  # 可以替换为更大的模型
        self.tokenizer = None
        self.model = None
        self._load_model()
    
    def _load_model(self):
        """加载文案生成模型"""
        try:
            logger.info(f"Loading copywriting model {self.model_name}")
            self.tokenizer = AutoTokenizer.from_pretrained(self.model_name)
            self.model = AutoModelForCausalLM.from_pretrained(self.model_name)
            logger.info("Model loaded successfully")
        except Exception as e:
            logger.error(f"Error loading model: {e}")
    
    async def generate_copywriting(
        self,
        copywriting_type: str,
        product_name: str,
        description: str = None,
        max_length: int = 200
    ) -> dict:
        """
        生成营销文案
        
        Args:
            copywriting_type: 文案类型 (广告、社媒、产品、邮件)
            product_name: 产品名称
            description: 产品描述
            max_length: 最大长度
        
        Returns:
            生成的文案
        """
        try:
            # 构建提示词
            prompt = self._build_prompt(copywriting_type, product_name, description)
            
            # 生成文案
            inputs = self.tokenizer.encode(prompt, return_tensors="pt")
            outputs = self.model.generate(
                inputs,
                max_length=max_length,
                num_return_sequences=1,
                temperature=0.7,
                top_p=0.9,
                do_sample=True,
            )
            
            copywriting = self.tokenizer.decode(outputs[0], skip_special_tokens=True)
            
            return {
                "copywriting": copywriting,
                "copywriting_type": copywriting_type,
                "product_name": product_name,
                "length": len(copywriting),
            }
        except Exception as e:
            logger.error(f"Error generating copywriting: {e}")
            raise
    
    def _build_prompt(self, copywriting_type: str, product_name: str, description: str = None):
        """构建提示词"""
        prompts = {
            "广告": f"写一个关于{product_name}的广告文案，需要吸引消费者：",
            "社媒": f"为{product_name}写一条社交媒体文案，要求简洁有趣：",
            "产品": f"为产品{product_name}写一个产品描述，突出特点和优势：",
            "邮件": f"为{product_name}写一封营销邮件的主题行和开头：",
        }
        base_prompt = prompts.get(copywriting_type, prompts["广告"])
        if description:
            base_prompt += f"\n产品详情：{description}"
        return base_prompt
