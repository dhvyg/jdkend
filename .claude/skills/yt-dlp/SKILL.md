---
name: yt-dlp
description: Download video or audio, subtitles, or metadata from YouTube and 1,000+ other sites with the yt-dlp CLI (github.com/yt-dlp/yt-dlp). Use when the user asks to download a video, extract MP3 audio, grab subtitles/transcript, or list a video's formats.
---

# yt-dlp

1. Check it is installed: `yt-dlp --version`. If not: `pipx install yt-dlp` (or `python3 -m pip install -U yt-dlp`). Merging video+audio and converting to MP3 needs `ffmpeg`.
2. Pick the command:
   - Best quality video: `yt-dlp "<url>"`
   - MP4 up to 1080p: `yt-dlp -f "bv*[height<=1080][ext=mp4]+ba[ext=m4a]/b[ext=mp4]" "<url>"`
   - Audio as MP3: `yt-dlp -x --audio-format mp3 "<url>"`
   - Subtitles only: `yt-dlp --skip-download --write-subs --write-auto-subs --sub-langs "vi,en" "<url>"`
   - List formats: `yt-dlp -F "<url>"`; metadata: `yt-dlp -j "<url>"`
   - Playlist: add `-o "%(playlist_index)s - %(title)s.%(ext)s"`; one item only: `--no-playlist`
3. Always quote the URL. Save into the folder the user wants (`-P <dir>`).
4. If a site errors, update first (`yt-dlp -U` or reinstall); for login-only content use `--cookies-from-browser <browser>` only when the user asks.

Only download content the user has the right to download. Respect the site's terms and copyright.
