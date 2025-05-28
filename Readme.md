# Built Job for Talend

Các job viết bằng Talend cần được build sang .jar để chạy.

Repository này mục đích lưu các job đã build này. Các job này sẽ được CI/CD lên hệ thống.

Các tool:

## Tool extract_tool.sh

Extract các job .zip vào thư mục cần chạy

```bash
# extractv and deploy job
extract_tool.sh
```

## Tool cleanup-git-repos.sh

Vì các job build là .jar bao gồm cả library để chạy độc lập. Nên sau một thời gian Git sẽ rất nặng, dùng tool này để cleanup git chỉ giữ lại các history trong 1 tháng.

```bash
# clean git history, just keep 1 month
cleanup-git-repos.sh
```



"# Talend-Built-Jobs" 
