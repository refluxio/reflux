# 常见问题

## 拖动进度条后卡死或报错

**症状：** 正常播放没问题，拖动进度条后卡住或报错。

**原因：** 115 CDN 对非顺序 Range 请求返回 403，这是 CDN 节点的策略限制。

**解决：** 确保 `stream.mode` 设为 `buffer`（默认值）。StreamBuffer 在本地缓冲数据，seek 时从缓冲区读取，不向 CDN 发非顺序请求。

```yaml
stream:
  mode: buffer  # 默认值，无需手动设置
```

系统会自动根据驱动类型选择模式：本地磁盘用 direct，云盘用 buffer。

## 115 登录过期

Reflux 会自动保持 115 会话。如果提示过期，在 Web 设置页面重新扫码登录即可。

## DTS/AC3 音频无法播放

浏览器不支持 DTS/AC3 解码。安装 ffmpeg 并启用转码：

```yaml
transcode:
  enabled: true
```

## Infuse 连接后看不到影片

1. 确认扫描已完成（Web 界面能看到影片列表）
2. 确认 TMDB API Key 已配置
3. 确认 115 目录 CID 正确

## Docker 启动后无法访问

1. 检查端口映射：`docker ps` 确认 8096 端口已映射
2. 检查防火墙：确保 8096 端口未被阻止
3. 检查日志：`docker logs reflux`
