"""Chép lời từ file âm thanh/video bằng faster-whisper. Dùng: python transcribe.py FILE [--model M] [--lang vi]"""
import argparse
import sys

from faster_whisper import WhisperModel


def fmt(t: float) -> str:
    return f"{int(t // 60):02d}:{t % 60:05.2f}"


def main() -> None:
    p = argparse.ArgumentParser()
    p.add_argument("file")
    p.add_argument("--model", default="large-v3-turbo", help="tiny|base|small|medium|large-v3|large-v3-turbo")
    p.add_argument("--lang", default=None, help="mã ngôn ngữ, vd vi, en; bỏ trống = tự nhận")
    a = p.parse_args()

    model = WhisperModel(a.model, device="cpu", compute_type="int8")
    segments, info = model.transcribe(a.file, language=a.lang, vad_filter=True)
    print(f"# ngôn ngữ: {info.language} ({info.language_probability:.0%}), dài {fmt(info.duration)}", file=sys.stderr)
    for s in segments:
        print(f"[{fmt(s.start)} - {fmt(s.end)}] {s.text.strip()}")


if __name__ == "__main__":
    main()
