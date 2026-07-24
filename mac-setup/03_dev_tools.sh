#!/bin/bash
set -e

echo "==> [3/8] CLI 개발 도구 설치"

FORMULAE=(
    # ── 버전관리 / GitHub ──
    git           # 버전 관리
    gh            # GitHub CLI (PR/이슈/auth)
    lazygit       # Git TUI (터미널 UI)

    # ── 런타임 / 패키지 매니저 ──
    pnpm          # Node 패키지 매니저
    python3       # Python 3

    # ── 클라우드 ──
    awscli        # AWS CLI (S3/SQS/SES/ECR/Secrets 등)

    # ── DB 클라이언트 (CLI) ──
    mysql-client  # MySQL/MariaDB 접속 CLI (keg-only → PATH 등록 필요)
    mongosh       # MongoDB 셸
    redis         # redis-cli 포함 (Redis CLI + 로컬 서버)

    # ── 셸 / 파일 탐색 ──
    starship      # 커스텀 셸 프롬프트
    zoxide        # 스마트 cd (자주 간 디렉토리 점프)
    fzf           # 퍼지 파인더
    eza           # ls 개선판 (아이콘/트리)
    bat           # cat 개선판 (syntax highlight)
    ripgrep       # grep 개선판 (rg)
    fd            # find 개선판
    tree          # 디렉토리 트리 출력
    ncdu          # 디스크 사용량 TUI

    # ── 데이터 처리 ──
    jq            # JSON 처리
    yq            # YAML 처리 (jq의 YAML판)

    # ── 기타 유틸 ──
    htop          # 프로세스 모니터
    wget          # 파일 다운로드
    tlrc          # tldr 클라이언트 (명령어 사용 예시)
    chroma        # 범용 구문 강조기
    clipboard     # 클립보드 CLI (cb)
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

# terraform (HashiCorp tap — 라이선스 변경으로 homebrew-core에서 이전됨)
if command -v terraform &>/dev/null; then
    echo "  ✓ terraform 이미 설치됨"
else
    echo "  --> terraform 설치 중 (hashicorp/tap)..."
    brew install hashicorp/tap/terraform || echo "  ⚠ terraform 설치 실패"
fi

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

# bun (JS 런타임/패키지 매니저 — brew 아닌 자체 installer)
if command -v bun &>/dev/null || [ -x "$HOME/.bun/bin/bun" ]; then
    echo "  ✓ bun 이미 설치됨"
else
    echo "  --> bun 설치 중 (curl)..."
    curl -fsSL https://bun.sh/install | bash
fi

echo "  ✓ CLI 도구 설치 완료"
