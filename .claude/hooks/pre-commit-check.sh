#!/bin/bash
#
# Claude Code PreToolUse Hook - 커밋 전 게이트 [BASE]
#
# 프로젝트별로 고칠 것은 아래 CONFIG 블록과 print_checklist() 뿐이다.
#
# 흐름:
#   1. JSON 입력에서 tool_input.command 추출
#   2. 토큰 단위로 'git commit' 아니면 즉시 통과
#   3. 보호 브랜치면 차단
#   4. 메시지에서 AI 도구 언급 차단 + [채널][분류] prefix 형식 검증
#   5. 통과하면 체크리스트 출력 (soft reminder)

# ── CONFIG [PROJECT] ──────────────────────────────────────────────
PROTECTED_BRANCHES="main master develop"   # 직접 커밋 금지 브랜치 (공백 구분)
# 기본값에 main 을 포함한다. 빠뜨리면 훅이 경고 없이 통과시켜 게이트가 조용히 꺼진다.
MSG_CHANNELS="관리자|멤버|공통"             # [채널] 토큰
MSG_TYPES="추가|수정|삭제|테스트|문서"      # [분류] 토큰
# 체크리스트 본문은 파일 하단 print_checklist() 에서 프로젝트에 맞게 수정.
# ──────────────────────────────────────────────────────────────────

input=$(cat)

# ── 1. JSON에서 command 추출 ──
if command -v jq > /dev/null 2>&1; then
  command_str=$(echo "$input" | jq -r '.tool_input.command // empty')
else
  command_str=$(echo "$input" | python -c 'import sys, json
try:
    print(json.loads(sys.stdin.read()).get("tool_input", {}).get("command", ""))
except Exception:
    pass' 2>/dev/null)
fi
[ -z "$command_str" ] && exit 0

# ── 2. git commit 호출 여부 (토큰 단위) ──
if ! echo "$command_str" | grep -qE '(^|[[:space:]]|;|&&|\|\|)git[[:space:]]+commit([[:space:]]|$)'; then
  exit 0
fi

branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

# ── 3. 보호 브랜치 직접 커밋 차단 ──
for b in $PROTECTED_BRANCHES; do
  if [ "$branch" = "$b" ]; then
    echo "[BLOCKED] '$branch' 브랜치에 직접 커밋할 수 없습니다."
    echo ""
    echo "feature 브랜치를 먼저 생성하세요:"
    echo "  git checkout -b feature/<짧은-요약>"
    exit 2
  fi
done

# ── 4. 커밋 메시지 추출 (heredoc / 큰따옴표 / 작은따옴표) ──
extract_commit_msg() {
  CMD_INPUT="$1" python <<'PYEOF' 2>/dev/null
import os, re
cmd = os.environ.get("CMD_INPUT", "")
heredoc = re.search(r"<<\s*['\"]?([A-Za-z_][A-Za-z0-9_]*)['\"]?\s*\n(.*?)\n\s*\1\s*", cmd, re.S)
if heredoc:
    print(heredoc.group(2))
else:
    m = re.search(r'-m\s+"((?:[^"\\]|\\.)*)"', cmd)
    if m: print(m.group(1))
    else:
        m = re.search(r"-m\s+'([^']*)'", cmd)
        if m: print(m.group(1))
PYEOF
}

commit_msg=$(extract_commit_msg "$command_str")

if [ -n "$commit_msg" ]; then
  # ── 4a. AI 도구 / 공동저자 / 이모지 차단 (합법 참조는 정제 후 검사) ──
  msg_for_scan=$(echo "$commit_msg" \
    | sed -E 's/CLAUDE(\.[A-Za-z0-9_-]+)*\.md//gI' \
    | sed -E 's|\.claude/[A-Za-z0-9_./-]*||gI' \
    | sed -E 's/\.claude\b//gI')
  # LC_ALL=C: UTF-8 로케일의 grep 이 BMP 밖 이모지를 매치하지 못해 차단이 조용히 죽는다.
  if echo "$msg_for_scan" | LC_ALL=C grep -iE 'Co-Authored-By:|generated with|🤖|Claude|ChatGPT|Copilot' > /dev/null; then
    echo "[BLOCKED] 커밋 메시지에 AI 도구 언급 또는 공동저자 트레일러가 포함되어 있습니다."
    echo "  - AI 도구 언급 / Co-Authored-By / 이모지 제거 후 다시 커밋"
    exit 2
  fi

  # ── 4b. [채널][분류] prefix 검증 ──
  first_line=$(echo "$commit_msg" | head -1)
  if ! echo "$first_line" | grep -qE "^\[(${MSG_CHANNELS})\]\[(${MSG_TYPES})\][[:space:]]+.+"; then
    echo "[BLOCKED] 커밋 메시지 형식이 올바르지 않습니다."
    echo ""
    echo "현재 첫 줄: $first_line"
    echo "필수 형식: [${MSG_CHANNELS}][${MSG_TYPES}] <설명>"
    exit 2
  fi
fi

# ── 5. 체크리스트 (soft reminder) ──
print_checklist() {
  echo "======================================"
  echo " 커밋 전 체크리스트  (브랜치: $branch)"
  echo "======================================"
  echo "[공통 비협상]"
  echo "  □ TODO / FIXME / dummy 코드 없음"
  echo "  □ 하드코딩된 시크릿/계정/엔드포인트 없음 (env/config)"
  echo "  □ AI 도구 언급 / Co-Authored-By / 이모지 없음"
  echo ""
  echo "[PROJECT 체크 — 여기를 프로젝트에 맞게 채운다]"
  echo "  □ (예) 신규 외부 호출 → timeout 명시 / 자동 재시도 금지"
  echo "  □ (예) 권한/격리 조건 누락 없음"
  echo "  □ 완료 보고 직전 → /dod 실행"
  echo "======================================"
}
print_checklist

exit 0
