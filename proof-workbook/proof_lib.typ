// ============================================================
//  proof_lib.typ — 수학 증명 워크북 공용 라이브러리
//  모든 워크북 파일에서 #import "proof_lib.typ": * 로 사용
// ============================================================

// ── 색상 팔레트 ─────────────────────────────────────────────
#let P1     = rgb("#1565C0")   // Phase 1 — 블루
#let P1L    = rgb("#E3F2FD")
#let P2     = rgb("#2E7D32")   // Phase 2 — 그린
#let P2L    = rgb("#E8F5E9")
#let P3     = rgb("#E65100")   // Phase 3 — 오렌지
#let P3L    = rgb("#FFF3E0")
#let ANS    = rgb("#B71C1C")   // 답안지 — 레드
#let ANSL   = rgb("#FFEBEE")
#let DEF    = rgb("#4A148C")   // 정의 — 퍼플
#let DEFL   = rgb("#F3E5F5")
#let DARK   = rgb("#212121")
#let MID    = rgb("#555555")
#let LIGHT  = rgb("#CCCCCC")
#let BG     = rgb("#FAFAFA")

// ── 헬퍼 함수들 ─────────────────────────────────────────────

/// 상단 헤더바 (이름/날짜 입력란 포함)
#let topbar(title, subtitle) = {
  rect(fill: DARK, width: 100%, inset: 0pt)[
    #pad(x: 14pt, y: 9pt)[
      #grid(columns: (1fr, auto),
        align(left + horizon)[
          #text(fill: white, weight: "bold", size: 14pt)[#title]
          #h(10pt)
          #text(fill: rgb("#AAAAAA"), size: 9.5pt)[#subtitle]
        ],
        align(right + horizon)[
          #text(fill: rgb("#888888"), size: 8.5pt)[
            이름: #box(width: 2.5cm, stroke: (bottom: rgb("#666") + 0.7pt), height: 1em)[]
            #h(6pt) 날짜: #box(width: 2cm, stroke: (bottom: rgb("#666") + 0.7pt), height: 1em)[]
          ]
        ]
      )
    ]
  ]
}

/// Phase 헤더 (1=블루, 2=그린, 3=오렌지)
#let phase-header(n, emoji, title, desc) = {
  let c = if n == 1 { P1 } else if n == 2 { P2 } else { P3 }
  rect(fill: c, width: 100%, inset: 0pt, radius: (top: 4pt))[
    #pad(x: 12pt, y: 8pt)[
      #grid(columns: (auto, 1fr),
        align(left + horizon)[
          #text(fill: white, weight: "bold", size: 13pt)[
            #emoji #h(4pt) PHASE #n — #title
          ]
        ],
        align(right + horizon)[
          #text(fill: rgb("#DDDDDD"), size: 8.5pt)[#desc]
        ]
      )
    ]
  ]
  v(0.15cm)
}

/// Phase 1용 순서 맞추기 카드
#let step-card(n, label, body) = {
  v(0.38cm)
  rect(stroke: (left: P1 + 3pt, rest: LIGHT + 0.6pt), inset: 0pt, width: 100%, radius: 2pt)[
    #grid(
      columns: (2.2cm, 1fr),
      align(center + horizon)[
        #pad(y: 10pt)[
          #box(fill: P1, inset: (x: 7pt, y: 4pt), radius: 2pt)[
            #text(fill: white, weight: "bold", size: 11pt)[#label]
          ]
          #h(4pt)
          #box(width: 1.3em, height: 1.3em, stroke: DARK + 0.8pt, radius: 1pt)
        ]
      ],
      rect(fill: white, stroke: none, inset: (x: 12pt, y: 10pt))[#body]
    )
  ]
}

/// 순서 입력 체크박스 줄 (Phase 1 하단, count: 카드 개수)
#let order-boxes(count: 5) = {
  v(0.4cm)
  let cells = (text(size: 9.5pt, fill: MID)[올바른 순서:],)
  for i in range(count) {
    cells.push(box(width: 1.3em, height: 1.3em, stroke: DARK + 0.7pt, radius: 1pt))
    if i < count - 1 {
      cells.push(text(fill: MID, size: 9.5pt)[#sym.arrow.r])
    }
  }
  grid(columns: cells.len(), gutter: 5pt, align: center + horizon, ..cells)
}

/// 빈칸 밑줄 (긴 것)
#let blank(w: 3cm) = box(width: w, height: 1em, stroke: (bottom: DARK + 0.7pt))

/// 빈칸 밑줄 (짧은 것, math 안에서)
#let mb(w: 2cm) = box(width: w, height: 0.9em, stroke: (bottom: DARK + 0.7pt))

/// 정의/명제 박스 (DEFINITION, THEOREM 등)
#let def-box(tag, tagcolor, title, body) = {
  rect(stroke: LIGHT + 0.6pt, width: 100%, inset: 0pt, radius: 3pt)[
    #rect(fill: tagcolor, width: 100%, inset: (x: 12pt, y: 6pt),
          stroke: none, radius: (top: 3pt))[
      #text(fill: white, weight: "bold", size: 9.5pt)[#tag]
      #h(6pt)
      #text(fill: rgb("#DDDDDD"), size: 9.5pt)[#title]
    ]
    #pad(x: 14pt, y: 10pt)[#body]
  ]
}

/// Phase 3 서술형 문제 박스
#let problem-box(body) = {
  rect(stroke: (left: P3 + 3pt, rest: LIGHT + 0.6pt), inset: (left: 14pt, rest: 11pt),
       width: 100%, radius: 2pt)[
    #text(weight: "bold", fill: P3)[【서술형】]
    #h(4pt)
    #body
  ]
}

/// Phase 3 서술형 빈 답란 (n: 줄 수)
#let answer-box(label: "풀이", n: 12) = {
  rect(stroke: LIGHT + 0.6pt, width: 100%, inset: 0pt, radius: 3pt)[
    #rect(fill: BG, width: 100%, stroke: (bottom: LIGHT + 0.6pt),
          inset: (x: 12pt, y: 5pt), radius: (top: 3pt))[
      #grid(columns: (auto, 1fr, auto),
        text(weight: "bold", size: 9pt, fill: MID)[#label],
        [],
        text(size: 8pt, fill: LIGHT)[앞 Phase를 가리고 작성하세요],
      )
    ]
    #pad(x: 10pt, top: 0pt, bottom: 0pt)[
      #for i in range(n) {
        v(0.95cm)
        line(length: 100%, stroke: LIGHT + 0.5pt)
      }
      v(0.4cm)
    ]
    #align(right)[
      #pad(right: 12pt, bottom: 6pt)[
        #box(stroke: DARK + 0.7pt, inset: (x: 6pt, y: 5pt), radius: 1pt)[
          $square.filled$
        ]
      ]
    ]
  ]
}

/// Phase 2 빈칸 채우기 단계 번호 배지
#let snum(n) = box(
  fill: P2, inset: (x: 6pt, y: 3pt), radius: 2pt,
)[#text(fill: white, weight: "bold", size: 9.5pt)[(#n)]]

/// Phase 2 빈칸 채우기 전체 래퍼 박스
#let fill-box(body) = {
  rect(stroke: LIGHT + 0.6pt, inset: 0pt, width: 100%, radius: 3pt)[
    #rect(fill: P2L, width: 100%, stroke: (bottom: P2 + 0.8pt),
          inset: (x: 12pt, y: 6pt), radius: (top: 3pt))[
      #text(weight: "bold", size: 9.5pt, fill: P2)[[증명]]
      #h(4pt)
      #text(size: 8.5pt, fill: MID)[각 단계에서 사용한 근거(∵)도 함께 써보세요]
    ]
    #pad(x: 16pt, y: 0pt)[
      #v(0.5cm)
      #body
      #v(0.6cm)
    ]
  ]
}

/// 답안지 헤더
#let answer-sheet-header() = {
  rect(fill: ANSL, stroke: ANS + 1pt, inset: (x: 14pt, y: 9pt),
       width: 100%, radius: 3pt)[
    #text(weight: "bold", fill: ANS, size: 12pt)[✦ 정답 및 모범 풀이]
    #h(0.5em)
    #text(size: 9pt, fill: rgb("#888"))[이 페이지는 모든 Phase를 완료한 후 확인하세요]
  ]
}

/// 답안지 섹션 박스 (Phase 1/2/3 정답)
#let answer-section(color, body) = {
  rect(stroke: (left: color + 3pt, rest: LIGHT + 0.6pt), inset: (left: 14pt, rest: 11pt),
       width: 100%, radius: 2pt)[
    #body
  ]
}
