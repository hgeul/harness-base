---
description: dod-checker 서브에이전트로 현재 브랜치의 완료 직전 검수를 수행한다
---

# /dod — Definition of Done 검수

공통 판단 기준은 `harness/reviews/dod.md`다. 이 파일은 Claude Code 호출 어댑터다.

`.claude/agents/dod-checker.md` 의 dod-checker 서브에이전트를 호출하여, 현재 브랜치의
변경(커밋된 것 + 미커밋 + untracked)을 `<BASE_BRANCH>` 와 비교 검수한다.

검수 범위 인자: $ARGUMENTS

## 실행 절차

1. **인자 파싱**:
   - `$ARGUMENTS` 가 비어있으면 현재 브랜치 (`git rev-parse --abbrev-ref HEAD`)
   - 비어있지 않으면 인자를 검수 대상 브랜치명으로 해석

2. **에이전트 호출**: Agent 도구로 `subagent_type=dod-checker` 실행.

   전달 프롬프트:
   ```
   대상 브랜치: <위에서 결정한 브랜치명>
   .claude/agents/dod-checker.md 의 검증 항목을 모두 수행하라.
   각 항목 결과를 PASS/FAIL/WARN/N/A 로 분류하고, "출력 형식" 양식대로 보고하라.
   FAIL 이 있으면 자동 수정하지 말고 발견 사항만 보고. 추측 금지 — 실제 명령어 실행 결과로.
   ```

3. **결과 처리**:
   - 에이전트 보고를 사용자에게 그대로 전달
   - FAIL 항목이 있으면 사용자 수정 지시 전까지 자동 수정하지 않음
   - WARN 만 있으면 "보류 vs 진행" 을 사용자에게 묻는다

## 사용 시점

- 기능 작업이 끝났다고 느낄 때 (사용자에게 "완료" 보고 직전)
- PR 본문 작성 직전 / 머지 직전 자가 검수

권장 순서: `/grill`(중요한 결정이 있을 때) → 보완 → progress 갱신 → `/dod` → PR

검수 전에 `docs/progress/`에 실제 결과·검증·미완료·다음 작업을 반영하고, 완료된 항목은 backlog에서 정리한다. 중요한 결정이 없었다면 ADR을 억지로 만들지 않는다.
