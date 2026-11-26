---
name: harness-engineering
description: Hướng dẫn "harness engineering" của Ryan Lopopolo — cách làm cho repo/môi trường dạy agent (Claude Code) chạy tốt hơn bằng cách cải thiện ngữ cảnh (context) và công cụ (tools), thay vì đổi model. Dùng khi người dùng muốn thiết lập repo cho AI, viết CLAUDE.md/AGENTS.md, cải thiện chất lượng agent, review hay dọn giàn đỡ (harness) của một dự án.
license: CC BY 4.0
---

# Harness Engineering

Bộ tài liệu của Ryan Lopopolo (CC BY 4.0) về cách cải thiện kết quả của coding agent bằng cách
định hình **môi trường** quanh nó — giữ nguyên model, chỉ chỉnh hai đòn bẩy: **context** và **tools**.

Khi làm việc liên quan tới thiết lập repo cho AI, viết `CLAUDE.md`/`AGENTS.md`, hay nâng chất lượng
agent, hãy đọc tài liệu trong thư mục `docs/` của skill này rồi áp dụng. Mỗi thư mục con là một chủ đề:

| Chủ đề (`docs/<tên>`) | Ý chính |
|---|---|
| domain-modeling | Đưa yêu cầu phi chức năng vào code để agent lấy lại được |
| just-in-time-context | Đưa đúng ngữ cảnh vào đúng lúc, không nhồi hết |
| tool-legibility | Công cụ dễ hiểu, dễ gọi đúng |
| authority | Tôn trọng nguồn sự thật, phân quyền |
| proof | Bắt agent chứng minh kết quả (test, kiểm tra) |
| lineage | Lần vết quyết định, để lần chạy sau tốt hơn |
| feedback | Vòng phản hồi để agent tự sửa |
| effectiveness, durable-systems, continuous-maintenance, fixed-worker, whole-job, last-mile-deployment | Các khía cạnh còn lại của giàn đỡ |

## Playbook có sẵn
- `playbooks/repository-review.md`: soát một repo theo góc nhìn harness.
- `playbooks/improve-harness.md`: các bước cải thiện giàn đỡ.

Đây là **tài liệu tham khảo**, không phải công cụ chạy. Nguồn gốc: https://github.com/lopopolo/harness-engineering
