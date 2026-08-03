#!/usr/bin/env bash
# ECC 스킬을 ~/.claude/skills 로 심링크하고(Obsidian claude-code-skills 플러그인이
# 이 경로만 읽음), ~/.claude/settings.json 의 skillOverrides 를 재생성한다.
#   - 심링크로 생긴 맨이름 중복 스킬: 전부 "off" (모델 목록 중복 제거)
#   - 현재 스택과 무관한 도메인의 ecc:* 스킬: "name-only" (이름만 노출, 필요 시 모델이 꺼내 씀)
# 멱등: 몇 번을 다시 돌려도 같은 결과. ECC 서브모듈 업데이트 후 재실행하면 된다.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_SRC="$REPO_DIR/claude/plugins/ecc/skills"
SKILLS_DST="$HOME/.claude/skills"
SETTINGS="$HOME/.claude/settings.json"

[ -d "$SKILLS_SRC" ] || { echo "ECC 서브모듈 없음: git submodule update --init claude/plugins/ecc"; exit 1; }
mkdir -p "$SKILLS_DST"

linked=0
for d in "$SKILLS_SRC"/*/; do
  name="$(basename "$d")"
  [ -f "$d/SKILL.md" ] || continue
  if [ ! -e "$SKILLS_DST/$name" ]; then
    ln -s "$SKILLS_SRC/$name" "$SKILLS_DST/$name"
    linked=$((linked+1))
  fi
done
echo "symlinked: $linked new (total $(find "$SKILLS_DST" -maxdepth 1 -type l | wc -l | tr -d ' '))"

SKILLS_SRC="$SKILLS_SRC" SETTINGS="$SETTINGS" python3 <<'PYEOF'
import json, os, re

skills_src = os.environ['SKILLS_SRC']
settings_path = os.environ['SETTINGS']

skills = sorted(
    d for d in os.listdir(skills_src)
    if os.path.isfile(os.path.join(skills_src, d, 'SKILL.md'))
)

# 지금 안 쓰는 도메인: 이름만 목록에 남긴다(name-only). 스택이 바뀌면 여기서 패턴을 빼면 됨.
deny_patterns = [
    r'^healthcare-', r'^hipaa-',
    r'^energy-procurement', r'^customs-trade-compliance',
    r'^ito-', r'^homelab-', r'^cisco-ios', r'^netmiko-', r'^network-bgp', r'^network-config-validation', r'^network-interface-health',
    r'^carrier-relationship', r'^logistics-exception', r'^returns-reverse', r'^inventory-demand', r'^production-scheduling', r'^quality-nonconformance',
    r'^visa-doc-translate',
    r'^defi-amm', r'^evm-token', r'^llm-trading-agent', r'^prediction-market-', r'^nodejs-keccak256',
    r'^blender-', r'^manim-video', r'^remotion-', r'^video-editing', r'^videodb', r'^fal-ai-media',
    r'^scientific-',
    r'^android-clean-architecture', r'^compose-multiplatform', r'^kotlin-', r'^swift-', r'^swiftui-', r'^dart-flutter', r'^flutter-dart', r'^foundation-models-on-device', r'^ios-icon-gen',
    r'^rust-', r'^golang-', r'^java-coding-standards', r'^jpa-patterns', r'^springboot-', r'^quarkus-', r'^laravel-', r'^perl-', r'^csharp-testing', r'^dotnet-patterns', r'^fsharp-testing',
    r'^django-', r'^fastapi-patterns', r'^pytorch-', r'^recsys-pipeline', r'^clickhouse-io', r'^tinystruct', r'^nutrient-document',
    r'^finance-billing-ops$', r'^customer-billing-ops$',
    r'^investor-', r'^brand-', r'^marketing-campaign$', r'^content-engine$', r'^crosspost$', r'^social-publisher$', r'^social-graph-ranker$', r'^connections-optimizer$', r'^seo$', r'^article-writing$',
    r'^competitive-platform-analysis$', r'^benchmark-methodology$', r'^competitive-report-structure$', r'^market-research$', r'^lead-intelligence$', r'^x-api$',
    r'^mysql-patterns$',
    r'^harmonyos', r'^react-native-patterns$',
    r'^windows-desktop-e2e$',
    r'^mle-workflow$', r'^ml-adoption-playbook$',
]

cfg = json.load(open(settings_path))
ov = cfg.setdefault('skillOverrides', {})

# 이 스크립트가 관리하는 키만 지우고 재생성 (사용자가 직접 넣은 다른 오버라이드는 보존)
for k in [k for k in ov if k in skills or (k.startswith('ecc:') and k[4:] in skills)]:
    del ov[k]

deny = [s for s in skills if any(re.search(p, s) for p in deny_patterns)]
for s in skills:
    ov[s] = 'off'
for s in deny:
    ov[f'ecc:{s}'] = 'name-only'

json.dump(cfg, open(settings_path, 'w'), indent=2, ensure_ascii=False)
print(f"skillOverrides: {len(skills)} bare off, {len(deny)} ecc name-only")
PYEOF
