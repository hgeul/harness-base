---
name: dod
description: 프로젝트 변경이 완료, 커밋, 인수인계 또는 PR 검토 준비 상태일 때 사용한다.
---

# 완료 정의

스테이징된 파일만이 아니라 변경 전체를 검토한다. 파일을 자동 수정하거나 `WARN`을 진행 허가로 바꾸지 않는다.

## 범위

`AGENTS.md`, `.codex/harness-context.md`, `.codex/ssot-index.md`를 읽고 기준선 diff, staged, unstaged, untracked 파일의 합집합을 확인한다. 변경을 프로토콜·데이터·설정·구현·문서·운영 기록으로 분류한다.

## 점검

| 항목 | 확인 내용 |
|---|---|
| A. 범위 | 기준선과 committed/staged/unstaged/untracked 수가 명확하다. |
| B. 비밀정보 | API key, password, token, 개인정보, 원본 민감 payload가 없다. |
| C. 정본·계약 | 변경된 현재 규칙, API, schema, migration, 호환성의 version/reason/impact가 남아 있다. |
| D. 데이터·권한 | 시간 의미, 계보, 정정, 접근 통제, 실행 경계를 보존한다. |
| E. 재현성 | 관련 실행이 입력·config·code hash·seed·환경·시각을 식별한다. |
| F. 용어·링크 | 정본 용어와 상대 링크가 일치한다. 변경 Markdown은 anchor checker를 실행한다. |
| G. 운영 기록 | 의미 있는 작업에 progress가 있고, 중요한 다중 문서 결정에는 ADR이 있다. |
| H. 검증 | `git diff --check`와 직접 관련된 test/lint/type/schema 검증을 실행했다. |
| I. 커밋 메시지 | 커밋 설명은 프로젝트가 정한 언어로 쓴다. 제품·도구 이름, 코드 식별자, CLI 명령은 원문을 보존한다. |

각 항목을 `PASS`, `FAIL`, `WARN`, `N/A`와 파일:줄 또는 문서 절 근거로 보고한다.
