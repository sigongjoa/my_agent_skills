# /test-gen — 학생 맞춤 수학 시험지 생성

class-log 데이터를 분석하여 학생의 약점 기반 수학 시험지를 생성합니다.
강사 검토 → 승인 → Typst PDF 컴파일까지 자동화합니다.

**이미지 자동 생성 포함**: 각 문제 생성 후 `/img-gen` 로직으로 이미지 필요 여부를 자동 판단하여 CeTZ 그래프/도형/트리/차트를 삽입합니다.

---

## 인수 파싱

명령어 형식: `/test-gen [학생명] [문항수] [이전시험날짜]`

예시:
- `/test-gen 학생A 20 2026-03-01`
- `/test-gen 학생B 15 2026-02-28`

파싱:
- `학생명`: 첫 번째 인수
- `문항수`: 두 번째 인수 (없으면 20)
- `이전시험날짜`: 세 번째 인수 YYYY-MM-DD (없으면 30일 전)

---

## STEP 1 — 로그 수집

`class-log/data/reviews/` 에서 다음 조건을 모두 만족하는 JSON 파일을 전부 읽으세요:
- 파일명에 `[학생명]` 포함
- `date` 필드 >= `[이전시험날짜]`
- `type`이 `"self_reflection"`이 아닌 것 (강사 자기성찰 제외)

읽은 파일 목록과 날짜 범위를 다음 형식으로 출력하세요:

```
로그 수집 완료
학생: 학생A
기간: 2026-03-01 ~ 2026-03-13 (7개 세션)
파일: 2026-03-03, 2026-03-05, 2026-03-05_2, ...
```

---

## STEP 2 — 약점 맵 추출

수집된 로그에서 다음 항목을 추출하여 **약점 맵**을 만드세요.

### 추출 대상
| 필드 | 의미 |
|------|------|
| `stuck[]` | 막힌 개념 (세션마다) |
| `weaknesses_identified[]` | 명시적 약점 |
| `next_focus` | 다음 집중 포인트 |
| `understanding` | 이해도 점수 (1~5) |
| `topic` | 해당 수업 주제 |
| `problem_log` | 실제 풀었던 문제 맥락 |

### 우선순위 분류
- **고우선**: understanding ≤ 2, 또는 stuck에 2회 이상 등장한 개념
- **중우선**: understanding 3, 또는 stuck에 1회 등장
- **저우선**: 다룬 주제인데 이해도 4~5 (확인용)

### 약점 맵 출력 형식
```
약점 맵 (학생A, 2026-03-01 이후)

[고우선]
- 로그 개념 이해 (2026-03-10, understanding: 2) — stuck: "로그 개념 미숙"
- A⊂B⊂U 경우의 수 원리 설명 (2026-03-12) — stuck: "'왜'를 설명하지 못함"

[중우선]
- 새로운 유형 적용 시 실수 (2026-03-03) — understanding: 3
- 확통 집합 연계 문제 (2026-03-12) — understanding: 4, 심화 개념 파고듦

[저우선 — 확인용]
- 순열 기본 계산 (해당 수업 다룸, 이해도 4)
```

---

## STEP 3 — 문제 생성

약점 맵을 기반으로 수학 문제를 `[문항수]`개 생성하세요.

### 문항 배분 원칙
- 고우선 약점 → 전체 문항의 약 50%
- 중우선 약점 → 전체 문항의 약 35%
- 저우선 확인 → 전체 문항의 약 15%

### 각 문제 형식
객관식 / 단답형 / 서술형 혼합. 수능 스타일.

### 배점 자동 계산 알고리즘
1. 고우선 문제 weight = 3, 중우선 = 2, 저우선 = 1
2. 각 문제 점수 = round(100 × weight / 전체weight합계)
3. 합산이 100이 안 되면 마지막 고우선 문제에서 조정

### 생성 시 각 문제에 반드시 포함할 메타정보

문제를 생성한 직후, **이미지 필요 여부를 /img-gen 로직으로 자동 판단**하여 `image_type`과 `cetz_code`를 채웁니다.

```json
{
  "번호": 1,
  "유형": "로그 기본 계산",
  "난이도": "★★★★",
  "배점": 6,
  "문제": "다음을 계산하여라. log₂8 + log₃(1/9)",
  "보기": null,
  "정답": "-1",
  "풀이": "log₂8 = log₂2³ = 3, log₃(1/9) = log₃3⁻² = -2 → 3 + (-2) = 1... (틀린 풀이 예시 정정 포함)",
  "image_type": "none",
  "cetz_code": null,
  "약점근거": "2026-03-10 — 로그 개념 미숙 (understanding: 2)",
  "우선순위": "고",
  "예상정오": "틀릴 가능성 높음",
  "예상오답패턴": "log 성질 혼동, 지수 부호 실수"
}
```

**예상정오 기준:**
- 고우선 + understanding ≤ 2 → "틀릴 가능성 높음"
- stuck에 기록된 개념 → "처음 보는 문제 유형일 가능성 있음"
- 저우선 + understanding ≥ 4 → "맞출 가능성 높음"

---

## STEP 4 — 강사 검토 화면

생성된 문제를 아래 형식으로 터미널에 출력하세요. **저장 전에 강사가 먼저 검토합니다.**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  학생A 정기고사 — 강사 검토 (2026-03월)
  총 20문항 | 100점 | 수학
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1번 (6점) ★★★★  [고우선 | 틀릴 가능성 높음]
유형: 로그 기본 계산
근거: 2026-03-10 — 로그 개념 미숙

문제: 다음을 계산하여라. log₂8 + log₃(1/9)
정답: 1

오답패턴: log 성질 혼동, 지수 부호 실수
────────────────────────────────────────────

2번 (5점) ★★★  [중우선 | 처음 보는 문제 유형일 가능성 있음]
...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
배점 합계: 100점 확인 ✓

검토 완료 후: "승인" 또는 수정 요청을 입력해주세요.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 수정 요청 처리
- "3번 삭제" → 해당 문제 제거, 나머지 번호 재정렬, 배점 재계산
- "5번 난이도 낮춰" → 해당 문제 재생성 (저우선으로 조정)
- "7번 문제 바꿔" → 동일 약점 기반 문제 재생성
- "승인" → STEP 5로 진행

---

## STEP 5 — JSON 저장

승인 후 다음 경로에 검토용 JSON 저장:

`class-log/data/tests/[학생명]_[생성날짜]_test.json`

```json
{
  "meta": {
    "student": "학생A",
    "generated_date": "2026-03-14",
    "log_range_start": "2026-03-01",
    "log_range_end": "2026-03-13",
    "total_sessions": 7,
    "total_problems": 20,
    "total_score": 100,
    "subject": "수학"
  },
  "problems": [ ...각 문제 객체... ]
}
```

---

## STEP 6 — Typst 시험지 생성

### 이미지 삽입 규칙

각 문제의 `image_type`이 `"none"`이 아닌 경우, 문제 본문 아래에 CeTZ 코드를 삽입합니다.

```typst
// 이미지 있는 문제 블록 예시
#prob(3, "12점", score_high, [
  다음 그림은 함수 $f(x) = x^2 - 2x$의 그래프이다.
  그래프를 참고하여 $f(x)$의 최솟값을 구하여라.

  #v(0.3em)
  #align(center)[
    #import "@preview/cetz:0.4.2"
    #import "@preview/cetz-plot:0.1.3": plot
    #cetz.canvas(length: 1cm, {
      import cetz.draw: *
      plot.plot(
        size: (5, 3.5),
        x-min: -1, x-max: 3,
        y-min: -2, y-max: 4,
        x-tick-step: 1, y-tick-step: 1,
        x-label: $x$, y-label: $y$,
        x-grid: true, y-grid: true,
        {
          plot.add(x => x * x - 2 * x, domain: (-0.8, 2.8),
            style: (stroke: rgb("#2980b9") + 1.5pt), samples: 60)
          plot.add(((1, -1),), mark: "o", mark-size: 0.12,
            style: (stroke: none, fill: rgb("#e74c3c")))
        }
      )
    })
  ]
  #v(0.3em)
], 2em)
```

**이미지 크기 기준 (2단 레이아웃):**
- 함수 그래프: `size: (5, 3.5)` 또는 `(5, 4)`
- 도형: canvas `length: 1cm`, 총 너비 5cm 이내
- 확률 트리: 단계 수에 따라 `h-gap` 조정
- 히스토그램: `size: (5.5, 3.5)`

### 파일 경로
- 시험지: `class-log/data/tests/[학생명]_[생성날짜]_시험지.typ`
- 정답지: `class-log/data/tests/[학생명]_[생성날짜]_정답지.typ`

### 시험지 Typst 템플릿

```typst
#set document(title: "[학생명] 정기고사")
#set page(
  paper: "a4",
  margin: (top: 2cm, bottom: 2cm, left: 2.5cm, right: 2.5cm),
  header: [
    #set text(size: 9pt, fill: rgb("#555555"))
    #grid(
      columns: (1fr, 1fr),
      align(left)[와와 학습코칭센터 알파시티점],
      align(right)[수학 | [생성날짜]]
    )
    #line(length: 100%, stroke: 0.3pt + rgb("#aaaaaa"))
  ],
  footer: [
    #line(length: 100%, stroke: 0.3pt + rgb("#aaaaaa"))
    #set text(size: 8pt, fill: rgb("#888888"))
    #grid(
      columns: (1fr, 1fr, 1fr),
      align(left)[와와 학습코칭센터],
      align(center)[알파시티점],
      align(right)[#counter(page).display() 페이지]
    )
  ]
)
#set text(font: ("Noto Sans CJK KR", "Noto Serif CJK KR", "Arial"), size: 11pt)
#set par(justify: true, leading: 0.8em)

// ── 표지 헤더 ──────────────────────────────────
#v(0.5em)
#align(center)[
  #block(
    fill: rgb("#1a1a2e"),
    width: 100%,
    inset: (x: 1.5em, y: 1em),
    radius: 4pt
  )[
    #text(size: 10pt, fill: white, weight: "bold")[와와 학습코칭센터 알파시티점]
    #h(1fr)
    #text(size: 18pt, fill: white, weight: "bold")[[학생명] 정기고사]
  ]
]
#v(0.5em)

// ── 수험자 정보 ────────────────────────────────
#grid(
  columns: (1fr, 1fr, 1fr),
  column-gutter: 1em,
  block(stroke: 0.5pt, inset: 8pt, radius: 3pt)[
    *이름:* #h(1fr) ___________
  ],
  block(stroke: 0.5pt, inset: 8pt, radius: 3pt)[
    *날짜:* #h(1fr) ___ 년 ___ 월 ___ 일
  ],
  block(stroke: 0.5pt, inset: 8pt, radius: 3pt)[
    *점수:* #h(1fr) ___________ / 100
  ]
)
#v(0.8em)
#line(length: 100%, stroke: 1pt)
#v(0.5em)

// ── 문제 (2단 레이아웃) ────────────────────────
#columns(2, gutter: 1.5em)[
  // 각 문제를 반복
  #block(below: 1.2em)[
    #text(weight: "bold")[1. #h(0.3em)] #text(size: 9pt, fill: rgb("#888888"))[(6점)]
    #v(0.3em)
    [문제 본문...]
    #v(0.5em)
    #block(
      stroke: (left: 2pt + rgb("#cccccc")),
      inset: (left: 8pt),
    )[
      ① _______  ② _______  ③ _______
      ④ _______  ⑤ _______
    ]
  ]
  // ... 반복
]
```

### 정답지 Typst 템플릿

정답지는 시험지와 동일한 헤더/푸터를 사용하되:
- 상단에 `#text(fill: red)[★ 강사용 정답지 — 배포 금지]` 표시
- 각 문제마다 정답, 풀이, 약점근거, 예상정오, 예상오답패턴 포함
- 1단 레이아웃 (가독성 우선)

정답지 각 문제 블록:
```typst
#block(
  fill: luma(248),
  stroke: 0.4pt,
  inset: 10pt,
  radius: 3pt,
  below: 0.8em
)[
  *[번호]번* #h(0.5em) #text(size: 9pt, fill: rgb("#888888"))[[배점]점 | [난이도] | [우선순위] | [예상정오]]
  #v(0.3em)
  *문제:* [문제 본문]
  #v(0.3em)
  *정답:* #text(fill: rgb("#c0392b"), weight: "bold")[[정답]]
  #v(0.3em)
  *풀이:* [풀이 과정]
  #v(0.3em)
  #text(size: 9pt, fill: rgb("#666666"))[
    *약점근거:* [약점근거] \
    *오답패턴:* [예상오답패턴]
  ]
]
```

Typst 파일 작성 후 출력:

```
Typst 파일 생성 완료
  시험지: class-log/data/tests/학생A_2026-03-14_시험지.typ
  정답지: class-log/data/tests/학생A_2026-03-14_정답지.typ
```

---

## STEP 7 — PDF 컴파일

```bash
typst compile "class-log/data/tests/[학생명]_[날짜]_시험지.typ"
typst compile "class-log/data/tests/[학생명]_[날짜]_정답지.typ"
```

컴파일 성공 시:
```
PDF 생성 완료
  시험지: class-log/data/tests/학생A_2026-03-14_시험지.pdf  ← 학생 배포용
  정답지: class-log/data/tests/학생A_2026-03-14_정답지.pdf  ← 강사 보관용
```

컴파일 실패 시: Typst 오류 메시지를 그대로 출력하고 수정 후 재시도.

---

## 최종 요약 출력

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  학생A 정기고사 생성 완료
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  기간    2026-03-01 ~ 2026-03-13 (7세션)
  문항    20문항 / 100점
  고우선  10문항 (로그 개념, A⊂B⊂U 경우의 수)
  중우선  7문항 (실수 패턴, 확통 집합 연계)
  확인    3문항 (기본 계산)

  시험지  → 학생A_2026-03-14_시험지.pdf
  정답지  → 학생A_2026-03-14_정답지.pdf
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
