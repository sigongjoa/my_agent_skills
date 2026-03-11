# 수학 증명 워크북 새 파일 생성

새 증명 워크북 `.typ` 파일을 생성하고 PDF로 컴파일합니다.
작업 디렉토리: `/mnt/g/mathesis/proof_workbook/`

## 진행 순서

사용자에게 다음 정보를 순서대로 질문하세요 (이미 arguments로 제공된 경우 생략):

1. **파일명** — 영문 snake_case, .typ 제외 (예: `log_property`)
2. **워크북 제목** (예: `로그의 성질 증명`)
3. **과목명** — 기본값: `고등수학 I · 지수와 로그`
4. **GIVEN 또는 DEFINITION 박스** (태그: GIVEN / DEFINITION 중 선택)
   - 이미 알고 있는 것 또는 사용할 정의 내용
5. **THEOREM 박스** — 증명할 명제 (조건 + 등식/부등식)
6. **Phase 1 카드** — 순서가 섞인 증명 단계 (증명에 필요한 만큼)
   - 카드 레이블은 A, B, C, D, ... 순서로 부여
   - 각 카드 내용 (Typst 수식 포함 가능)
   - 정답 순서 (예: `C → A → E → B → D`)
7. **Phase 2 빈칸 채우기** — Phase 1과 동일한 단계 수, 각 단계의 빈칸 포함 문장 + 정답
8. **Phase 3 모범 증명** — 완전한 증명문

## 생성할 파일 구조

```typst
// ============================================================
//  수학 증명 워크북 — [제목]
// ============================================================
#import "proof_lib.typ": *

#set page(paper: "a4", margin: (top: 1.6cm, bottom: 1.8cm, left: 1.8cm, right: 1.8cm))
#set text(size: 10.5pt, lang: "ko")
#set par(leading: 0.72em)

// PAGE 1 — 정의 + Phase 1
#topbar("[제목]", "[과목명]")
#v(0.5cm)
#grid(columns: (1fr, 1fr), gutter: 0.5cm,
  def-box("DEFINITION", DEF, "[박스 부제목]")[
    // 정의 내용
  ],
  def-box("THEOREM", P1, "증명할 명제")[
    // 명제 내용
  ]
)
#v(0.55cm)
#phase-header(1, "🔵", "순서 맞추기", "□ 안에 올바른 순서 번호(1~N)를 쓰시오")
#v(0.3cm)
// 카드 수는 증명에 맞게 결정 (정답 순서 주석으로 표기)
#step-card(1, "A")[...]
#step-card(1, "B")[...]
// ... 필요한 만큼 추가
#order-boxes(count: N)  // N = 실제 카드 수
#pagebreak()

// PAGE 2 — Phase 2: 빈칸 채우기
#topbar("[제목]", "[과목명]")
#v(0.5cm)
#phase-header(2, "🟢", "빈칸 채우기", "증명 흐름을 따라 빈칸을 채우시오")
#v(0.4cm)
#fill-box[
  #grid(columns: (auto, 1fr), gutter: 8pt, snum(1), [...])
  #v(0.65cm)
  #grid(columns: (auto, 1fr), gutter: 8pt, snum(2), [...])
  // ... Phase 1 카드 수와 동일한 단계 수만큼 반복
]
#pagebreak()

// PAGE 3 — Phase 3: 백지 증명
#topbar("[제목]", "[과목명]")
#v(0.5cm)
#phase-header(3, "🔴", "백지 증명", "앞 페이지를 가리고 스스로 증명을 완성하시오")
#v(0.4cm)
#problem-box[
  [서술형 문제 문장]
  #h(1em)
  #text(size: 9pt, fill: MID)[(단, 사용 도구 제한)]
]
#v(0.45cm)
#answer-box(label: "풀이", n: 12)
#pagebreak()

// PAGE 4 — 답안지
#topbar("[제목]", "답안지 — 풀기 전에 절대 보지 마시오!")
#v(0.5cm)
#answer-sheet-header()
#v(0.55cm)
#answer-section(P1)[
  #text(weight: "bold", fill: P1)[🔵 Phase 1 — 순서 답]
  #v(0.3cm)
  #text(size: 11.5pt, weight: "bold")[[정답 순서]]
  #v(0.35cm)
  #set text(size: 9.5pt)
  #grid(columns: (auto, 1fr), row-gutter: 0.3cm, column-gutter: 0.6cm,
    text(weight: "bold")[1 (X):], [설명],
    // ...
  )
]
#v(0.5cm)
#answer-section(P2)[
  #text(weight: "bold", fill: P2)[🟢 Phase 2 — 빈칸 답]
  #v(0.3cm)
  #set text(size: 9.5pt)
  #grid(columns: (auto, 1fr), row-gutter: 0.35cm, column-gutter: 0.5cm,
    text(weight: "bold")[(1)], [...],
    // ...
  )
]
#v(0.5cm)
#answer-section(P3)[
  #text(weight: "bold", fill: P3)[🔴 Phase 3 — 모범 증명]
  #v(0.3cm)
  #set text(size: 9.5pt)
  // 모범 증명 내용
  #align(right)[$square.filled$]
]
```

## proof_lib.typ 제공 함수 목록

| 함수 | 설명 |
|------|------|
| `topbar(title, subtitle)` | 상단 헤더바 (이름/날짜 입력란 포함) |
| `phase-header(n, emoji, title, desc)` | Phase 헤더 (n=1 블루, 2 그린, 3 오렌지) |
| `step-card(n, label, body)` | Phase 1 순서 맞추기 카드 |
| `order-boxes(count: 5)` | 순서 체크박스 줄 |
| `blank(w: 3cm)` | 긴 빈칸 밑줄 |
| `mb(w: 2cm)` | 짧은 빈칸 (수식 내부용) |
| `def-box(tag, color, title, body)` | DEFINITION/GIVEN/THEOREM 박스 |
| `problem-box(body)` | Phase 3 서술형 문제 박스 |
| `answer-box(label, n)` | Phase 3 빈 답란 |
| `snum(n)` | Phase 2 단계 번호 배지 |
| `fill-box[body]` | Phase 2 전체 래퍼 박스 |
| `answer-sheet-header()` | 답안지 빨간 헤더 |
| `answer-section(color)[body]` | 답안지 섹션 박스 |
| 색상 변수 | `P1`(블루) `P2`(그린) `P3`(오렌지) `ANS`(레드) `DEF`(퍼플) `DARK MID LIGHT BG` |

## 컴파일 명령

파일 생성 후 반드시 실행:
```bash
cd /mnt/g/mathesis/proof_workbook && typst compile [파일명].typ
```

성공 시 `✅ [파일명].pdf 생성 완료` 출력.
에러 시 원인 분석 후 자동 수정 재시도.

## Arguments 처리

`$ARGUMENTS`가 제공된 경우 파일명으로 사용하고, 나머지 정보를 질문하세요.
파일명과 함께 주제 설명이 있다면 그것을 바탕으로 증명 내용을 자동 설계하세요.
