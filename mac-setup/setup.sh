#!/bin/bash
# 새 맥북 개발 환경 세팅 마스터 스크립트
# 사용법: bash setup.sh
# 개별 실행: bash 01_homebrew.sh 등

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

run_step() {
    local script="$1"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    bash "$SCRIPT_DIR/$script"
}

echo "╔══════════════════════════════════════╗"
echo "║    맥북 개발 환경 세팅 시작           ║"
echo "╚══════════════════════════════════════╝"

run_step 01_homebrew.sh
run_step 02_apps.sh
run_step 03_dev_tools.sh
run_step 04_vscode_extensions.sh
run_step 05_oh_my_zsh.sh
run_step 06_aliases.sh

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ 모든 세팅 완료!"
echo ""
echo "다음 단계:"
echo "  1. source ~/.zshrc           # alias 즉시 적용"
echo "  2. Warp 실행 후 기본 터미널로 설정"
echo "  3. VS Code 실행 → Monokai Pro 테마 활성화 (라이선스 필요)"
echo "  4. Fork 실행 → 계정 연결"
echo "  5. Maccy 실행 → 시스템 환경설정 > 손쉬운 사용 권한 허용"
echo "  6. SSH 키 생성 및 GitHub 등록 (필요 시)"
echo "     ssh-keygen -t ed25519 -C 'your@email.com' -f ~/.ssh/github_id"
echo "     gh auth login -h github.com -p ssh"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
