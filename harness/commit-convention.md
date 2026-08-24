# 커밋 메시지 규약

Conventional Commits 형식을 쓴다.

```text
<type>(<scope>): <설명>
```

- `scope`은 선택이다. 범위가 명확할 때만 쓴다.
- 설명은 프로젝트가 정한 언어로 쓴다. 기본 템플릿은 한글이다.
- type, scope의 제품·도구 이름, 코드 식별자, 파일 경로, CLI 명령은 영어 원문을 유지한다.
- AI 도구 언급, `Co-Authored-By`, 이모지는 쓰지 않는다.

허용 type: `feat`, `fix`, `docs`, `refactor`, `test`, `build`, `ci`, `perf`, `chore`.

예시:

```text
feat(auth): 로그인 재시도 제한 추가
fix: 빈 작업목록 파싱 오류 수정
docs(harness): 공유 문서 모드 안내 보완
refactor(harness): Claude와 Codex 하네스 통합
```
