# 공통 에이전트 작업 계약

Claude Code, Codex와 이후 런타임이 같은 방식으로 따른다. 런타임별 호출 문법·자동 import·도구 실행만 각 adapter에 둔다.

## 세션 시작

1. `harness/project-context.md`에서 현재 목표와 권위 문서를 확인한다.
2. `harness/ssot-index.md`에서 진실 기준을 확인한다.
3. `docs/progress/`를 이름순 정렬해 마지막 파일의 `다음 작업`을 확인한다.
4. `docs/backlog/작업목록.md`에서 수행할 항목을 고른다.
5. 작업 관련 정본과 `harness/rules/`를 읽는다.

과거 progress는 당시 실행 사실이지 현재 정본이 아니다. 충돌하면 SSOT 인덱스에 등록된 권위 원천을 따른다.

## 작업과 검수

생산은 AI가 하고, 사람의 주된 역할은 검증과 판단이다.

1. 작업한다.
2. 되돌리기 어렵거나 여러 작업에 영향을 주는 설계는 Grill로 검토하고 중요한 선택을 ADR로 남긴다.
3. 실제 결과·검증·미완료·다음 작업을 progress에 기록한다.
4. 완료·인수인계·PR 전에는 DoD를 실행한다.
5. 큰 변경 뒤 또는 정기적으로 Drift를 실행한다. 정책 변경 전 또는 정기적으로 Policy Audit을 실행한다.

작업은 feature 브랜치에서 한다. 보호 브랜치 직접 커밋은 Git hook이 차단한다. 검수는 기준선 대비 committed, staged, unstaged, untracked 변경을 모두 포함한다.

## 규칙·커밋·기록

- 매칭 파일을 수정하기 전에 관련 `harness/rules/`를 적용한다.
- `harness/commit-convention.md`와 `.githooks/config`을 따른다. AI 도구 언급·공동저자 트레일러는 금지한다.
- 철저 검증 대상: 외부 연동 요청·응답, 푸시·알림 payload, migration, 권한·격리, 응답 DTO의 민감정보. 내부 헬퍼·중간 상태는 가볍게 검증한다.
- backlog는 현재 남은 일만 둔다. 완료 결과는 progress로 연결하고 항목을 제거한다.
- 중요한 다중 문서·구현 선택은 ADR로 남긴다. 단순 실행 결과는 progress에만 남긴다.
- API key, password, token, 개인정보, 원본 민감 payload, 채팅 전문, 긴 명령 출력은 문서·로그·커밋에 기록하지 않는다.

## 세션 종료

1. 실제 결과와 검증 근거를 progress에 기록한다.
2. 중요한 선택이 있었다면 ADR을 작성하고 progress에서 연결한다.
3. 완료 backlog 항목을 제거하고 확정된 후속 작업을 반영한다.
4. 현재 기준이 바뀐 경우에만 정본과 SSOT 인덱스를 갱신한다.
5. 다음 작업을 선행 조건과 완료 기준까지 포함해 적는다.
