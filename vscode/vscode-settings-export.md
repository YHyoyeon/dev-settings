# VS Code Settings Export

다른 계정에서 import할 때 아래 내용을 각 파일에 붙여넣으세요.
(이 PC 기준으로 export — 2026-07-24)

---

## 1. settings.json
경로: `~/Library/Application Support/Code/User/settings.json` (Mac)
경로: `%APPDATA%\Code\User\settings.json` (Windows)

```json
{
    "claudeCode.preferredLocation": "panel",
    "window.confirmSaveUntitledWorkspace": false,
    "extensions.ignoreRecommendations": true,
    "explorer.confirmDelete": false,
    "explorer.confirmDragAndDrop": false,
    "claudeCode.allowDangerouslySkipPermissions": true,
    "claudeCode.autosave": false,
    "redhat.telemetry.enabled": false,
    "atlascode.rovodev.showEntitlementNotifications": false,
    "gitlens.ai.model": "vscode",
    "gitlens.ai.vscode.model": "copilot:gpt-4.1",
    "accessibility.voice.speechLanguage": "ko-KR",
    "workbench.startupEditor": "none",
    "highlight.regexes": {
        "((?:<!-- *)?(?:#|// @|//|./\\*+|<!--|--|\\* @|{!|{{!--|{{!) *TODO(?:[\\t\\f\\v ]*\\([^\\r\\n)]+\\))?:?)((?!\\w)(?: *-->| *\\*/| *!}| *--}}| *}}|(?= *(?:[^\\r\\n:]//|/\\*+|<!--|@|--|{!|{{!--|{{!))|(?: +[^\\r\\n@]*?)(?= *(?:[^\\r\\n:]//|/\\*+|<!--|@|--(?!>)|{!|{{!--|{{!))|(?: +[^\\r\\n@]+)?))": {
            "filterFileRegex": ".*(?<!CHANGELOG.md)$",
            "decorations": [
                {
                    "overviewRulerColor": "#ffcc00",
                    "backgroundColor": "#ffcc00",
                    "color": "#1f1f1f",
                    "fontWeight": "bold"
                },
                {
                    "backgroundColor": "#ffcc00",
                    "color": "#1f1f1f"
                }
            ]
        },
        "((?:<!-- *)?(?:#|// @|//|./\\*+|<!--|--|\\* @|{!|{{!--|{{!) *(?:FIXME|FIX|BUG|UGLY|DEBUG|HACK)(?:[\\t\\f\\v ]*\\([^\\r\\n)]+\\))?:?)((?!\\w)(?: *-->| *\\*/| *!}| *--}}| *}}|(?= *(?:[^\\r\\n:]//|/\\*+|<!--|@|--|{!|{{!--|{{!))|(?: +[^\\r\\n@]*?)(?= *(?:[^\\r\\n:]//|/\\*+|<!--|@|--(?!>)|{!|{{!--|{{!))|(?: +[^\\r\\n@]+)?))": {
            "filterFileRegex": ".*(?<!CHANGELOG.md)$",
            "decorations": [
                {
                    "overviewRulerColor": "#cc0000",
                    "backgroundColor": "#cc0000",
                    "color": "#1f1f1f",
                    "fontWeight": "bold"
                },
                {
                    "backgroundColor": "#cc0000",
                    "color": "#1f1f1f"
                }
            ]
        }
    },
    "workbench.iconTheme": "vscode-icons",
    "workbench.secondarySideBar.defaultVisibility": "hidden",
    "files.associations": {
        "*.ts": "typescript"
    },
    "typescript.tsdk": "node_modules/typescript/lib",
    "typescript.enablePromptUseWorkspaceTsdk": true,
    "gitlens.views.commitDetails.files.layout": "list",
    "yaml.disableSchemaDetection": [
        "**/.github/workflows/*.yml",
        "**/.github/workflows/*.yaml",
        "**/.gitea/workflows/*.yml",
        "**/.gitea/workflows/*.yaml",
        "**/.forgejo/workflows/*.yml",
        "**/.forgejo/workflows/*.yaml"
    ],
    "git.blame.editorDecoration.enabled": true,
    "chat.editor.claude.preferAgentHost": true,
    "chat.viewSessions.orientation": "stacked"
}
```

> 참고: 원본 settings.json에는 이 PC 로컬 경로에 묶인 `yaml.schemas`(continue 확장 스키마) 항목이 있으나, 다른 계정에서는 경로가 달라 무의미하므로 export에서 제외했습니다.

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
- Claude Code: 패널 위치, 자동저장 off, 위험권한 허용, agent host 선호
- GitLens AI: Copilot GPT-4.1 사용 / commit details 파일 목록은 list 레이아웃
- Highlight: TODO(노랑) / FIXME·BUG·HACK 등(빨강) 강조 (CHANGELOG.md 제외)
- TS: 워크스페이스 tsdk(`node_modules/typescript/lib`) 우선
- 단축키: `Cmd+L` → Claude 사이드바, `Shift+Cmd+S` → 전체 저장
