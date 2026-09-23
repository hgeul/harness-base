# 하네스 구조 (BASE / PROJECT overlay)

이 하네스는 두 층으로 나뉜다. **BASE 는 그대로 이식**, **PROJECT overlay 만 새로 작성**한다.

- BASE = 만드는 방법(절차·골격·엔진). 프로젝트 무관.
- PROJECT overlay = 무엇이 옳은가(도메인 판단). 프로젝트 고유. 고객 자료.

## BASE (프로젝트 무관 — 그대로 이식)

| 파일 | BASE 부분 |
|---|---|
| `harness/agent-workflow.md` | Claude Code·Codex 공통 세션·검수·기록 계약 |
| `harness/` | Claude Code·Codex 공통 컨텍스트·SSOT·검수 계약 단일 원천 |
| `CLAUDE.template.md`, `AGENTS.template.md` | 런타임별 진입 어댑터 |
| `.claude/commands/grill.md`, `dod.md`, `drift.md`, `policy-audit.md` | Claude Code 호출 어댑터 + 실행 절차 |
| `.claude/agents/design-grill.md` | 역할·스캔범위·출력형식·행동원칙 골격 |
| `.claude/agents/dod-checker.md` | 검수 범위·출력형식·행동원칙 + 범용 항목(A/B/C/K/N) |
| `.claude/agents/drift-detector.md` | 진실기준 원칙·Tier1~3 절차·출력형식 |
| `.claude/scripts/drift-anchors.sh` | Tier1 앵커 무결성 (DOC_TARGETS 만 PROJECT) |
| `.claude/scripts/hz.sh` | 평행 git-dir 래퍼 (완전 범용) |
| `.githooks/` | Claude·Codex·사람 공통 Git 커밋 게이트 (CONFIG만 PROJECT) |
| `docs/decisions/_TEMPLATE.md` | ADR 템플릿 |
| `docs/feature/_TEMPLATE.md`, `docs/spec/_TEMPLATE.md` | 결정+이유 템플릿 |
| `docs/backlog/_TEMPLATE.md` | 결정됐지만 미완료인 작업의 인수인계 템플릿 |
| `docs/progress/_TEMPLATE.md` | 세션·작업 단위의 실제 결과와 다음 시작점 템플릿 |
| `docs/policy/README.md` | 정책 위키 운영 규칙 |
| `harness/rules/_TEMPLATE.md` | 런타임 중립 도메인 규칙 작성 가이드 |
| `.codex/skills/{grill,dod,drift,policy-audit}/` | Codex 검수 Skill 어댑터 |
| `.codex/scripts/test-anchors.ps1` | Windows PowerShell Markdown 앵커 검사 |
| `harness-guide.html` | 이 하네스의 설계 의도 설명서(단일 HTML, 자체 포함). 골격이 바뀌면 같이 고친다 |

## PROJECT overlay (프로젝트마다 새로 작성 — 고객 자료, 공유 금지)

| 파일 | PROJECT 부분 |
|---|---|
| `CLAUDE.md` | 커밋 메시지 언어 / 자동 적용 규칙 import 절 (도메인·스택) |
| `harness/rules/*.md` | 도메인 규칙. **100% 고유** |
| `.claude/agents/dod-checker.md` | PROJECT 검증항목 (도메인 검출 명령어) |
| `.claude/agents/design-grill.md` | 질문 축의 도메인 내용 |
| `harness/ssot-index.md` | 진실 원천 등록부. **100% 고유** |
| `.claude/scripts/drift-anchors.sh` | `DOC_TARGETS` 배열 |
| `.githooks/config` | 보호 브랜치·허용 커밋 type |
| `docs/_local/` | Word·PDF 원본, 사내 중요 문서, 개인정보 자료. **항상 Git 제외** |
| `docs/**` | 정책·결정·진행기록·작업목록·회의·외부계약. **전부 고객 자료** |

## 이식 절차

1. BASE 복사
2. `CLAUDE.template.md` → `CLAUDE.md`, `<...>` placeholder 채우기
3. `git config core.hooksPath .githooks`로 Git hook을 설치하고 `.githooks/config`의 보호 브랜치·허용 type 수정
   - 이 설정은 clone마다 필요하다. macOS/Linux에서는 `chmod +x .githooks/pre-commit .githooks/commit-msg`도 실행한다.
4. `harness/rules/` 도메인 규칙 작성
5. `dod-checker` PROJECT 검증항목 / `design-grill` 질문 축 작성
6. `docs/backlog/작업목록.md` 와 첫 `docs/progress/YYYY-MM-DD_작업명.md` 를 만들고 진입 문서에서 연결
   - progress 파일명은 날짜 접두사 필수(정렬=시간순), 작업명 한글 가능, **공백 금지**
   - 한글 파일명을 쓰면 `git config core.quotepath false` 를 저장소에 걸어둔다
7. `harness/*.template.md`를 실제 파일로 복사하고 채운다. Codex는 `AGENTS.template.md` → `AGENTS.md`, Claude Code는 `CLAUDE.template.md` → `CLAUDE.md`.
8. 두 런타임은 같은 `harness/` 공통 계약과 SSOT를 사용한다.
9. 골격(워크플로·출력형식·행동원칙·drift 엔진)은 건드리지 않음

## 기록 수명주기

```text
프로젝트 컨텍스트·정본   현재 무엇이 참인가
        ↓
backlog                  결정됐지만 무엇이 남았는가
        ↓
progress                 실제로 무엇을 했고 결과가 무엇인가
        └─ 중요한 선택 → decisions(ADR)  왜 그렇게 결정했는가
```

- 정본은 현재 유효한 기준만 유지한다.
- backlog는 완료 이력을 쌓는 장소가 아니다. 완료 결과를 progress에 연결한 뒤 항목을 제거한다.
- progress는 시간순 실행 사실을 보존하며, 과거 기록을 현재 기준처럼 사용하지 않는다.
- ADR은 되돌리기 어렵거나 여러 작업에 영향을 주는 결정에만 작성한다.
- Git 커밋은 파일 차이를, progress는 작업 단위의 결과·차단 요인·다음 시작점을 설명한다.

### drift 점검 대상 (근거를 남긴다)

`drift-anchors.sh` 의 `DOC_TARGETS` 는 backlog 를 **포함**하고 progress 를 **제외**한다.

- backlog 포함: "지금 남은 일"이므로 앵커가 썩으면 다음 작업자가 죽은 경로로 출발한다.
- progress 제외: 당시 실행 사실의 기록이라 앵커가 과거를 가리키는 게 정상이다.
  넣으면 기록이 쌓일수록 오탐만 늘어 Tier1 신호가 죽는다.

이 판단을 여기 적어두는 이유는, 근거 없는 부재는 언젠가 "빠졌네" 하고 되돌려지기 때문이다.

### 파일명 규칙

- progress: `YYYY-MM-DD_작업명.md`. 날짜 접두사 필수, 작업명 한글 가능, 공백 금지(하이픈).
- backlog: `작업목록.md` 한 개. 쪼개면 단일 창구가 사라진다.
- 한글 파일명은 git 기본값(`core.quotepath=true`)에서 이스케이프돼 스크립트 grep 을 조용히 빠져나간다.
  그래서 dod 스크립트는 `git -c core.quotepath=false` 를 명시한다. 이 옵션을 지우지 말 것.

## 공유 경계 (중요)

- BASE 는 push 가능 (고객 자료 없음).
- PROJECT overlay + `docs/` 는 진행기록과 작업목록을 포함한 고객 기밀. **개인/공용 remote 로 push 금지.**
- 프로젝트 하네스 이력은 `hz.sh` 평행 git-dir(remote 없음)로 로컬에만.
- **기계 강제 (관례 아님)**: BASE 의 `.gitignore` 가 `docs/` 를 기본 제외한다(스켈레톤 `_TEMPLATE.md` 만 공유). 그래서 실제 ADR·정책·backlog 는 프로젝트가 공개 repo 여도 커밋되지 않는다. 이식 시 이 규칙을 지우지 말 것. 프로젝트 스택 ignore 는 그 아래에 덧붙인다.
  - 근거: docs/ 비공개가 문서 관례로만 있으면 새 프로젝트(특히 공개 GitHub Pages 블로그)에서 쉽게 유출된다. gitignore 로 못박아 기본값으로 만든다.
  - `docs/_local/`은 Word·PDF 원본, 사내 중요 문서, 개인정보 자료의 전용 보관함이다. 공유 문서 모드에서도 계속 제외한다.

### 선택형 공유 문서 모드

프로젝트의 문서가 공개 가능하고 팀이 Git 공유를 명시적으로 결정한 경우에만 [SHARED_DOCS.md](./SHARED_DOCS.md)를 따른다. 기본 `.gitignore`의 `docs/**` 제외 규칙은 유지한다. 공유 모드는 `.gitignore.shared-docs.example`을 검토해 전환하며, 시크릿·개인정보·원본 민감 자료는 어떤 모드에서도 추적하지 않는다.

## 런타임 어댑터

Claude Code와 Codex는 `harness/`의 같은 컨텍스트·SSOT·검수 계약을 사용한다. `.claude/`와 `.codex/`에는 각 런타임의 호출 형식, 에이전트 등록, 스크립트만 둔다. 공통 판단 기준을 어느 한쪽에 복제하지 않는다.
