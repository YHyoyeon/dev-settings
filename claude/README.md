# Claude Code 설정

새 맥북에서 Claude Code(CLI)를 복원하기 위한 참고 자료. **개인 취향 설정만** 담고,
회사 내부 하네스(플러그인 · statusLine · MCP)는 포함하지 않는다(회사 온보딩 영역).

## 새 맥북 복원 순서

1. **설치** — `mac-setup/02_apps.sh`가 `claude`(데스크탑) + `claude-code`(CLI) cask 설치.
   - 대안: 네이티브 설치 `curl -fsSL https://claude.ai/install.sh | bash`
     (자체 업데이트가 매끄러워 dotfiles 복원에는 이 방식이 더 권장됨. brew는 `brew upgrade` 주기를 탐)
2. **로그인** — `claude` 실행 후 `/login` (브라우저, 수동).
   - 자동화가 필요하면 `claude setup-token` → `CLAUDE_CODE_OAUTH_TOKEN` 환경변수(약 1년).
3. **개인 설정 병합** — [`settings.personal.json`](settings.personal.json)의 내용을
   `~/.claude/settings.json`에 **병합(merge)**. (model / theme / effortLevel / autoMemoryEnabled / permissions 만)
   - 통째로 덮어쓰지 말 것 — 회사 하네스가 넣는 `enabledPlugins` / `statusLine` /
     `extraKnownMarketplaces` 를 날려버림.
   - `autoMemoryEnabled: false` — Claude가 세션 간에 스스로 기록하는 auto-memory
     기능을 끄고, 개인 지침은 아래 [`CLAUDE.md`](CLAUDE.md)로만 관리한다.
4. **개인 지침 복사** — [`CLAUDE.md`](CLAUDE.md)를 `~/.claude/CLAUDE.md`로 복사.
   (사용자 레벨 지침 — 모든 프로젝트에 적용됨)
5. **개인 필수 플러그인**:
   - [ponytail](https://github.com/DietrichGebert/ponytail) — 불필요한 코드를 줄이도록
     유도하는 룰셋을 SessionStart 훅으로 주입.
     ```bash
     claude plugin marketplace add DietrichGebert/ponytail
     claude plugin install ponytail@ponytail
     ```
   - [ECC](https://github.com/affaan-m/ECC) — agents/skills/hooks 종합 하네스.
     이 repo의 `claude/plugins/ecc` **git submodule**로 소스를 직접 들고 있고
     (wd-harness와 동일하게 로컬 클론을 `directory` 소스로 등록 — 회사 코드에 의존하지 않기 위함),
     statusLine도 이 서브모듈 안의 스크립트를 가리킨다.
     ```bash
     git submodule update --init claude/plugins/ecc
     claude plugin marketplace add "$(pwd)/claude/plugins/ecc"
     claude plugin install ecc@ecc
     ```
     `~/.claude/settings.json`에 statusLine 등록 (경로는 이 repo를 clone한 위치에 맞게 조정):
     ```json
     {
       "statusLine": {
         "type": "command",
         "command": "node <repo-path>/claude/plugins/ecc/scripts/hooks/ecc-statusline.js"
       }
     }
     ```
   - **ECC 스킬 심링크 + 컨텍스트 다이어트** — [`sync-ecc-skills.sh`](sync-ecc-skills.sh) 실행:
     ```bash
     bash claude/sync-ecc-skills.sh
     ```
     하는 일 (멱등, ECC 서브모듈 업데이트 후 재실행):
     - ECC 스킬 281개를 `~/.claude/skills/`로 심링크 — Obsidian
       [claude-code-skills](https://community.obsidian.md/plugins/claude-code-skills)
       플러그인이 이 경로만 읽기 때문.
     - `~/.claude/settings.json`의 `skillOverrides` 재생성:
       심링크로 생긴 맨이름 중복은 전부 `off`, 현재 스택(TS/Node/React/NestJS)과
       무관한 도메인 122개는 `name-only`(이름만 노출, 필요할 때 모델이 꺼내 씀).
       도메인이 바뀌면 스크립트 안 `deny_patterns`에서 패턴을 빼면 된다.
6. **회사 하네스 / 플러그인** (이 repo 밖, Welda 온보딩):
   - 하네스 repo → `~/code/wd-harness` 클론 (플러그인 마켓플레이스 + statusLine 소스)
   - agent-skills repo 클론 후 개인 스킬을 `~/.claude/skills/` 로 심링크
   - 플러그인: `claude plugin marketplace add <repo>` → `claude plugin install <name>`
   - 상세는 내부 문서 참고.

## 절대 커밋 금지 (비밀 / 머신 상태)

| 파일 | 이유 |
|---|---|
| `~/.claude/settings.local.json` | 로컬 오버라이드 |
| `~/.claude.json` | OAuth 계정 · 세션 · 캐시 상태 |
| `~/.claude/.credentials.json` | 인증 토큰 |
