---
name: media
description: Xử lý media — ffprobe thông số, ffmpeg cắt/ghép/transcode/GIF, trích frame, tách audio, phụ đề (shift/convert/burn), timecode SMPTE, phát hiện shot, OCR frame/ảnh, tải từ URL (yt-dlp), nhạc (thể loại/mood/BPM/lyrics). Dùng khi đưa video/audio/ảnh/URL media và muốn tóm tắt nội dung, trích text, cắt ghép, làm phụ đề, lấy khung hình, hoặc tải xuống.
license: MIT
metadata:
  audience: media processing
  origin: custom
---

> Bản tiếng Anh: [`SKILL.en.md`](SKILL.en.md)

# media — video / audio / ảnh / URL

Skill mỏng, **không có code riêng**: route tới CLI local (`ffprobe`, `ffmpeg`, `yt-dlp`) và skill bên thứ ba tải theo phiên (mediaskills, `watch`, `music-listener`) — xem mục fetch bên dưới.

## Bảng route theo loại input

Nhận diện bằng `ffprobe`/`file`; URL thì tra tên file trả về.

|Input + nhu cầu|Công cụ|Ghi chú|
|---|---|---|
|Thông số file media|`ffprobe` (local)|không cần skill phiên|
|Video/URL muốn tóm tắt nội dung|skill `watch` (claude-video)|`--engine local`|
|Video/URL trích text (SRT/VTT)|skill `speech-captions`|`transcribe.py --model tiny`; model lớn khi tai to|
|Phụ đề: shift/convert/burn|skill `subtitles`|`shift.py` `convert.py` `extract.py` `burn.py`|
|Cắt/ghép/transcode, GIF, frame/audio|skill `video-transformation`|`trim.py` `trim_multi.py` `concat.py` …|
|Phát hiện cắt/chuyển shot|skill `shots`|`detect.py` `extract-frames.py`|
|Phân tích nội dung frame (text trên màn hình)|skill `vision-analysis`|agent tự xem frame + script merge JSON|
|Ảnh/ảnh chụp màn hình: OCR/resize/convert|skill `image`|`ocr.py` (tesseract)|
|Audio: trim/normalize/silence|skill `audio`||
|Nghe nhạc từ URL/file, muốn lời|skill `music-listener`|fetch theo phiên, xem `music-listener/scripts/`|
|Tải media từ URL|skill `download`|`url.py` (yt-dlp)|
|Timecode SMPTE, broadcast captions|skill `timecode`, `skill captions-compliance`|đồng bộ caption theo TC|
|Thiếu ffprobe/tesseract/uv…|skill `install-media-tools`|`doctor.sh` kiểm tra, `install.sh` cài|

## Skill bên thứ ba theo phiên (fetch, không cài vĩnh viễn)

Repo này **không chứa** skill bên thứ ba. Tải về session temp:

1. `scripts/fetch-session.sh --list` → xem tên; `--skill <tên>` hoặc `--all` — script sparse-clone repo nguồn đúng commit SHA, copy vào session temp.
2. Dùng tại `~/.agents/skills/<tên>/scripts/` (hoặc `~/.config/opencode/skills/<tên>/…`).
3. Offline/mất mạng: thao tác trên file local chạy được nếu CLI và model cần thiết đã sẵn sàng. Tải skill theo phiên, tải URL và tải model chưa cache cần mạng; `yt-dlp` không tải URL khi offline.

Commit SHA + license của từng skill: bảng `TABLE` trong `scripts/fetch-session.sh`.

## Quy tắc

1. **Output đặt cạnh nguồn**: tóm tắt `<tên>.digest.md`, phụ đề `<tên>.srt|.vtt`, clip `<tên>.clip-<t1>-<t2>.mp4`. Không ghi đè file gốc.
2. **Timestamp/clip dùng frame thật** — kiểm tra bằng `ffprobe`, không ước lượng.
3. **Verify trước khi giao**: `ffprobe` file output phải mở được, thời lượng/codec đúng yêu cầu.
4. **Nhắc ngôn ngữ input** — trả lời cùng ngôn ngữ người dùng nói.
