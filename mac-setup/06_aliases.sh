#!/bin/bash
set -e

echo "==> [6/6] Alias 및 PATH 설정"

ZSHRC="$HOME/.zshrc"
MARKER="# ===== Dev Setup (mac-setup) ====="

if grep -q "$MARKER" "$ZSHRC"; then
    echo "  ✓ alias 설정 이미 적용됨, 건너뜀"
    exit 0
fi

cat >> "$ZSHRC" << 'EOF'

# ===== Dev Setup (mac-setup) =====

# PATH
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
export PATH="$PATH:/Applications/Fork.app/Contents/Resources/gitface"
export PATH="/opt/homebrew/opt/curl/bin:$PATH"

# NVM (shell function으로 source 필요 — PATH만으로는 nvm use 불가)
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && source "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && source "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# .nvmrc 자동 감지: cd할 때 해당 버전 자동 적용
autoload -U add-zsh-hook
load-nvmrc() {
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"
  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# ── 파일 탐색 ──────────────────────────────
alias ll='ls -lahF'                      # 숨김 포함 상세 목록
alias la='ls -lAhF'                      # 숨김 포함 (. .. 제외)
alias lt='eza --tree --level=2'          # 트리 출력 (eza 설치 시)
alias cat='bat --style=plain'            # syntax highlight cat (bat 설치 시)

# ── 앱 실행 ────────────────────────────────
# code 명령: PATH로 등록된 바이너리 직접 사용 (alias는 무한 재귀 발생)
alias c.='/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code .'
alias fork='open -a Fork .'
alias chrome='open -a "Google Chrome"'

# ── Git ────────────────────────────────────
alias gs='git status'
alias gl='git log --oneline --graph --decorate -20'
alias gp='git pull'
alias gpp='git push'
alias gco='git checkout'
alias gcb='git checkout -b'

# ── 개발 편의 ──────────────────────────────
alias pn='pnpm'
alias nr='npm run'
alias py='python3'
alias myip='curl -s https://ifconfig.me'
alias flush='dscacheutil -flushcache && sudo killall -HUP mDNSResponder'  # DNS 캐시 초기화
alias brewup='brew update && brew upgrade && brew cleanup'

# ── 디렉토리 이동 ──────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias code-dir='cd ~/code'

# ===== End Dev Setup =====
EOF

echo "  ✓ .zshrc alias 및 PATH 설정 완료"
echo ""
echo "  적용하려면 실행: source ~/.zshrc"
