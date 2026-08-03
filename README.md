# dev-settings

> macOS 개발 환경 프로비저닝 · dotfiles 관리 자동화

**멱등(idempotent) 셸 스크립트**로 새 MacBook의 개발 환경 전체를 코드로 재현한다 — Homebrew 패키지(cask/formula), VS Code 확장, zsh(oh-my-zsh + starship), git 다중 신원, 개인 GitHub SSH, Claude Code 하네스(ECC 서브모듈).

| | |
|---|---|
| **플랫폼** | macOS (Apple Silicon) · zsh · Homebrew |
| **엔트리포인트** | [`mac-setup/setup.sh`](mac-setup/setup.sh) (01 → 08 순차) |
| **설정 정본(SoT)** | `zsh/` · `git/` · `claude/` — 심링크로 `~`에 배포 |
| **멱등성** | 모든 스텝이 기존 설치/설정을 감지하고 건너뜀 |

## 레포 구조

```
dev-settings/
├── mac-setup/            # 프로비저닝 스크립트 (01_* ~ 08_*, setup.sh)
├── zsh/zshrc             # .zshrc 정본 → ~/.zshrc 심링크
├── git/                  # gitconfig(업무/개인 자동전환) · gitignore_global
├── claude/               # Claude Code 개인 설정 + ECC 하네스(서브모듈)
│   ├── settings.personal.json
│   ├── CLAUDE.md
│   ├── sync-ecc-skills.sh
│   └── plugins/ecc/      # git submodule → affaan-m/ECC
└── vscode/               # 확장 목록 · settings 수동 이관 노트
```

## 빠른 시작

```bash
git clone --recurse-submodules <this-repo> ~/code/dev-settings
cd ~/code/dev-settings/mac-setup
bash setup.sh          # 전체 세팅 (01 → 08 순차 실행)
```

이미 clone한 뒤 서브모듈(ECC)만 받으려면: `git submodule update --init claude/plugins/ecc`.

개별 스텝만 다시 돌리려면: `bash 02_apps.sh` 처럼 파일 하나만 실행. 모든 스텝은 **멱등**(이미 설치/설정된 항목은 건너뜀).

## 세팅 단계 (`mac-setup/setup.sh`)

| 스텝 | 파일 | 내용 |
|---|---|---|
| 1 | `01_homebrew.sh` | Homebrew 설치(curl) + 최신 `curl` formula |
| 2 | `02_apps.sh` | GUI 앱 설치 (Homebrew Cask) |
| 3 | `03_dev_tools.sh` | CLI 도구(formula) + terraform(tap) + nvm/Node(curl) + bun(curl) |
| 4 | `04_vscode_extensions.sh` | VS Code 확장 일괄 설치 |
| 5 | `05_oh_my_zsh.sh` | Oh My Zsh + 플러그인(git clone) |
| 6 | `06_zshrc.sh` | 정본 `.zshrc`(`zsh/zshrc`)를 `~/.zshrc`로 심링크 배포 |
| 7 | `07_github_ssh.sh` | 개인 GitHub 전용 SSH 키 생성 |
| 8 | `08_git.sh` | Git 신원(업무/개인 자동전환) + 전역 gitignore 심링크 배포 |

---

## 설치 방식별 분류

### 🍺 1. Homebrew Cask — GUI 앱 (`02_apps.sh`)

| 앱 | cask 토큰 | 비고 |
|---|---|---|
| Warp | `warp` | 터미널 |
| Google Chrome | `google-chrome` | |
| VS Code | `visual-studio-code` | |
| GitKraken | `gitkraken` | Git GUI |
| GitKraken CLI | `gitkraken-cli` | `gk` 명령 |
| Docker Desktop | `docker-desktop` | |
| AWS SSM plugin | `session-manager-plugin` | ECS/EC2 세션 접속 |
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

- **버전관리/GitHub**: `git` · `gh` · `lazygit`
- **런타임/패키지**: `pnpm` · `python3`
- **클라우드**: `awscli` · `terraform`(hashicorp tap)
- **DB CLI**: `mysql-client` · `mongosh` · `redis`(redis-cli)
- **셸/탐색**: `starship` · `zoxide` · `fzf` · `eza` · `bat` · `ripgrep` · `fd` · `tree` · `ncdu`
- **데이터 처리**: `jq` · `yq`
- **기타**: `curl` · `wget` · `htop` · `tlrc`(tldr) · `chroma` · `clipboard`

> `terraform`은 라이선스 변경으로 homebrew-core에서 빠져 `brew install hashicorp/tap/terraform` 로 설치.
> `mysql-client`는 keg-only라 `.zshrc`에서 PATH 등록.

### 🌐 3. curl 공식 스크립트 — brew로 하면 경로 충돌

| 대상 | 위치 |
|---|---|
| Homebrew 자체 | `01_homebrew.sh` |
| nvm | `03_dev_tools.sh` (brew nvm은 경로 충돌 → curl 방식 채택) |
| bun | `03_dev_tools.sh` (`curl -fsSL https://bun.sh/install \| bash`) |
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

## zsh 설정 (`zsh/zshrc`)

`.zshrc`는 레포의 [`zsh/zshrc`](zsh/zshrc)가 **정본(SoT)**이다. `06_zshrc.sh`가 `~/.zshrc`를 이 파일로 **심링크**하므로, 이후 셸 설정을 바꾸면 레포 파일이 함께 바뀐다 → `git commit`만 하면 동기화된다.

- 기존 `~/.zshrc`가 있으면 `~/.zshrc.pre-devsetup`로 백업 후 교체.
- 포함: oh-my-zsh + 플러그인, starship 프롬프트, zoxide(smart cd), fzf, nvm + `.nvmrc` 자동감지, eza/bat alias, git·brew·bun·mysql PATH 등.
- `zoxide init`은 반드시 파일 **맨 끝**에 있어야 함(다른 `chpwd` 훅보다 나중에 등록돼야 경고가 안 뜸).

## Git 설정 (`git/`)

`08_git.sh`가 아래 3개를 `~`로 심링크(정본은 레포). 기존 파일은 `*.pre-devsetup`로 백업.

- [`git/gitconfig`](git/gitconfig) → `~/.gitconfig` — 기본은 **업무 신원**, `~/code/me/` 하위 repo에선 `includeIf`로 **개인 신원 자동 전환**. `init.defaultBranch=main`, `push.autoSetupRemote=true`, `pull.rebase=false`, `core.excludesfile` 포함.
- [`git/gitconfig-personal`](git/gitconfig-personal) → `~/.gitconfig-personal` — 개인 이메일 + 이름 없는 개인 SSH 키(`id_ed25519_github_personal`).
- [`git/gitignore_global`](git/gitignore_global) → `~/.gitignore_global` — OS/에디터/빌드/시크릿 전역 무시.

> SSH 키/별칭은 이름을 넣지 않는다: 키 `~/.ssh/id_ed25519_github_personal`, alias `github.com-personal` (07 스텝과 동일 규칙). 개인 repo는 `git@github.com-personal:...` 로 clone.

## Claude Code (`claude/`)

개인 Claude Code 환경을 다른 PC에서 그대로 복원하기 위한 설정 + 개인 하네스(ECC·ponytail). 회사 하네스와 무관하게 **로컬 서브모듈**로 독립.

- [`claude/settings.personal.json`](claude/settings.personal.json) — 개인 취향 설정. `model`·`theme`·`tui`·`effortLevel`·`autoMemoryEnabled`·`permissions`(`defaultMode: auto` = 세션 시작 시 auto mode) 포함. `~/.claude/settings.json`에 **병합**(덮어쓰기 금지 — `enabledPlugins`/`statusLine`/`skillOverrides`를 날림).
- [`claude/CLAUDE.md`](claude/CLAUDE.md) — 사용자 레벨 개인 지침(한국어 응답·짧은 답변). `~/.claude/CLAUDE.md`로 복사. `autoMemoryEnabled: false`로 auto-memory 대신 이 파일로만 관리.
- [`claude/plugins/ecc`](claude/plugins/ecc) — [ECC](https://github.com/affaan-m/ECC) 하네스(agents/skills/hooks)를 **git submodule**로 벤더링. 로컬 클론을 `directory` 소스로 등록하고 statusLine도 이 안의 스크립트를 가리킴.
- [`claude/sync-ecc-skills.sh`](claude/sync-ecc-skills.sh) — ECC 스킬을 `~/.claude/skills/`로 심링크(Obsidian [claude-code-skills](https://community.obsidian.md/plugins/claude-code-skills) 플러그인용) + `skillOverrides` 재생성으로 컨텍스트 다이어트. 멱등이라 서브모듈 업데이트 후 재실행.
- [`claude/README.md`](claude/README.md) — 새 맥북 복원 체크리스트(설치·로그인·ponytail·ECC·스킬 동기화·커밋 금지 파일).

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
- **`cat`/`ls` alias** (`zsh/zshrc`): `cat`→`bat`, `ls`→`eza`로 덮어써져 있음. 스크립트/파이프에서 순정 명령이 필요하면 `command cat` 또는 `\cat` 사용.
- 스크립트 수정 후에는 `bash -n <file>`(셸 스크립트) / `zsh -n zsh/zshrc`(zshrc) 로 문법 확인 권장.
