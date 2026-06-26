# <PROJECT_NAME> 작업 지침

> 이 파일은 매 턴 자동 로드된다. (프로젝트 루트에 CLAUDE.md 로 둔다)
> 절마다 [BASE] = 프로젝트 무관 골격(그대로 둠), [PROJECT] = 채워야 할 부분.
> 이식 구조는 `.claude/HARNESS.md` 참고.

## 워크플로 [BASE]

생산은 AI가 한다. 사람의 메인 작업은 검증과 판단이다.

1. 작업
2. `/grill`: 설계 캐묻기 + 답을 `docs/decisions/<브랜치>.md` 에 박제 (의도부채 방지)
3. 보완
4. `/dod`: 규칙 결정론 검수 (PASS/FAIL/WARN)
5. `/drift`: SSOT 드리프트 점검 (정기 / 큰 변경 후)
6. PR

작업은 feature 브랜치에서 한다. 보호 브랜치 직접 커밋 금지(훅이 차단).
`/grill`·`/dod` 는 `<BASE_BRANCH>` 대비 비교한다.

## 커밋 메시지 [PROJECT]

형식: `[<CHANNELS>][<TYPES>] <설명>`
예: 채널 `관리자|멤버|공통`, 분류 `추가|수정|삭제|테스트|문서`

- 토큰은 `.claude/hooks/pre-commit-check.sh` CONFIG 블록과 일치시킬 것.
- AI 도구 언급·공동저자 트레일러 금지.

## 코드 작성 시 자동 적용 규칙 [PROJECT overlay]

아래 규칙은 매칭 파일을 수정하기 **전에** 따른다. 생성 단계에서 기술부채를 차단한다.
(프로젝트의 `.claude/rules/*.md` 를 여기 import. 예시)

@.claude/rules/<도메인-규칙-1>.md
@.claude/rules/<도메인-규칙-2>.md

## 검증 우선순위 [BASE] (인지부채 관리)

다 검증하려 하면 지친다. **경계를 넘는 결과물**부터 철저히 본다.

- 철저 검증: 외부로 나가는 것. 외부 연동 요청·응답, 푸시/알림 페이로드, 마이그레이션, 권한/격리, 응답 DTO 의 민감정보.
- 가벼운 검증: 내부 헬퍼·중간상태.

가능하면 자동화한다 (테스트, dod 정적검출, 빌드). 사람 확인은 경계 넘는 결과물에 집중.

## 의도·결정 기록 [BASE] (의도부채 관리)

"왜 이렇게 만들었나"가 코드 주석의 '잠정' 으로 떠다니지 않게 박제한다.

- 이번 작업의 결정: `docs/decisions/<브랜치>.md` (ADR, 템플릿 `docs/decisions/_TEMPLATE.md`)
- 도메인 정책·회색지대: `docs/policy/`
- 기능 결정: `docs/feature/`
- 외부 계약: `docs/reference/`

검증 레이어를 만들며 나온 암묵지는 ADR 의 "가정·만료 조건"에 같이 적는다. 의도부채를 동반 해결한다.

진실 원천 지도는 `.claude/ssot-index.md`. `/drift` 가 이걸 기준으로 코드와의 괴리를 점검한다.
