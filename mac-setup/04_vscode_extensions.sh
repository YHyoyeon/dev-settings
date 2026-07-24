#!/bin/bash
set -e

echo "==> [4/8] VS Code 확장 설치"

if ! command -v code &>/dev/null; then
    export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
fi

if ! command -v code &>/dev/null; then
    echo "  ⚠ code 명령어를 찾을 수 없음. VS Code가 설치됐는지 확인하세요."
    exit 1
fi

EXTENSIONS=(
    # AI / 개발 도구
    anthropic.claude-code
    eamodio.gitlens
    donjayamanne.githistory
    jackiotyu.git-worktree-manager
    github.vscode-github-actions
    ziyasal.vscode-open-in-github

    # Vue / Frontend
    vue.volar
    matijao.vue-nuxt-snippets
    dbaeumer.vscode-eslint
    esbenp.prettier-vscode
    xabikos.javascriptsnippets
    mquandalle.graphql

    # CSS / HTML
    ecmel.vscode-html-css
    pranaygp.vscode-css-peek
    kamikillerto.vscode-colorize
    lukas-tr.materialdesignicons-intellisense

    # Python
    ms-python.python
    ms-python.vscode-pylance
    ms-python.debugpy
    ms-python.vscode-python-envs

    # 인프라 / DB / 원격
    4ops.terraform
    prisma.prisma
    redhat.vscode-yaml
    ms-azuretools.vscode-docker
    ms-azuretools.vscode-containers
    ms-vscode-remote.remote-containers
    ms-vscode-remote.remote-ssh
    ms-vscode-remote.remote-ssh-edit
    ms-vscode-remote.remote-wsl
    ms-vscode-remote.vscode-remote-extensionpack
    ms-vscode.remote-explorer
    ms-vscode.remote-server
    mechatroner.rainbow-csv

    # 문서 / 다이어그램
    shd101wyy.markdown-preview-enhanced
    arichika.previewseqdiag-vscode
    mscgenjs.vscode-mscgen

    # UI / 테마
    monokai.theme-monokai-pro-vscode
    vscode-icons-team.vscode-icons
    antfu.iconify
    oderwat.indent-rainbow
    fabiospampinato.vscode-highlight
    ms-ceintl.vscode-language-pack-ko

    # 생산성
    alefragnani.project-manager
    usernamehw.errorlens
    wayou.vscode-todo-highlight
    ryu1kn.text-marker
    editorconfig.editorconfig
    codezombiech.gitignore
)

for ext in "${EXTENSIONS[@]}"; do
    [[ "$ext" == \#* ]] && continue
    [[ -z "$ext" ]] && continue

    echo "  --> $ext 설치 중..."
    code --install-extension "$ext" --force 2>/dev/null || echo "  ⚠ $ext 설치 실패"
done

echo "  ✓ VS Code 확장 설치 완료"
