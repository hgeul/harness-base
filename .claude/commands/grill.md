---
description: design-grill 서브에이전트로 PR/dod 직전 설계 판단 질문을 받고 ADR로 박제한다
argument-hint: "[브랜치명]"
---

# /grill — PR 전 설계 캐묻기 (grill-with-docs)

`.claude/agents/design-grill.md` 의 design-grill 서브에이전트를 호출하여,
현재 브랜치의 변경(커밋+미커밋+untracked)에 대해 **dod-checker(규칙 기계 검출)가
못 잡는 설계 판단 차원의 질문**을 받는다. 답변은 ADR 로 박제해 의도부채를 막는다.

검수 범위 인자: $ARGUMENTS

## 실행 절차

1. **인자 파싱**:
   - `$ARGUMENTS` 가 비어 있으면 현재 브랜치 (`git rev-parse --abbrev-ref HEAD`)
   - 비어 있지 않으면 인자를 대상 브랜치명으로 해석

2. **에이전트 호출**: Agent 도구로 `subagent_type=design-grill` 실행.

   전달 프롬프트:
   ```
   대상 브랜치: <위에서 결정한 브랜치명>

   .claude/agents/design-grill.md 의 질문 축을 따라 변경된 영역에 대해서만
   구체적(파일:라인 인용) 설계 질문을 생성하라.
   변경이 없는 축은 섹션 자체를 생략하라.
   자동 수정 금지, 점수화 금지. 추측 금지 — 실제 diff·파일에 근거한 질문만.
   사전에 .claude/rules/*.md 를 Read 로 로드하여 라인 인용을 정확히 한다.
   ```

3. **결과 처리**:
   - 에이전트 질문 목록을 사용자에게 그대로 전달
   - 사용자가 답하거나 보완한 후 다음 단계로 진행

4. **산출물 기록 (grill-with-docs)**:
   - 사용자가 질문에 답하면, 그 문답과 결정을 `docs/decisions/<브랜치>.md` 에 박제한다.
   - 파일이 없으면 `docs/decisions/_TEMPLATE.md` 를 복사해 생성, 있으면 append.
   - 기록 대상: 맥락 · 결정과 근거 · 버린 대안 · 기대는 가정 · 검증 방법 · 만료 조건 · 문답 로그.
   - 목적: 세션이 끝나도 "왜 이렇게 만들었나"가 휘발되지 않게, 다음 세션이 Read 로 재활용하게.
   - 기록 후 /dod 로 진행.

## /dod 와의 분담

| 도구 | 차원 | 결과 |
|---|---|---|
| `/grill` | 설계 판단 (Socratic) | 질문 목록 + ADR |
| `/dod` | 규칙 위반 (결정론) | PASS/FAIL/WARN |

권장 순서: **`/grill` → 보완 → docs/decisions 기록 → `/dod` → PR**
