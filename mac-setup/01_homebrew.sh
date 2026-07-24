#!/bin/bash
set -e

echo "==> [1/7] Homebrew 설치"

if command -v brew &>/dev/null; then
    echo "  ✓ Homebrew 이미 설치됨"
else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Apple Silicon PATH 설정
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
    echo "  ✓ Homebrew 설치 완료"
fi

# curl 최신 버전 설치 (macOS 기본 curl 대체)
brew install curl
echo "  ✓ curl 설치 완료"

brew update && brew upgrade
echo "  ✓ Homebrew 업데이트 완료"
