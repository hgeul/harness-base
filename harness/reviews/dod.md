# dod 계약

완료·커밋·인수인계·PR 직전에 변경 전체를 검수한다. 자동 수정하지 않으며 `WARN`을 진행 허가로 바꾸지 않는다.

## 범위

기준선 diff, committed, staged, unstaged, untracked를 합쳐 본다. 변경을 프로토콜·데이터·설정·구현·문서·운영 기록으로 분류한다. 한글 경로를 다루는 Git 명령에는 `-c core.quotepath=false`를 사용한다.

## 공통 항목

각 항목은 `PASS`, `FAIL`, `WARN`, `N/A`와 파일:줄 또는 문서 절 근거를 보고한다.

| 항목 | 확인 |
|---|---|
| A. 범위 | 기준선과 committed/staged/unstaged/untracked 수 |
| B. 비밀정보 | credential·개인정보·민감 원본 payload 없음 |
| C. 정본·계약 | 현재 규칙, API, schema, migration, 호환성의 version/reason/impact |
| D. 데이터·권한 | 시간 의미, 계보, 정정, 접근 통제, 실행 경계 |
| E. 재현성 | 입력, config, code hash, seed, 환경, 시각 |
| F. 용어·링크 | 정본 용어·상대 링크·Markdown anchor 검사 |
| G. 운영 기록 | 의미 있는 progress, 중요한 다중 문서 결정의 ADR |
| H. 검증 | `git diff --check`와 관련 test/lint/type/schema |
| I. 커밋 메시지 | 프로젝트 지정 언어. 제품·도구명, 코드 식별자, CLI는 원문 유지 |

`PROJECT` 검증은 도메인 규칙마다 결정론적 검출 명령과 PASS/FAIL/WARN 기준을 추가한다. 검출 불가 항목은 `N/A`가 아니라 `WARN`으로 사람 확인을 요청한다.
