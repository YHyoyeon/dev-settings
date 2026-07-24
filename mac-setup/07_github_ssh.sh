#!/bin/bash
set -e

echo "==> [7/7] 개인 GitHub 전용 SSH 키 생성"

# 개인 GitHub 이메일 (필요 시: GITHUB_EMAIL=other@mail.com bash 07_github_ssh.sh)
GITHUB_EMAIL="${GITHUB_EMAIL:-gydus.dev@gmail.com}"
KEY_FILE="$HOME/.ssh/id_ed25519_github_personal"
SSH_CONFIG="$HOME/.ssh/config"
HOST_ALIAS="github.com-personal"   # 업무용 github.com 설정과 분리하기 위한 별칭

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

# 1) 키 생성 (이미 있으면 건너뜀). passphrase 원하면 -N "" 를 지우고 실행
if [ -f "$KEY_FILE" ]; then
    echo "  ✓ 개인 키 이미 존재: $KEY_FILE (건너뜀)"
else
    echo "  --> ed25519 키 생성 (이메일: $GITHUB_EMAIL)"
    ssh-keygen -t ed25519 -C "$GITHUB_EMAIL" -f "$KEY_FILE" -N ""
    echo "  ✓ 키 생성 완료"
fi

# 2) ~/.ssh/config 에 개인 전용 Host 등록 (없을 때만 — 업무용 설정 보존)
if [ -f "$SSH_CONFIG" ] && grep -q "Host $HOST_ALIAS" "$SSH_CONFIG"; then
    echo "  ✓ SSH config 이미 등록됨 (Host $HOST_ALIAS)"
else
    cat >> "$SSH_CONFIG" << EOF

# 개인 GitHub 전용 — clone 시: git@$HOST_ALIAS:USER/REPO.git
Host $HOST_ALIAS
  HostName github.com
  User git
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile $KEY_FILE
  IdentitiesOnly yes
EOF
    chmod 600 "$SSH_CONFIG"
    echo "  ✓ SSH config 등록 완료 (Host $HOST_ALIAS)"
fi

# 3) ssh-agent + macOS 키체인 등록
ssh-add --apple-use-keychain "$KEY_FILE" 2>/dev/null \
    || ssh-add "$KEY_FILE" 2>/dev/null \
    || echo "  ⚠ ssh-add 실패 — 수동: ssh-add --apple-use-keychain $KEY_FILE"
echo "  ✓ ssh-agent 등록 완료"

# 4) 공개키 클립보드 복사 + GitHub 등록 안내
pbcopy < "$KEY_FILE.pub"
echo "  ✓ 공개키를 클립보드에 복사했습니다."
echo ""
echo "  ── GitHub 등록 (수동) ──────────────────────"
echo "    1. https://github.com/settings/ssh/new 접속"
echo "    2. Title: MacBook (personal) / Key: 붙여넣기(Cmd+V) → Add SSH key"
echo "    3. 연결 테스트:  ssh -T git@$HOST_ALIAS"
echo ""
echo "  ── 개인 repo 사용법 ────────────────────────"
echo "    clone :  git clone git@$HOST_ALIAS:<USER>/<REPO>.git"
echo "    기존 remote 변경:"
echo "             git remote set-url origin git@$HOST_ALIAS:<USER>/<REPO>.git"
echo ""
echo "  공개키:"
cat "$KEY_FILE.pub"
echo ""
echo "  ✓ 개인 GitHub SSH 키 설정 완료"
