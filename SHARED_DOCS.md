# 공유 문서 모드

기본 BASE는 `docs/**`를 Git에서 제외한다. 고객 자료, 회의록, 원본 계약, 시크릿이 공개 remote로 새는 사고를 막기 위한 기본값이다.

공유가 필요한 프로젝트만 `.gitignore.shared-docs.example`의 규칙을 검토해 기존 `docs/**` 제외 블록을 교체한다. 이 전환은 프로젝트 의사결정 기록에 남긴다.

공유 가능 후보:

- 공개 정책과 기술 명세
- 재현 가능한 운영 절차와 비민감 진행기록
- 공개 가능한 ADR과 템플릿

저장소 밖에 둘 대상:

- API key, password, token, private key
- 개인정보, 고객 원문, 원본 민감 payload
- 비공개 계약, 외부 참고자료, 개인 메모

공유 전에는 `git check-ignore -v <문서>`, 비밀정보 검색, `git diff --check`를 실행한다.
