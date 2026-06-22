#!/bin/bash
set -e

echo "==> [5/6] Oh My Zsh + 플러그인 설치"

# Oh My Zsh 설치
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "  ✓ Oh My Zsh 이미 설치됨"
else
    echo "  --> Oh My Zsh 설치 중..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo "  ✓ Oh My Zsh 설치 완료"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# zsh-autosuggestions (이전 명령어 자동 완성 제안)
if [ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "  ✓ zsh-autosuggestions 이미 설치됨"
else
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# zsh-syntax-highlighting (명령어 색상 하이라이팅)
if [ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "  ✓ zsh-syntax-highlighting 이미 설치됨"
else
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# zsh-completions (자동완성 확장)
if [ -d "$ZSH_CUSTOM/plugins/zsh-completions" ]; then
    echo "  ✓ zsh-completions 이미 설치됨"
else
    git clone https://github.com/zsh-users/zsh-completions "$ZSH_CUSTOM/plugins/zsh-completions"
fi

# .zshrc 플러그인 목록 업데이트
if grep -q "zsh-autosuggestions" ~/.zshrc; then
    echo "  ✓ 플러그인 설정 이미 적용됨"
else
    sed -i '' 's/^plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions)/' ~/.zshrc
    echo "  ✓ 플러그인 .zshrc 적용 완료"
fi

echo "  ✓ Oh My Zsh 설정 완료"
