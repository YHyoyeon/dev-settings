#!/bin/bash
set -e

echo "==> [6/8] zsh 설정 배포 (.zshrc)"

# 레포에서 관리하는 정본 .zshrc 를 ~/.zshrc 로 심링크 (SoT 단일화)
# → 이후 ~/.zshrc 를 수정하면 레포 파일이 함께 바뀌므로 git commit 만 하면 됨
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$(cd "$SCRIPT_DIR/../zsh" && pwd)/zshrc"
DEST="$HOME/.zshrc"

if [ ! -f "$SRC" ]; then
    echo "  ✗ 정본 .zshrc 없음: $SRC"
    exit 1
fi

# 이미 우리 심링크로 연결돼 있으면 건너뜀
if [ -L "$DEST" ] && [ "$(readlink "$DEST")" = "$SRC" ]; then
    echo "  ✓ .zshrc 이미 레포 심링크로 연결됨 → $SRC"
else
    # 기존 실제 파일이 있으면 백업 후 교체
    if [ -e "$DEST" ] && [ ! -L "$DEST" ]; then
        cp "$DEST" "$DEST.pre-devsetup"
        echo "  ↪ 기존 .zshrc 백업: $DEST.pre-devsetup"
    fi
    ln -sf "$SRC" "$DEST"
    echo "  ✓ .zshrc → $SRC 심링크 연결 완료"
fi

echo "  ✓ zsh 설정 배포 완료"
echo "  적용하려면 실행: source ~/.zshrc"
