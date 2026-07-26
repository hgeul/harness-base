# 하네스 구조 (BASE / PROJECT overlay)

이 하네스는 두 층으로 나뉜다. **BASE 는 그대로 이식**, **PROJECT overlay 만 새로 작성**한다.

- BASE = 만드는 방법(절차·골격·엔진). 프로젝트 무관.
- PROJECT overlay = 무엇이 옳은가(도메인 판단). 프로젝트 고유. 고객 자료.

## BASE (프로젝트 무관 — 그대로 이식)

| 파일 | BASE 부분 |
|---|---|
| `CLAUDE.md` | 워크플로 / 검증 우선순위 / 의도·결정 기록 절 |
| `.claude/commands/grill.md`, `dod.md`, `drift.md` | 호출부 + 실행 절차 |
| `.claude/agents/design-grill.md` | 역할·스캔범위·출력형식·행동원칙 골격 |
| `.claude/agents/dod-checker.md` | 검수 범위·출력형식·행동원칙 + 범용 항목(A/B/C/K/N) |
| `.claude/agents/drift-detector.md` | 진실기준 원칙·Tier1~3 절차·출력형식 |
| `.claude/scripts/drift-anchors.sh` | Tier1 앵커 무결성 (DOC_TARGETS 만 PROJECT) |
| `.claude/scripts/hz.sh` | 평행 git-dir 래퍼 (완전 범용) |
| `.claude/hooks/pre-commit-check.sh` | 게이트 로직 (CONFIG 블록 변수만 PROJECT) |
| `docs/decisions/_TEMPLATE.md` | ADR 템플릿 |
| `docs/feature/_TEMPLATE.md`, `docs/spec/_TEMPLATE.md` | 결정+이유 템플릿 |
| `docs/policy/README.md` | 정책 위키 운영 규칙 |
| `.claude/rules/_TEMPLATE.md` | 도메인 규칙 작성 가이드 |
| `.claude/ssot-index.template.md` | 진실 원천 등록부 템플릿 |

## PROJECT overlay (프로젝트마다 새로 작성 — 고객 자료, 공유 금지)

| 파일 | PROJECT 부분 |
|---|---|
| `CLAUDE.md` | 커밋 메시지 토큰 / 자동 적용 규칙 import 절 (채널·스택) |
| `.claude/rules/*.md` | 도메인 규칙. **100% 고유** |
| `.claude/agents/dod-checker.md` | PROJECT 검증항목 (도메인 검출 명령어) |
| `.claude/agents/design-grill.md` | 질문 축의 도메인 내용 |
| `.claude/ssot-index.md` | 진실 원천 등록부. **100% 고유** |
| `.claude/scripts/drift-anchors.sh` | `DOC_TARGETS` 배열 |
| `.claude/hooks/pre-commit-check.sh` | CONFIG 블록 (토큰·보호 브랜치) |
| `docs/**` | 정책·결정·회의·외부계약. **전부 고객 자료** |

## 이식 절차

1. BASE 복사
2. `CLAUDE.template.md` → `CLAUDE.md`, `<...>` placeholder 채우기
3. 훅 CONFIG 블록 수정 (토큰·보호 브랜치)
4. `.claude/rules/` 도메인 규칙 작성
5. `dod-checker` PROJECT 검증항목 / `design-grill` 질문 축 작성
6. `ssot-index.template.md` → `ssot-index.md` 등록부 채우기
7. 골격(워크플로·출력형식·행동원칙·drift 엔진)은 건드리지 않음

## 공유 경계 (중요)

- BASE 는 push 가능 (고객 자료 없음).
- PROJECT overlay + `docs/` 는 고객 기밀. **개인/공용 remote 로 push 금지.**
- 프로젝트 하네스 이력은 `hz.sh` 평행 git-dir(remote 없음)로 로컬에만.
- **기계 강제 (관례 아님)**: BASE 의 `.gitignore` 가 `docs/` 를 기본 제외한다(스켈레톤 `_TEMPLATE.md` 만 공유). 그래서 실제 ADR·정책·backlog 는 프로젝트가 공개 repo 여도 커밋되지 않는다. 이식 시 이 규칙을 지우지 말 것. 프로젝트 스택 ignore 는 그 아래에 덧붙인다.
  - 근거: docs/ 비공개가 문서 관례로만 있으면 새 프로젝트(특히 공개 GitHub Pages 블로그)에서 쉽게 유출된다. gitignore 로 못박아 기본값으로 만든다.
