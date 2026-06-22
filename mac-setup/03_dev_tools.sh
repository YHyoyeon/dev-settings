#!/bin/bash
set -e

echo "==> [3/6] CLI 개발 도구 설치"

FORMULAE=(
    git       # 버전 관리
    gh        # GitHub CLI
    node      # Node.js (npm 포함)
    nvm       # Node 버전 관리
    pnpm      # 패키지 매니저
    python3   # Python
    jq        # JSON 처리
    tree      # 디렉토리 트리 출력
    fzf       # 퍼지 파인더
    bat       # cat 개선판 (syntax highlight)
    eza       # ls 개선판
    ripgrep   # grep 개선판 (rg)
    fd        # find 개선판
    htop      # 프로세스 모니터
    wget      # 파일 다운로드
)

for formula in "${FORMULAE[@]}"; do
    [[ "$formula" == \#* ]] && continue
    [[ -z "$formula" ]] && continue

    if brew list "$formula" &>/dev/null; then
        echo "  - $formula 이미 설치됨, 건너뜀"
    else
        echo "  --> $formula 설치 중..."
        brew install "$formula" || echo "  ⚠ $formula 설치 실패"
    fi
done

echo "  ✓ CLI 도구 설치 완료"
