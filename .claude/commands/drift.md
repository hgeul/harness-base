---
description: drift-detector 서브에이전트로 문서-코드 드리프트 전체 스윕 (SSOT 일관성)
argument-hint: "[도메인키 | full]"
---

# /drift — SSOT 드리프트 전체 스윕

`.claude/agents/drift-detector.md` 의 drift-detector 를 **full 모드**로 호출하여,
`.claude/ssot-index.md` 등록부 전체에 대해 문서가 코드와 어긋났는지 점검한다.
(dod 의 `[N]` 항목은 diff 범위만 본다. 이건 전체를 본다.)

대상 인자: $ARGUMENTS

## 실행 절차

1. **인자 파싱**: 비어있거나 `full` → 등록부 전체. 도메인 키 → 그 도메인만.

2. **에이전트 호출**: Agent 도구로 `subagent_type=drift-detector` 실행.
   ```
   모드: full
   대상: <전체 또는 지정 도메인>
   .claude/ssot-index.md 를 먼저 Read 하라.
   Tier 1(앵커, 스크립트) → Tier 2(주장↔코드 모순, LLM) → Tier 3(만료/신선도) 순.
   marker 블록은 INFO 만. 모든 DRIFT 는 문서·코드 양쪽 인용. 자동 수정 금지.
   ```

3. **결과 처리**:
   - 보고를 사용자에게 그대로 전달
   - DRIFT 항목은 "문서 갱신 / 코드 수정 / 무시" 중 사용자가 택하게
   - 해소한 항목은 ADR 에 한 줄 남기면 좋다

## 사용 시점

- 정기 점검 (주 1회, 스프린트 종료)
- 큰 리팩토링 직후 (여러 문서가 한 번에 낡는 변경)
- 새 팀원 합류 전 (낡은 문서로 잘못 배우는 것 방지)

## /dod [N] 과의 분담

| 도구 | 범위 | 시점 |
|---|---|---|
| `/dod [N]` | 이번 변경(diff)이 건드린 도메인만 | PR 직전 매번 |
| `/drift` | 등록부 전체 | 정기 / 큰 변경 후 |
