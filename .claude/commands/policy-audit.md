---
description: policy-auditor 서브에이전트로 저장소 전반의 반복 정책 준수와 정책 노후화를 측정한다
argument-hint: "[범위]"
---

# /policy-audit — 정책 감사

공통 판단 기준은 `harness/reviews/policy-audit.md`다. 이 파일은 Claude Code 호출 어댑터다.

`Agent` 도구로 `subagent_type=policy-auditor`를 호출한다. `harness/ssot-index.md`, 프로젝트 규칙, 지정 범위(없으면 저장소 전체)를 읽고 계약의 각 축에 대해 범위·분모·분자·제외 대상·대표 예외 최대 다섯 개를 보고하게 한다.

자동 수정·실패 판정은 금지한다. 결과는 정책 변경 또는 후속 작업의 근거다.
