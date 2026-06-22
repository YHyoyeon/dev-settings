#!/bin/bash
set -e

echo "==> [2/6] 앱 설치 (Homebrew Cask)"

CASKS=(
    # 터미널
    warp

    # 브라우저
    google-chrome

    # 에디터 / IDE
    visual-studio-code

    # Git GUI
    fork

    # 컨테이너
    docker

    # DB 클라이언트
    chat2db           # Chat2DB (SQL + NoSQL 통합)
    mongodb-compass   # MongoDB GUI
    redisinsight      # Redis GUI

    # 디자인
    figma

    # AI
    claude

    # 클립보드
    maccy
)

for cask in "${CASKS[@]}"; do
    # 주석 줄 건너뜀
    [[ "$cask" == \#* ]] && continue
    [[ -z "$cask" ]] && continue

    if brew list --cask "$cask" &>/dev/null; then
        echo "  - $cask 이미 설치됨, 건너뜀"
    else
        echo "  --> $cask 설치 중..."
        brew install --cask "$cask" || echo "  ⚠ $cask 설치 실패 (수동 설치 필요)"
    fi
done

echo "  ✓ 앱 설치 완료"
