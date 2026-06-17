# Reflux

[![GitHub Release](https://img.shields.io/github/v/release/refluxio/reflux?style=flat-square&logo=github)](https://github.com/refluxio/reflux/releases/latest)
[![Docker Image](https://img.shields.io/badge/docker-ghcr.io%2Frefluxio%2Freflux-2496ED?style=flat-square&logo=docker&logoColor=white)](https://ghcr.io/refluxio/reflux)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)](LICENSE)
[![GitHub Stars](https://img.shields.io/github/stars/refluxio/reflux?style=flat-square&logo=github)](https://github.com/refluxio/reflux)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/refluxio/reflux-deploy?style=flat-square&logo=github)](https://github.com/refluxio/reflux-deploy/commits/main)

[English](README.md) | 中文

> 媒体融合网关 — 统一接入 115 网盘、Google Drive、本地磁盘，通过 Jellyfin / Emby / Infuse / WebDAV 串流播放

Reflux 把你的网盘变成私人影视库。文件留在云端，按需串流，无需下载。

## 功能

- **Jellyfin / Emby 兼容 API** — Infuse、VLC 等播放器直连，无需插件
- **WebDAV** — 只读虚拟文件系统，任意 WebDAV 客户端均可浏览
- **多云驱动** — 115 网盘、Google Drive、本地磁盘（含 CloudDrive2 挂载）
- **智能预缓冲** — 拖动进度条秒跳转，不卡顿
- **分段缓存** — 热门片段本地缓存，节省 CDN 流量（默认 10GB）
- **TMDB 元数据** — 自动匹配海报、简介、评分、演员
- **字幕** — OpenSubtitles、射手网、SubHD、Whisper 本地 AI 转写
- **转码** — FFmpeg 硬件加速（NVENC / QSV / VAAPI），DTS/AC3 软解
- **多用户** — 独立账户、观看记录、权限控制
- **Web 管理界面** — Vue 3 SPA，配置、扫描、播放一体

## 快速开始

### 1. 一键启动

```bash
mkdir reflux && cd reflux && curl -sO https://raw.githubusercontent.com/refluxio/reflux-deploy/main/docker-compose.yml -O https://raw.githubusercontent.com/refluxio/reflux-deploy/main/start.sh && chmod +x start.sh && ./start.sh
```

脚本会自动尝试拉取 GHCR 镜像，如果失败则 fallback 到国内阿里云镜像。也可以直接 `docker compose up -d`（默认走 GHCR）。

### 2. 登录 115

浏览器打开 `http://your-server:8096`，进入设置页面扫码登录 115 网盘。

### 3. 连接播放器

**Infuse：** 设置 → 添加媒体库 → Jellyfin
- 服务器：`http://your-server:8096/jellyfin`
- 用户名 / 密码：docker-compose.yml 中设置的

**WebDAV 客户端：**
- 地址：`http://your-server:8096/dav`
- 需在 Web 设置页面启用 WebDAV

## 配置

默认通过环境变量配置，开箱即用。也可挂载 `config.yaml` 使用文件配置（参见 [config.example.yaml](config.example.yaml)）。

### 环境变量

| 变量 | 说明 | 默认值 |
|------|------|--------|
| `REFLUX_IMAGE` | Docker 镜像地址 | `ghcr.io/refluxio/reflux:latest` |
| `REFLUX_AUTH_USERNAME` | 管理员用户名 | `admin` |
| `REFLUX_AUTH_PASSWORD` | 管理员密码 | `admin123` |
| `REFLUX_LICENSE_KEY` | Pro 许可证密钥 | — |
| `REFLUX_TMDB_API_KEY` | TMDB API Key | — |
| `REFLUX_SCAN_INTERVAL` | 扫描间隔 | `30m` |
| `REFLUX_STREAM_MODE` | 流媒体模式 | `buffer` |
| `TZ` | 时区 | `Asia/Shanghai` |

### 国内镜像

如果 GHCR 访问困难，可使用阿里云镜像：

```bash
REFLUX_IMAGE=registry.cn-hangzhou.aliyuncs.com/refluxio/reflux:latest docker compose up -d
```

或直接运行 `./start.sh`，会自动 fallback。

### 配置文件（可选）

如需更精细的控制，可创建 `config.yaml` 并挂载：

```yaml
# docker-compose.yml 中取消注释：
volumes:
  - ./config.yaml:/app/config.yaml:ro
```

完整配置参见 [config.example.yaml](config.example.yaml)，包含流媒体缓冲参数、分段缓存、WebDAV、转码等选项。

## 下载

| 平台 | 架构 |
|------|------|
| Docker | `ghcr.io/refluxio/reflux:latest` |
| Linux | x86_64 / ARM64 |
| macOS | Intel / Apple Silicon |
| Windows | x86_64 |

从 [Releases](../../releases) 页面下载二进制文件。

## 常见问题

**拖动进度条后卡死或报错？**
115 CDN 对非顺序 Range 请求返回 403。确保 `stream.mode` 设为 `buffer`（默认值）。

**115 登录过期？**
在 Web 设置页面重新扫码登录。Reflux 会自动保持会话，通常无需手动操作。

**DTS/AC3 音频无法播放？**
浏览器不支持 DTS/AC3 解码。安装 ffmpeg 并启用转码：`transcode.enabled: true`

**Infuse 连接后看不到影片？**
确认扫描已完成、TMDB API Key 已配置、115 目录 CID 正确。

**Docker 启动后无法访问？**
检查端口映射（`docker ps`）、防火墙、日志（`docker logs reflux`）。

更多问题参见 [FAQ](docs/faq.md)。

## 许可证

配置文件和文档使用 [MIT License](LICENSE)。

Reflux 二进制为闭源软件，详见 [Reflux License](https://reflux.show/license)。
