#!/bin/bash
set -e

echo "==> [3/6] CLI 개발 도구 설치"

FORMULAE=(
    git       # 버전 관리
    gh        # GitHub CLI
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

# nvm 설치 (curl 공식 방법 — brew nvm은 경로가 달라 충돌 가능)
echo "  --> nvm 설치 중 (curl)..."
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    echo "  ✓ nvm 이미 설치됨"
else
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi
source "$NVM_DIR/nvm.sh"

# Node.js LTS 설치 및 기본값 지정
echo "  --> Node.js LTS 설치 중..."
nvm install --lts
nvm use --lts
nvm alias default lts/*
echo "  ✓ Node.js $(node -v) 설치 및 기본값 설정 완료"

echo "  ✓ CLI 도구 설치 완료"
