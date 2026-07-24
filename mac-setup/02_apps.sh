#!/bin/bash
set -e

echo "==> [2/8] 앱 설치 (Homebrew Cask)"

CASKS=(
    # ── 터미널 / 브라우저 ──
    warp                   # GPU 가속 터미널 (AI 명령 제안 내장)
    google-chrome          # 웹 브라우저

    # ── 에디터 / IDE ──
    visual-studio-code     # 코드 에디터

    # ── Git ──
    gitkraken              # Git GUI 클라이언트
    gitkraken-cli          # GitKraken CLI (gk 명령)

    # ── 컨테이너 / 클라우드 ──
    docker-desktop         # Docker 데스크탑 (컨테이너 런타임 + GUI)
    session-manager-plugin # AWS SSM Session Manager 플러그인 (ECS/EC2 세션 접속)

    # ── DB 클라이언트 ──
    tableplus              # SQL GUI (MySQL/MariaDB/Postgres 통합)
    mongodb-compass        # MongoDB GUI
    redis-insight          # Redis GUI

    # ── 디자인 ──
    figma                  # UI/UX 디자인
    drawio                 # 다이어그램 (아키텍처/ERD)

    # ── 협업 / 노트 ──
    notion                 # 문서 / 위키 / 태스크
    slack                  # 팀 메신저

    # ── 유틸리티 ──
    rectangle              # 창 관리 (단축키로 스냅/분할)

    # ── AI ──
    claude                 # Claude 데스크탑 앱
    claude-code            # Claude Code CLI (터미널 AI 코딩)
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
