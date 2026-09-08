# <PROJECT_NAME> 작업 지침

> Claude Code adapter. 이 파일은 프로젝트 루트의 `CLAUDE.md`로 두며 매 턴 자동 로드된다.
> 공통 지침은 `harness/agent-workflow.md`다.

@harness/agent-workflow.md

## Claude Code 호출 방식

- 설계 검토: `/grill`
- 완료 검수: `/dod`
- SSOT 드리프트: `/drift`
- 정책 감사: `/policy-audit`

## 자동 적용 규칙 [PROJECT overlay]

관련 규칙을 수정 전에 읽는다. Claude Code에서 항상 적용할 도메인 규칙만 아래에 import한다.

@harness/rules/<도메인-규칙-1>.md
@harness/rules/<도메인-규칙-2>.md
