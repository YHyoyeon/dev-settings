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
   `~/.claude/settings.json`에 **병합(merge)**. (model / theme / effortLevel / permissions 만)
   - 통째로 덮어쓰지 말 것 — 회사 하네스가 넣는 `enabledPlugins` / `statusLine` /
     `extraKnownMarketplaces` 를 날려버림.
4. **회사 하네스 / 플러그인** (이 repo 밖, Welda 온보딩):
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
