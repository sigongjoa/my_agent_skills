# textbook-authoring

대화 기반 교재 제작 워크플로우. 어떤 주제든 동일한 skill 체계로 작동한다.

## 차별화 포인트

다른 교재/콘텐츠와 다른 점:
- "왜 배우는가"부터 시작하는 동기 설계
- 개념 → 예시 → 기초/수학/전공 문제까지 완전한 전개
- **수학적 + 교육적 + 출처** 3단계 검증을 거친 신뢰할 수 있는 콘텐츠

## 설치

이 폴더를 교재 제작 프로젝트 폴더 안에 복사:

```bash
cp -r textbook-authoring/.claude /your-project-folder/
```

또는 `textbook-authoring/` 폴더 자체를 프로젝트로 사용.

## 워크플로우

```
/why [주제]
  ↓
/build [주제] --context [도메인]
  ↓
/problems [주제] --level [기초|수학|전공]
  ↓
/validate drafts/[파일명]
  ↓
/assemble [주제]
```

## 예시

```bash
# 로그 챕터 제작
/why 로그 --audience 대학생 --domain 생물
/build 로그 --context 생물학
/problems 로그 --level 수학
/problems 로그 --level 전공
/validate drafts/log-build.md
/assemble 로그
```

주제가 바뀌어도 동일한 commands 사용:
```bash
/why 범주론 --audience 대학원생 --domain 수학
/why 튜링머신 --audience 대학생 --domain 컴퓨터과학
```

## Skills 설명

| Command | 역할 |
|---|---|
| `/why` | 역사적 맥락 + 실제 세계 연결 + 학습 동기 설계 |
| `/build` | 직관 → 정의 → 계산 예시 → 핵심 성질 전개 |
| `/problems` | 기초/수학/전공 3단계 난이도 문제 생성 |
| `/validate` | 수학적 정확성 + 교육적 흐름 + 출처 3단계 검증 |
| `/assemble` | 검증된 파일들을 완성 챕터로 조합 |

## 폴더 구조

```
textbook-authoring/
  .claude/
    CLAUDE.md              ← 프로젝트 컨텍스트 (이 폴더에서만 활성화)
    commands/
      why.md
      build.md
      problems.md
      validate.md
      assemble.md
  drafts/                  ← 작업 중인 원고 (검증 전)
  validated/               ← 검증 통과한 콘텐츠
  sources/                 ← 참고문헌
```

## 검증 기준

`/validate`는 3단계 모두 PASS여야 통과:
1. **수학적 정확성** — 공식, 계산, 상수값 직접 재계산
2. **교육적 정확성** — 개념 흐름, 난이도, 사전 설명 여부
3. **출처 검증** — 교과서/논문 기반, Wikipedia 단독 출처 불허
