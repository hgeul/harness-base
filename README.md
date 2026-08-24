# harness-base

AI 하네스 엔지니어링의 **재사용 가능한 BASE(엔진)**. 프로젝트 무관 골격만 담는다.
고객명·도메인 규칙·docs 같은 PROJECT overlay 는 여기 없다. 각 프로젝트에서 로컬로 작성한다.

> 이 repo 는 push 해도 안전하다 (고객 자료 0). 단, 프로젝트에 깐 뒤 생기는
> overlay(rules)·docs 는 **절대 이 repo 로 올리지 않는다**. 그건 프로젝트 로컬에만.

기본값은 그대로다. 프로젝트 문서를 Git으로 공유해야 하는 경우에만 [SHARED_DOCS.md](./SHARED_DOCS.md)의 선택형 공유 모드를 명시적으로 채택한다.

## 무엇이 들어있나 (BASE)

- `CLAUDE.template.md` — 루트 CLAUDE.md 템플릿 (워크플로 / 검증우선순위 / 의도기록)
- `HARNESS.md` — BASE/overlay 분리 원칙과 이식 절차
- `.claude/commands/` — grill, dod, drift 호출부 (범용)
- `.claude/agents/` — design-grill, dod-checker, drift-detector 골격 (도메인 부분은 placeholder)
- `.claude/scripts/` — drift-anchors.sh(Tier1 검사), hz.sh(평행 git-dir 래퍼)
- `.claude/hooks/pre-commit-check.sh` — 커밋 게이트 (토큰은 CONFIG 블록 변수)
- `.claude/rules/_TEMPLATE.md` — 도메인 규칙 작성 가이드
- `.claude/ssot-index.template.md` — 진실 원천 등록부 템플릿
- `.codex/` — Codex 컨텍스트·SSOT 템플릿, `grill`·`dod`·`drift`·`policy-audit` Skill, PowerShell 앵커 검사기
- `docs/*/_TEMPLATE.md` — ADR / feature / spec / policy / backlog / progress 템플릿
- `harness-guide.html` — 이 하네스의 설계 의도 설명서 (단일 HTML, 브라우저로 바로 열림)

## 새 프로젝트에 까는 법 (이식 절차)

1. 이 BASE 를 프로젝트에 복사한다. Claude Code는 `.claude/`, Codex는 `.codex/`를 사용한다. **`.gitignore`도 함께 복사**한다: `docs/`(템플릿 제외)·`*.local`·`.env`를 기본 제외한다. 문서 공유는 [선택형 공유 모드](./SHARED_DOCS.md)를 명시적으로 채택할 때만 전환한다.
2. `CLAUDE.template.md` → 프로젝트 루트 `CLAUDE.md` 로 두고 `<...>` placeholder 채우기.
3. `.claude/hooks/pre-commit-check.sh` 상단 CONFIG 블록(채널·분류 토큰, 보호 브랜치) 수정.
4. `.claude/rules/` 에 도메인 규칙 작성 (이 프로젝트의 "옳은 것"의 정의).
5. `.claude/agents/dod-checker.md` 의 PROJECT 검증항목, `design-grill.md` 의 질문 축 작성.
6. `docs/backlog/_TEMPLATE.md` → `docs/backlog/작업목록.md`, `docs/progress/_TEMPLATE.md` → `docs/progress/YYYY-MM-DD_작업명.md` 로 첫 기록 작성.
   진행기록 파일명은 날짜 접두사 필수(이름순 정렬 = 시간순), 작업명 한글 가능, 공백 금지.
7. `.claude/ssot-index.template.md` → `ssot-index.md` 로 두고 등록부 채우기.
8. Codex를 쓸 경우 `.codex/harness-context.template.md`, `.codex/ssot-index.template.md`를 프로젝트 파일명으로 복사하고 placeholder를 채운다.
9. 골격(워크플로·출력형식·행동원칙·drift 엔진)은 **건드리지 않는다**.

세션은 `CLAUDE.md → 프로젝트 컨텍스트/진입 문서 → 최신 진행기록 → 작업목록 → 관련 정본` 순서로 시작한다. 종료할 때는 실제 결과와 다음 시작점을 진행기록에 남기고, 중요한 선택이 있을 때만 ADR을 추가한다.

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
