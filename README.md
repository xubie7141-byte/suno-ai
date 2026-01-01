# Suno AI Backend - FastAPI

这是Suno AI音乐生成平台的后端服务。

## 功能特性

- ✅ 集成MusicGen进行本地AI音乐生成
- ✅ Stable Diffusion图像生成（专辑封面等）
- ✅ RESTful API接口
- ✅ SQLite本地数据库
- ✅ 用户收藏管理
- ✅ 音乐生成历史记录

## 安装

### 环境需求
- Python 3.8+
- CUDA 11.0+ (可选，用于GPU加速)

### 安装依赖

```bash
pip install -r requirements.txt
```

## 快速开始

### 1. 启动后端服务

```bash
python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

或

```bash
python app/main.py
```

### 2. 访问API文档

- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## API 端点

### 音乐相关
- `GET /api/music` - 获取音乐列表
- `GET /api/music/{music_id}` - 获取单个音乐
- `POST /api/music/generate` - 生成音乐
- `GET /api/music/generation/{generation_id}` - 获取生成状态

### 收藏管理
- `GET /api/favorites` - 获取收藏列表
- `POST /api/favorites` - 添加收藏
- `DELETE /api/favorites/{music_id}` - 删除收藏

## 配置

编辑 `.env` 文件进行配置：

```env
APP_NAME=Suno AI Music Generator
DEBUG=True
DATABASE_URL=sqlite:///./suno_ai.db
MUSICGEN_MODEL=facebook/musicgen-medium
```

## 项目结构

```
app/
├── main.py              # FastAPI应用入口
├── config.py            # 配置文件
├── models/
│   └── database.py      # 数据库模型
├── schemas/
│   └── schemas.py       # Pydantic数据模型
├── services/
│   ├── music_generation.py    # MusicGen服务
│   ├── image_generation.py    # Stable Diffusion服务
│   └── music_service.py       # 音乐业务逻辑
├── routes/
│   ├── music.py         # 音乐API
│   └── favorites.py     # 收藏API
└── db/
    └── database.py      # 数据库连接
```

## 开发说明

### 添加新的API端点

1. 在 `app/routes/` 中创建新文件
2. 定义路由和处理函数
3. 在 `app/main.py` 中导入并注册路由

### 扩展生成功能

MusicGen和Stable Diffusion的集成在 `app/services/` 中。可以添加更多的AI模型和生成功能。

## 许可证

MIT
