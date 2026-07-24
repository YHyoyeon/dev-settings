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
run_step 06_zshrc.sh
run_step 07_github_ssh.sh
run_step 08_git.sh

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ 모든 세팅 완료!"
echo ""
echo "다음 단계:"
echo "  1. source ~/.zshrc           # alias 즉시 적용"
echo "  2. Warp 실행 후 기본 터미널로 설정"
echo "  3. VS Code 실행 → Monokai Pro 테마 활성화 (라이선스 필요)"
echo "  4. GitKraken 실행 → 계정 연결"
echo "  5. 개인 GitHub SSH 공개키 등록 ([7/8]에서 클립보드에 복사됨)"
echo "     https://github.com/settings/ssh/new → 붙여넣기 → 저장"
echo "     테스트: ssh -T git@github.com-personal"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
