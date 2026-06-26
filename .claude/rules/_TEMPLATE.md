# <도메인> 규칙

> 도메인 규칙은 PROJECT overlay 다. 이 프로젝트에서 "무엇이 옳은가"를 정의한다.
> dod-checker(결정론 검출)와 design-grill(설계 질문)이 이 파일을 근거로 삼는다.
> CLAUDE.md 에서 `@.claude/rules/<이파일>.md` 로 import 하면 코딩 중 자동 적용된다.

## 적용 대상

- 어떤 파일/패턴에 적용되는가 (예: `*Controller.java`, `framework/external/**`)

## 규칙 (해야 할 것 / 하면 안 되는 것)

규칙은 **기계가 검출 가능하게** 적을수록 dod-checker 가 강하게 잡는다.

- (예) 모든 외부 호출에 `.timeout(...)` 명시. 누락 = WARN.
- (예) 자동 재시도 금지. `.retry(`/재시도 루프 발견 = WARN(멱등성 확인).
- (예) primitive 필드 금지, Wrapper 타입 사용. 발견 = FAIL.

## 근거 / 왜 이 규칙인가

규칙만 적고 이유를 안 적으면 6개월 뒤 누군가 무심코 푼다. 이유를 같이 적는다.

- (예) timeout 없으면 외부 hang 시 이벤트 루프/스레드 점유.

## 회색지대 / 예외

- 이 규칙이 안 적용되는 정당한 케이스 (있으면).

## 관련

- 정책: `docs/policy/<...>.md`
- 검증: dod-checker `[?]` 항목, design-grill 축 N
- 코드 기준점: `path/to/File.ext:line`
