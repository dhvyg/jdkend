"""Chép lời từ file âm thanh/video bằng faster-whisper. Dùng: python transcribe.py FILE [--model M] [--lang vi]"""
import argparse
import sys

from faster_whisper import WhisperModel


def fmt(t: float) -> str:
    return f"{int(t // 60):02d}:{t % 60:05.2f}"


def srt_time(t: float) -> str:
    ms = round(t * 1000)
    return f"{ms // 3600000:02d}:{ms // 60000 % 60:02d}:{ms // 1000 % 60:02d},{ms % 1000:03d}"


assert srt_time(3725.5) == "01:02:05,500"


def main() -> None:
    p = argparse.ArgumentParser()
    p.add_argument("file")
    p.add_argument("--model", default="large-v3-turbo", help="tiny|base|small|medium|large-v3|large-v3-turbo")
    p.add_argument("--lang", default=None, help="mã ngôn ngữ, vd vi, en; bỏ trống = tự nhận")
    p.add_argument("--srt", action="store_true", help="in ra phụ đề định dạng SRT")
    a = p.parse_args()

    model = WhisperModel(a.model, device="cpu", compute_type="int8")
    segments, info = model.transcribe(a.file, language=a.lang, vad_filter=True)
    print(f"# ngôn ngữ: {info.language} ({info.language_probability:.0%}), dài {fmt(info.duration)}", file=sys.stderr)
    for i, s in enumerate(segments, 1):
        if a.srt:
            print(f"{i}\n{srt_time(s.start)} --> {srt_time(s.end)}\n{s.text.strip()}\n")
        else:
            print(f"[{fmt(s.start)} - {fmt(s.end)}] {s.text.strip()}")


if __name__ == "__main__":
    main()
