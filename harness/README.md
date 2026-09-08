# 공통 하네스 계약

`harness/`는 Claude Code와 Codex가 함께 읽는 단일 정책 원천이다. 두 런타임의 `.claude/`와 `.codex/`는 명령 형식, 에이전트 등록, 스크립트처럼 실행 환경에만 필요한 어댑터다.

## 프로젝트 초기화

1. `harness/project-context.template.md`를 `harness/project-context.md`로 복사해 권위 문서와 민감 자료 경계를 채운다.
2. `harness/ssot-index.template.md`를 `harness/ssot-index.md`로 복사해 현재 진실 원천을 등록한다.
3. `CLAUDE.template.md`를 `CLAUDE.md`로, `AGENTS.template.md`를 `AGENTS.md`로 복사한다. 두 adapter는 같은 `harness/agent-workflow.md`를 따른다.
4. `harness/rules/`와 각 검수 계약의 `PROJECT` 절만 도메인에 맞게 채운다.

## 공통 검수 계약

- [설계 검토](./reviews/grill.md)
- [완료 정의](./reviews/dod.md)
- [SSOT 드리프트](./reviews/drift.md)
- [정책 감사](./reviews/policy-audit.md)
- [커밋 메시지 규약](./commit-convention.md)

실행 이름은 두 런타임에서 모두 `grill`, `dod`, `drift`, `policy-audit`다. Claude Code는 `/이름` 명령과 서브에이전트, Codex는 `$이름` Skill을 사용한다.
