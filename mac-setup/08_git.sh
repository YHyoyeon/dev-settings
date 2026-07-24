#!/bin/bash
set -e

echo "==> [8/8] Git 설정 배포 (신원 + 전역 gitignore)"

# 레포 정본 git 설정을 ~ 로 심링크 (SoT 단일화)
#  - gitconfig          : 업무 신원(기본) + ~/code/me 개인 신원 자동 전환(includeIf) + 기본값
#  - gitconfig-personal : 개인 GitHub 이메일 + 이름 없는 personal SSH 키
#  - gitignore_global   : 전역 무시 목록
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GIT_DIR="$(cd "$SCRIPT_DIR/../git" && pwd)"

link() {
    local src="$GIT_DIR/$1"
    local dest="$HOME/$2"
    if [ ! -f "$src" ]; then echo "  ✗ 정본 없음: $src"; return 1; fi
    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
        echo "  ✓ $2 이미 레포 심링크됨"
    else
        if [ -e "$dest" ] && [ ! -L "$dest" ]; then
            cp "$dest" "$dest.pre-devsetup"
            echo "  ↪ 기존 $2 백업: $dest.pre-devsetup"
        fi
        ln -sf "$src" "$dest"
        echo "  ✓ $2 → $src"
    fi
}

link gitconfig          .gitconfig
link gitconfig-personal .gitconfig-personal
link gitignore_global   .gitignore_global

echo "  ✓ Git 설정 배포 완료"
echo "  확인: (~/code/me 밖) git config user.email → 업무 / (~/code/me 안) → 개인"
