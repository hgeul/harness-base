#!/usr/bin/env bash
# Tier 1 드리프트 감지 [BASE]: 문서의 코드 앵커 무결성 (결정론)
#
# 문서(rule/policy/ADR/CLAUDE.md/ssot-index)의 `File.ext:line` 앵커가
# 실제 파일/라인에 resolve 되는지 검사한다. resolve 실패 = 드리프트 신호.
# "코드가 진실" 원칙: 문서가 사라진 파일/범위 밖 라인을 가리키면 문서가 틀린 것.
#
# 외부 도구가 관리하는 marker 블록(<!-- x:start -->...<!-- x:end -->)은 제외한다.
#
# 사용: bash .claude/scripts/drift-anchors.sh [--strict] [문서경로...]
#   --strict   드리프트가 1건 이상이면 exit 1 (게이트용)
#   문서경로    생략 시 DOC_TARGETS 전체. 주면 그 파일만 (dod diff 범위용)

set -u
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT" || exit 0

STRICT=0
if [ "${1:-}" = "--strict" ]; then STRICT=1; shift; fi

# [PROJECT overlay] 검사 대상 문서 + 소스 확장자. 다른 프로젝트는 여기만 조정.
DOC_TARGETS=(
  "CLAUDE.md"
  ".claude/rules"
  "harness/ssot-index.md"
  "docs/policy"
  "docs/decisions"
  "docs/feature"
  "docs/spec"
  "docs/backlog"
)
# docs/backlog 는 포함한다: "지금 남은 일"이라 앵커가 썩으면 잘못된 작업 지시가 된다.
# docs/progress 는 일부러 뺀다: 당시 실행 사실의 기록이므로 앵커가 과거를 가리키는 게 정상이고,
#   넣으면 시간이 갈수록 노이즈만 늘어 Tier1 신호가 죽는다. 이 판단을 되돌리지 말 것.
#   (근거: HARNESS.md 「기록 수명주기」, harness/ssot-index.md 「문서 수명주기 지도」)
SRC_EXT="java"          # 앵커 대상 소스 확장자 (예: java, ts, py, go)
SRC_ROOT="src"          # 소스 검색 루트

if [ "$#" -gt 0 ]; then DOC_TARGETS=("$@"); fi

strip_marker_blocks() {
  awk '
    /<!--[[:space:]]*[A-Za-z0-9_-]+:start[[:space:]]*-->/ { inblk=1; next }
    /<!--[[:space:]]*[A-Za-z0-9_-]+:end[[:space:]]*-->/   { inblk=0; next }
    inblk==0 { print }
  '
}

docfiles=$(
  for g in "${DOC_TARGETS[@]}"; do
    if [ -d "$g" ]; then find "$g" -name '*.md' 2>/dev/null
    elif [ -f "$g" ]; then echo "$g"
    fi
  done | sort -u
)

drift=0
checked=0

# 파이프 대신 프로세스 치환: 파이프면 서브셸이 되어 drift/checked 카운터가 유실되고
# --strict 게이트가 항상 통과한다. 파일명 공백 대비로 while read 는 유지한다.
while IFS= read -r doc; do
  [ -n "$doc" ] && [ -f "$doc" ] || continue
  anchors=$(strip_marker_blocks < "$doc" \
    | grep -oE "[A-Za-z0-9_./-]+\.${SRC_EXT}:[0-9]+" | sort -u)
  for a in $anchors; do
    checked=$((checked + 1))
    path="${a%%:*}"; line="${a##*:}"
    target=""
    if [ -f "$path" ]; then
      target="$path"
    else
      base="$(basename "$path")"
      hits="$(find "$SRC_ROOT" -name "$base" 2>/dev/null)"
      n="$(printf '%s\n' "$hits" | grep -c .)"
      if [ "$n" -eq 1 ]; then
        target="$hits"
      elif [ "$n" -gt 1 ]; then
        echo "DRIFT(ambiguous) $doc -> $a : '$base' 가 $n 곳에 존재"
        drift=$((drift + 1)); continue
      fi
    fi
    if [ -z "$target" ]; then
      echo "DRIFT(missing-file) $doc -> $a"
      drift=$((drift + 1)); continue
    fi
    total="$(wc -l < "$target" | tr -d ' ')"
    if [ "$line" -gt "$total" ]; then
      echo "DRIFT(line-oob) $doc -> $a (대상 파일 $total 줄)"
      drift=$((drift + 1))
    fi
  done
done < <(printf '%s
' "$docfiles")

echo "---"
echo "anchors_checked=$checked drift=$drift"
echo "주의: File.${SRC_EXT}:line 형태만 검사한다. 심볼/주장 모순은 Tier 2(LLM)가 본다."

if [ "$STRICT" = 1 ] && [ "$drift" -gt 0 ]; then exit 1; fi
exit 0
