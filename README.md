# dev-settings — 새 맥북 개발 환경 자동 세팅

새 MacBook에서 개발 환경(앱 · CLI 도구 · VS Code · zsh · 개인 GitHub SSH 키)을 한 번에 세팅하는 스크립트 모음.

## 빠른 시작

```bash
git clone <this-repo> ~/code/me/dev-settings
cd ~/code/me/dev-settings/mac-setup
bash setup.sh          # 전체 세팅 (01 → 07 순차 실행)
```

개별 스텝만 다시 돌리려면: `bash 02_apps.sh` 처럼 파일 하나만 실행. 모든 스텝은 **멱등**(이미 설치/설정된 항목은 건너뜀).

## 세팅 단계 (`mac-setup/setup.sh`)

| 스텝 | 파일 | 내용 |
|---|---|---|
| 1 | `01_homebrew.sh` | Homebrew 설치(curl) + 최신 `curl` formula |
| 2 | `02_apps.sh` | GUI 앱 설치 (Homebrew Cask) |
| 3 | `03_dev_tools.sh` | CLI 도구(formula) + nvm(curl) + Node LTS |
| 4 | `04_vscode_extensions.sh` | VS Code 확장 일괄 설치 |
| 5 | `05_oh_my_zsh.sh` | Oh My Zsh + 플러그인(git clone) |
| 6 | `06_aliases.sh` | `.zshrc` alias · PATH · nvmrc 자동감지 훅 |
| 7 | `07_github_ssh.sh` | 개인 GitHub 전용 SSH 키 생성 |

---

## 설치 방식별 분류

### 🍺 1. Homebrew Cask — GUI 앱 (`02_apps.sh`)

| 앱 | cask 토큰 | 비고 |
|---|---|---|
| Warp | `warp` | 터미널 |
| Google Chrome | `google-chrome` | |
| VS Code | `visual-studio-code` | |
| GitKraken | `gitkraken` | Git GUI |
| Docker Desktop | `docker-desktop` | |
| TablePlus | `tableplus` | SQL GUI |
| MongoDB Compass | `mongodb-compass` | |
| Redis Insight | `redis-insight` | |
| Figma | `figma` | |
| draw.io | `drawio` | 다이어그램 |
| Notion | `notion` | |
| Slack | `slack` | |
| Rectangle | `rectangle` | 창 관리 |
| Claude | `claude` | 데스크탑 앱 |
| Claude Code | `claude-code` | ⚠️ 아래 주의 참고 |

### 🍺 2. Homebrew Formula — CLI 도구 (`01`, `03`)

`curl` · `git` · `gh` · `pnpm` · `python3` · `jq` · `tree` · `fzf` · `bat` · `eza` · `ripgrep` · `fd` · `htop` · `wget`

### 🌐 3. curl 공식 스크립트 — brew로 하면 경로 충돌

| 대상 | 위치 |
|---|---|
| Homebrew 자체 | `01_homebrew.sh` |
| nvm | `03_dev_tools.sh` (brew nvm은 경로 충돌 → curl 방식 채택) |
| Oh My Zsh | `05_oh_my_zsh.sh` |

### 📦 4. git clone — zsh 플러그인 (`05_oh_my_zsh.sh`)

`zsh-autosuggestions` · `zsh-syntax-highlighting` · `zsh-completions`

### ⚙️ 5. nvm 경유 (홈페이지 아님)

**Node.js LTS** — `nvm install --lts` (brew node는 nvm과 충돌해 의도적으로 제외)

### 🔑 6. 설치 후 "수동" 필요 (설치가 아닌 로그인/라이선스)

- **Monokai Pro** — 확장은 자동 설치, **테마 라이선스는 홈페이지에서 별도 구매**
- **GitKraken · Warp · Docker · Figma · Notion · Slack · Claude** — 앱은 brew로 설치, **계정 로그인만 수동**
- **개인 GitHub SSH 공개키** — `07` 스텝이 클립보드에 복사 → GitHub에 붙여넣기(아래 참고)

---

## VS Code

- **확장**: `04_vscode_extensions.sh`가 자동 설치. 목록/일괄설치 명령은 [`vscode/vscode-extensions-export.md`](vscode/vscode-extensions-export.md) (이 PC 기준 export).
- **settings.json / keybindings.json**: 자동 적용 아님 → [`vscode/vscode-settings-export.md`](vscode/vscode-settings-export.md) 내용을 수동으로 붙여넣기.

---

## 개인 GitHub SSH 키 (`07_github_ssh.sh`)

업무용 키와 섞이지 않도록 **`github.com-personal` 호스트 별칭**으로 분리 생성한다 (기본 `github.com` 설정은 건드리지 않음).

- 키 파일: `~/.ssh/id_ed25519_github_personal`
- 이메일 기본값: `gydus.dev@gmail.com` → 변경 시 `GITHUB_EMAIL=other@mail.com bash 07_github_ssh.sh`
- 실행 후 공개키가 클립보드에 복사됨 → <https://github.com/settings/ssh/new> 에 붙여넣기

**개인 repo 사용법** (별칭이므로 `github.com-personal` 로 접근):

```bash
# 연결 테스트
ssh -T git@github.com-personal

# clone
git clone git@github.com-personal:<USER>/<REPO>.git

# 기존 repo의 remote 변경
git remote set-url origin git@github.com-personal:<USER>/<REPO>.git
```

---

## 주의 / 참고

- **`claude-code`**: brew cask로 설치되지만 자체 자동 업데이트가 있어 brew 버전 추적과 어긋날 수 있음. 항상 최신을 원하면 공식 방식(`curl -fsSL https://claude.ai/install.sh | bash` 또는 npm `@anthropic-ai/claude-code`)이 더 매끄러움.
- **`cat` alias** (`06_aliases.sh`): `cat`이 `bat --style=plain`으로 덮어써져 있음. 스크립트/파이프에서 순정 cat이 필요하면 `command cat` 또는 `\cat` 사용.
- 스크립트 수정 후에는 `bash -n <file>` 로 문법 확인 권장.
