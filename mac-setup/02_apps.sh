#!/bin/bash
set -e

echo "==> [2/7] 앱 설치 (Homebrew Cask)"

CASKS=(
    # 터미널
    warp

    # 브라우저
    google-chrome

    # 에디터 / IDE
    visual-studio-code

    # Git GUI
    gitkraken

    # 컨테이너
    docker-desktop    # Docker Desktop

    # DB 클라이언트
    tableplus         # SQL GUI
    mongodb-compass   # MongoDB GUI
    redis-insight     # Redis GUI

    # 디자인
    figma
    drawio            # 다이어그램

    # 협업 / 노트
    notion
    slack

    # 유틸리티
    rectangle         # 창 관리 (단축키 스냅)

    # AI
    claude            # Claude 데스크탑 앱
    claude-code       # Claude Code CLI
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
