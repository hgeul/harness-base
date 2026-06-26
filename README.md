# harness-base

AI 하네스 엔지니어링의 **재사용 가능한 BASE(엔진)**. 프로젝트 무관 골격만 담는다.
고객명·도메인 규칙·docs 같은 PROJECT overlay 는 여기 없다. 각 프로젝트에서 로컬로 작성한다.

> 이 repo 는 push 해도 안전하다 (고객 자료 0). 단, 프로젝트에 깐 뒤 생기는
> overlay(rules)·docs 는 **절대 이 repo 로 올리지 않는다**. 그건 프로젝트 로컬에만.

## 무엇이 들어있나 (BASE)

- `CLAUDE.template.md` — 루트 CLAUDE.md 템플릿 (워크플로 / 검증우선순위 / 의도기록)
- `HARNESS.md` — BASE/overlay 분리 원칙과 이식 절차
- `.claude/commands/` — grill, dod, drift 호출부 (범용)
- `.claude/agents/` — design-grill, dod-checker, drift-detector 골격 (도메인 부분은 placeholder)
- `.claude/scripts/` — drift-anchors.sh(Tier1 검사), hz.sh(평행 git-dir 래퍼)
- `.claude/hooks/pre-commit-check.sh` — 커밋 게이트 (토큰은 CONFIG 블록 변수)
- `.claude/rules/_TEMPLATE.md` — 도메인 규칙 작성 가이드
- `.claude/ssot-index.template.md` — 진실 원천 등록부 템플릿
- `docs/*/_TEMPLATE.md` — ADR / feature / spec / policy 템플릿

## 새 프로젝트에 까는 법 (이식 절차)

1. 이 BASE 를 프로젝트 `.claude/` 등으로 복사 (또는 clone 후 `.git` 제거).
2. `CLAUDE.template.md` → 프로젝트 루트 `CLAUDE.md` 로 두고 `<...>` placeholder 채우기.
3. `.claude/hooks/pre-commit-check.sh` 상단 CONFIG 블록(채널·분류 토큰, 보호 브랜치) 수정.
4. `.claude/rules/` 에 도메인 규칙 작성 (이 프로젝트의 "옳은 것"의 정의).
5. `.claude/agents/dod-checker.md` 의 PROJECT 검증항목, `design-grill.md` 의 질문 축 작성.
6. `.claude/ssot-index.template.md` → `ssot-index.md` 로 두고 등록부 채우기.
7. 골격(워크플로·출력형식·행동원칙·drift 엔진)은 **건드리지 않는다**.

자세한 분리 기준은 `HARNESS.md`.

## 하네스 변경 이력을 로컬로만 남기려면 (선택)

프로젝트 코드와 분리해 하네스만 버전관리하려면 `hz.sh`(평행 git-dir) 사용:

```bash
git init --bare "$HOME/.<프로젝트명>-harness.git"
printf '/*\n!/.claude\n!/docs\n!/CLAUDE.md\n' > "$HOME/.<프로젝트명>-harness.git/info/exclude"
bash .claude/scripts/hz.sh config status.showUntrackedFiles no
bash .claude/scripts/hz.sh add .claude docs CLAUDE.md
bash .claude/scripts/hz.sh commit -m "harness: 초기 스냅샷"
```

remote 를 안 붙이면 push 불가 = 영원히 로컬. 고객 자료가 섞인 프로젝트는 이 방식으로.
