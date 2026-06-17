# Reflux

[![GitHub Release](https://img.shields.io/github/v/release/refluxio/reflux?style=flat-square&logo=github)](https://github.com/refluxio/reflux/releases/latest)
[![Docker Image](https://img.shields.io/badge/docker-ghcr.io%2Frefluxio%2Freflux-2496ED?style=flat-square&logo=docker&logoColor=white)](https://ghcr.io/refluxio/reflux)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)](LICENSE)
[![GitHub Stars](https://img.shields.io/github/stars/refluxio/reflux?style=flat-square&logo=github)](https://github.com/refluxio/reflux)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/refluxio/reflux-deploy?style=flat-square&logo=github)](https://github.com/refluxio/reflux-deploy/commits/main)

English | [中文](README.zh-CN.md)

> Media Fusion Gateway — stream from 115 Cloud, Google Drive, or local disk via Jellyfin / Emby / Infuse / WebDAV

Reflux turns your cloud drive into a private media library. Files stay in the cloud, stream on demand, no download needed.

## Features

- **Jellyfin / Emby Compatible API** — Infuse, VLC, and other players connect natively, no plugins required
- **WebDAV** — Read-only virtual filesystem, browsable from any WebDAV client
- **Multi-Cloud Drivers** — 115 Cloud, Google Drive, local disk (including CloudDrive2 mounts)
- **Smart Pre-buffering** — Instant seek, no stutter
- **Segment Caching** — Hot segments cached locally to save CDN bandwidth (default 10GB)
- **TMDB Metadata** — Auto-match posters, descriptions, ratings, and cast
- **Subtitles** — OpenSubtitles, Shooter, SubHD, local Whisper AI transcription
- **Transcoding** — FFmpeg with hardware acceleration (NVENC / QSV / VAAPI), DTS/AC3 software decoding
- **Multi-user** — Independent accounts, watch history, access control
- **Web UI** — Vue 3 SPA for configuration, scanning, and playback

## Quick Start

### 1. One-liner

```bash
mkdir reflux && cd reflux && curl -sO https://raw.githubusercontent.com/refluxio/reflux-deploy/main/docker-compose.yml -O https://raw.githubusercontent.com/refluxio/reflux-deploy/main/start.sh && chmod +x start.sh && ./start.sh
```

The script automatically tries pulling from GHCR first, falling back to Alibaba Cloud mirror if unavailable. You can also run `docker compose up -d` directly (defaults to GHCR).

### 2. Login to 115

Open `http://your-server:8096` in your browser, go to Settings and scan the QR code to log in to 115 Cloud.

### 3. Connect Players

**Infuse:** Settings → Add Media Library → Jellyfin
- Server: `http://your-server:8096/jellyfin`
- Username / Password: as set in docker-compose.yml

**WebDAV clients:**
- URL: `http://your-server:8096/dav`
- Enable WebDAV in the web Settings page

## Configuration

Configured via environment variables by default, works out of the box. Alternatively, mount a `config.yaml` for file-based config (see [config.example.yaml](config.example.yaml)).

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `REFLUX_IMAGE` | Docker image | `ghcr.io/refluxio/reflux:latest` |
| `REFLUX_AUTH_USERNAME` | Admin username | `admin` |
| `REFLUX_AUTH_PASSWORD` | Admin password | `admin123` |
| `REFLUX_LICENSE_KEY` | Pro license key | — |
| `REFLUX_TMDB_API_KEY` | TMDB API key | — |
| `REFLUX_SCAN_INTERVAL` | Scan interval | `30m` |
| `REFLUX_STREAM_MODE` | Streaming mode | `buffer` |
| `TZ` | Timezone | `Asia/Shanghai` |

### China Mirror

If GHCR is unreachable, use the Alibaba Cloud mirror:

```bash
REFLUX_IMAGE=registry.cn-hangzhou.aliyuncs.com/refluxio/reflux:latest docker compose up -d
```

Or just run `./start.sh` — it falls back automatically.

### Config File (optional)

For fine-grained control, create `config.yaml` and mount it:

```yaml
# Uncomment in docker-compose.yml:
volumes:
  - ./config.yaml:/app/config.yaml:ro
```

See [config.example.yaml](config.example.yaml) for the full reference, including streaming buffer parameters, segment cache, WebDAV, and transcoding options.

### Watchtower Auto-Update

The docker-compose.yml includes Watchtower labels. If you run Watchtower, the image will update automatically.

## Requirements

- Docker (recommended) or Linux / macOS / Windows
- 115 Cloud account (or other supported cloud driver)
- ffmpeg (optional, required for DTS/AC3 audio transcoding)

## Downloads

| Platform | Architecture |
|----------|-------------|
| Docker | `ghcr.io/refluxio/reflux:latest` |
| Linux | x86_64 / ARM64 |
| macOS | Intel / Apple Silicon |
| Windows | x86_64 |

Download binaries from the [Releases](../../releases) page.

## FAQ

**Seeking causes freeze or error?**
115 CDN returns 403 on non-sequential Range requests. Ensure `stream.mode` is set to `buffer` (default).

**115 login expired?**
Re-scan the QR code in the web Settings page. Reflux automatically maintains the session, usually no manual action needed.

**DTS/AC3 audio won't play?**
Browsers don't support DTS/AC3 decoding. Install ffmpeg and enable transcoding: `transcode.enabled: true`

**No media showing in Infuse after connecting?**
Confirm scan is complete, TMDB API key is configured, and the 115 directory CID is correct.

**Docker container not accessible?**
Check port mapping (`docker ps`), firewall, and logs (`docker logs reflux`).

See [FAQ](docs/faq.md) for more.

## License

Configuration files and documentation are under the [MIT License](LICENSE).

The Reflux binary is closed-source. See [Reflux License](https://reflux.show/license).
