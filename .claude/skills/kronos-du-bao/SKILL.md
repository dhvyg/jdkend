---
name: kronos-du-bao
description: >-
  Dự báo chuỗi nến giá (OHLCV) bằng Kronos, model mã nguồn mở của Đại học Thanh Hoa cho thị trường tài chính: cài bản chạy CPU,
  chạy Kronos-mini, chuẩn bị dữ liệu, đọc kết quả và TỰ KIỂM bằng so sánh với "giữ nguyên giá cuối" trước khi tin. Dùng khi người dùng nói
  "Kronos", "dự báo nến", "dự báo giá cổ phiếu bằng AI", "foundation model tài chính", "thử mô hình dự báo K-line".
---

# Kronos: dự báo nến giá bằng CPU

Kronos (https://github.com/shiyu-coder/Kronos, giấy phép MIT, khoảng 47.900 sao, cập nhật 13/4/2026) là model đọc chuỗi nến (open, high, low, close, volume, amount) rồi sinh ra các nến tiếp theo. **Không phải skill**: là mã Python/PyTorch, trọng số tải từ Hugging Face. Không phải lời khuyên mua bán.

## Đã chạy thật (18/11/2026, máy cloud 4 CPU, 15GB RAM, không GPU)
- Cài torch bản CPU (2.15) và thư viện: venv `~/.venvs/kronos` khoảng 1,2GB.
- **Kronos-mini** (4,1 triệu tham số, nhìn tối đa 2048 nến) tải và nạp mất khoảng 3 giây; dự báo 60 nến mất khoảng 1,3 giây mỗi đường, nên 1 đường là chuyện vài giây trên CPU.
- Thử trên 30 đoạn ngẫu nhiên của dữ liệu 5 phút cổ phiếu Alibaba (HK, nằm trong repo `finetune_csv/data`), mỗi đoạn nhìn 400 nến, dự báo 60 nến, `sample_count=3`:
  - Sai số trung bình giá đóng cửa: **model 1,152% so với 1,235% nếu chỉ giữ nguyên giá cuối** (tốt hơn 7%, thắng ở 17/30 đoạn).
  - Đoán đúng hướng giá ở nến cuối: **21/30 (70%)**.
- Kết luận trung thực: **chưa đủ để tin**. Chỉ 30 đoạn, một mã, dữ liệu có thể đã nằm trong dữ liệu huấn luyện của Kronos (chưa kiểm), chưa tính phí giao dịch hay trượt giá. Một lần thử khác (một đoạn, 10 đường lấy trung bình) cho sai số bằng đúng "giữ nguyên giá cuối".

## Cài (lần đầu)
```bash
git clone https://github.com/shiyu-coder/Kronos          # vào thư mục riêng, mới
python3 -m venv ~/.venvs/kronos
~/.venvs/kronos/bin/pip install --index-url https://download.pytorch.org/whl/cpu torch
~/.venvs/kronos/bin/pip install numpy pandas einops==0.8.1 huggingface_hub==0.33.1 matplotlib tqdm safetensors
```
Có card Nvidia thì cài torch bản CUDA theo hướng dẫn của PyTorch và để `device` tự chọn. Mã `model/` của repo tôi đã đọc: không có `eval`, `exec`, `subprocess`, `pickle`; trọng số dùng `safetensors`. Các script `examples/get_*` có gọi mạng và `pip install`: không chạy khi chưa đọc.

## Chọn model (theo README)
| Model | Tokenizer | Nhìn tối đa | Tham số |
|---|---|---|---|
| Kronos-mini | `NeoQuasar/Kronos-Tokenizer-2k` | 2048 nến | 4,1M |
| Kronos-small | `NeoQuasar/Kronos-Tokenizer-base` | 512 | 24,7M |
| Kronos-base | `NeoQuasar/Kronos-Tokenizer-base` | 512 | 102,3M |

Kronos-large không công khai. Trên CPU bắt đầu bằng mini; small/base chậm hơn, tôi chưa đo.

## Chạy (đã chạy đúng đoạn này)
```python
import sys; sys.path.insert(0, "/đường/dẫn/Kronos")
from model import Kronos, KronosTokenizer, KronosPredictor
tok = KronosTokenizer.from_pretrained("NeoQuasar/Kronos-Tokenizer-2k")
mdl = Kronos.from_pretrained("NeoQuasar/Kronos-mini")
pred = KronosPredictor(mdl, tok, device="cpu", max_context=2048)   # small/base: max_context=512
out = pred.predict(df=x_df, x_timestamp=x_ts, y_timestamp=y_ts, pred_len=60,
                   T=1.0, top_p=0.9, sample_count=3, verbose=False)
```
- `x_df`: bảng có cột `open, high, low, close` (thêm `volume`, `amount` nếu có), đã sắp theo thời gian; `x_ts`: thời điểm của từng dòng; `y_ts`: thời điểm các nến cần dự báo (cùng khoảng cách nến).
- `sample_count`: số đường sinh ra rồi lấy trung bình; nhiều đường thì ra trơn hơn nhưng không tự đúng hơn, và chạy lâu tỉ lệ thuận (10 đường mất khoảng 11 giây).
- Nhiều chuỗi một lúc: `predict_batch`, các chuỗi phải cùng độ dài lịch sử và cùng `pred_len`.
- Chạy bằng `python -I` và thêm đường dẫn repo trong code như trên, để tránh nạp nhầm file lạ ở thư mục hiện tại.

## Cách tự kiểm trước khi tin (bắt buộc)
1. Chia dữ liệu: dự báo cho đoạn **đã xảy ra** (giấu phần sau), rồi so với giá thật.
2. So với mốc **"giữ nguyên giá cuối"** (sai số nếu đoán giá không đổi) và với hướng đúng/sai. Model không hơn mốc này thì bỏ.
3. Làm trên **nhiều đoạn, nhiều mã, nhiều khung giờ**, không chỉ một đoạn đẹp. Đoạn dữ liệu nằm sau ngày huấn luyện của model mới sạch; ngày huấn luyện tôi chưa xác minh.
4. Tính phí và trượt giá trước khi nói "có lãi". Dự báo giá chưa phải chiến lược giao dịch.
5. Ghi rõ kết quả và giới hạn cho người dùng. Không đưa lời khuyên mua/bán; có thể dùng cùng `trader-risk` (cỡ lệnh theo mức lỗ tối đa) và `trader-timemachine` (chạy lại kịch bản), chỉ giao dịch giả lập.

## Chưa kiểm
Tinh chỉnh (finetune), Kronos-small/base trên CPU, kết quả trên mã khác, giao diện web (`webui`), các script `examples/` khác. README tự ghi pipeline tinh chỉnh chỉ để minh họa, không phải hệ giao dịch hoàn chỉnh.
