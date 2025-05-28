#!/bin/bash

# Các job talend đã được buid nên có dung lượng lớn và không cần thiết lưu history quá lâu.
# Để giảm size chạy tool này khi dung lượng quá lớn
#

# refer:
# https://gitbetter.substack.com/p/how-to-clean-up-the-git-repo-and

# Delete all the local references of the remote branch
git remote prune origin

# Packs are used to reduce the load on disk spaces
git repack
git prune-packed

# remove all refs that are older than one month
git reflog expire --expire=1.month.ago

# garbage collection
git gc --aggressive
