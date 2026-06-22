# VS Code Settings Export

다른 계정에서 import할 때 아래 내용을 각 파일에 붙여넣으세요.

---

## 1. settings.json
경로: `~/Library/Application Support/Code/User/settings.json` (Mac)
경로: `%APPDATA%\Code\User\settings.json` (Windows)

```json
{
    "extensions.ignoreRecommendations": true,
    "explorer.confirmDelete": false,
    "explorer.confirmDragAndDrop": false,
    "claudeCode.allowDangerouslySkipPermissions": true,
    "claudeCode.autosave": false,
    "redhat.telemetry.enabled": false,
    "atlascode.rovodev.showEntitlementNotifications": false,
    "gitlens.ai.model": "vscode",
    "gitlens.ai.vscode.model": "copilot:gpt-4.1",
    "claudeCode.preferredLocation": "panel",
    "accessibility.voice.speechLanguage": "ko-KR"
}
```

---

## 2. keybindings.json
경로: `~/Library/Application Support/Code/User/keybindings.json` (Mac)
경로: `%APPDATA%\Code\User\keybindings.json` (Windows)

```json
[
    {
        "key": "cmd+l",
        "command": "-expandLineSelection",
        "when": "textInputFocus"
    },
    {
        "key": "cmd+l",
        "command": "-workbench.action.browser.focusUrlInput",
        "when": "activeEditor == 'workbench.editor.browser'"
    },
    {
        "key": "cmd+l",
        "command": "workbench.view.extension.claude-sidebar-secondary"
    },
    {
        "key": "shift+cmd+s",
        "command": "workbench.action.files.saveAll"
    }
]
```

> Windows에서는 `cmd` → `ctrl` 로 변경 필요

---

## 메모

- 프로젝트(.vscode) 전용 설정 없음 — 모두 글로벌 설정
- Claude Code 관련: 패널 위치, 자동저장 off, 위험권한 허용
- GitLens AI: Copilot GPT-4.1 사용
- 단축키: `Cmd+L` → Claude 사이드바, `Shift+Cmd+S` → 전체 저장
