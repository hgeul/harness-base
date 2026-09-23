# harness-base

AI 하네스 엔지니어링의 **재사용 가능한 BASE(엔진)**. 프로젝트 무관 골격만 담는다.
고객명·도메인 규칙·docs 같은 PROJECT overlay 는 여기 없다. 각 프로젝트에서 로컬로 작성한다.

> 이 repo 는 push 해도 안전하다 (고객 자료 0). 단, 프로젝트에 깐 뒤 생기는
> overlay(rules)·docs 는 **절대 이 repo 로 올리지 않는다**. 그건 프로젝트 로컬에만.

기본값은 그대로다. 프로젝트 문서를 Git으로 공유해야 하는 경우에만 [SHARED_DOCS.md](./SHARED_DOCS.md)의 선택형 공유 모드를 명시적으로 채택한다.

## 무엇이 들어있나 (BASE)

- `harness/` — Claude Code·Codex 공통 컨텍스트, workflow, SSOT, 검수 계약의 단일 원천
- `CLAUDE.template.md`, `AGENTS.template.md` — 공통 workflow를 읽는 런타임별 진입 어댑터
- `HARNESS.md` — BASE/overlay 분리 원칙과 이식 절차
- `.claude/commands/` — grill, dod, drift, policy-audit 호출 어댑터
- `.claude/agents/` — Claude Code 서브에이전트 어댑터 (도메인 부분은 placeholder)
- `.claude/scripts/` — drift-anchors.sh(Tier1 검사), hz.sh(평행 git-dir 래퍼)
- `.githooks/` — Claude·Codex·사람에게 공통인 Git 커밋 게이트
- `harness/rules/_TEMPLATE.md` — 런타임 중립 도메인 규칙 작성 가이드
- `.codex/` — Codex Skill·PowerShell 앵커 검사 어댑터
- `docs/*/_TEMPLATE.md` — ADR / feature / spec / policy / backlog / progress 템플릿
- `harness-guide.html` — 이 하네스의 설계 의도 설명서 (단일 HTML, 브라우저로 바로 열림)

## 새 프로젝트에 까는 법 (이식 절차)

1. 이 BASE 를 프로젝트에 복사한다. Claude Code는 `.claude/`, Codex는 `.codex/`를 사용한다. **`.gitignore`도 함께 복사**한다: `docs/`(템플릿 제외)·`*.local`·`.env`를 기본 제외한다. 문서 공유는 [선택형 공유 모드](./SHARED_DOCS.md)를 명시적으로 채택할 때만 전환한다.
2. `harness/*.template.md`를 실제 파일로 복사하고 채운다. Claude Code는 `CLAUDE.template.md`를 `CLAUDE.md`로, Codex는 `AGENTS.template.md`를 `AGENTS.md`로 복사한다.
3. `git config core.hooksPath .githooks`로 공통 커밋 게이트를 설치하고 `.githooks/config`의 보호 브랜치·허용 type을 수정. 이 설정은 clone마다 필요하며, macOS/Linux에서는 `chmod +x .githooks/pre-commit .githooks/commit-msg`도 실행.
4. `harness/rules/`에 도메인 규칙 작성 (이 프로젝트의 "옳은 것"의 정의). Word·PDF 원본, 사내 중요 문서, 개인정보 자료는 `docs/_local/`에 둔다. 이 폴더는 항상 Git 제외다.
5. `.claude/agents/dod-checker.md` 의 PROJECT 검증항목, `design-grill.md` 의 질문 축 작성.
6. `docs/backlog/_TEMPLATE.md` → `docs/backlog/작업목록.md`, `docs/progress/_TEMPLATE.md` → `docs/progress/YYYY-MM-DD_작업명.md` 로 첫 기록 작성.
   진행기록 파일명은 날짜 접두사 필수(이름순 정렬 = 시간순), 작업명 한글 가능, 공백 금지.
7. `harness/ssot-index.template.md` → `harness/ssot-index.md`로 두고 등록부를 채운다.
8. Codex도 같은 `harness/` 공통 문서와 검수 계약을 사용한다.
9. 골격(워크플로·출력형식·행동원칙·drift 엔진)은 **건드리지 않는다**.

세션은 runtime adapter → `harness/agent-workflow.md` → 프로젝트 컨텍스트 → 최신 진행기록 → 작업목록 → 관련 정본 순으로 시작한다.

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
