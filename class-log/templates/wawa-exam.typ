// wawa-exam.typ
// examine-ib 기반 커스텀 라이브러리 — 와와 학습코칭센터 알파시티점
// 5지선다 수능 스타일

#let wawa-indent = 0.35in
#let exam-id-state = state("exam-id", [])

#let conf(
  doc,
  student: [이름],
  subject: [수학],
  date: [2026년 3월],
  exam-name: [정기고사],
) = {
  set page(
    "a4",
    margin: (left: 1in - wawa-indent, right: 0.9in - wawa-indent, top: 1in, bottom: 0.9in),
    header: context {
      set text(9pt, fill: rgb("#444444"))
      grid(
        columns: (1fr, auto),
        align(left)[
          #text(weight: "bold")[와와 학습코칭센터 알파시티점]
        ],
        align(right)[
          #subject #h(0.5em) | #h(0.5em) #date
        ]
      )
      v(2pt)
      line(length: 100%, stroke: 0.4pt + rgb("#aaaaaa"))
    },
    footer: context {
      line(length: 100%, stroke: 0.4pt + rgb("#aaaaaa"))
      v(2pt)
      set text(8pt, fill: rgb("#999999"))
      grid(
        columns: (1fr, 1fr, 1fr),
        align(left)[와와 학습코칭센터],
        align(center)[알파시티점],
        align(right)[#counter(page).display() / #counter(page).final().at(0)]
      )
    }
  )
  set par(spacing: 0.35in, leading: 0.26in)
  set text(11pt, font: ("Noto Sans CJK KR", "Noto Serif CJK KR"))
  set table(inset: 0em, stroke: none)
  counter("question").update(1)
  counter("marks").update(0)
  doc
}

// ── 표지 ────────────────────────────────────────────
#let title-page(
  student: [이름],
  subject: [수학],
  date: [2026년 3월],
  exam-name: [정기고사],
  time-limit: [50분],
  total-marks: [100점],
  instructor: [홍길동],
) = page(
  "a4",
  header: none,
  footer: none,
  margin: (left: 1in, right: 1in, top: 0.6in, bottom: 0.8in),
  {
    // 상단 브랜드 블록
    block(
      fill: rgb("#1a1a2e"),
      width: 100%,
      inset: (x: 20pt, y: 14pt),
      radius: 6pt,
    )[
      #grid(
        columns: (1fr, auto),
        align(left + horizon)[
          #text(10pt, fill: rgb("#8888cc"))[와와 학습코칭센터 알파시티점]
        ],
        align(right + horizon)[
          #text(20pt, fill: white, weight: "bold")[#student #exam-name]
        ]
      )
    ]

    v(1.2em)

    // 과목 / 날짜 / 시간 정보
    grid(
      columns: (1fr, 1fr, 1fr),
      column-gutter: 8pt,
      block(stroke: 0.5pt + rgb("#cccccc"), inset: (x: 12pt, y: 8pt), radius: 3pt, width: 100%)[
        #text(9pt, fill: rgb("#888888"))[과목]\
        #text(13pt, weight: "bold")[#subject]
      ],
      block(stroke: 0.5pt + rgb("#cccccc"), inset: (x: 12pt, y: 8pt), radius: 3pt, width: 100%)[
        #text(9pt, fill: rgb("#888888"))[시험일]\
        #text(13pt, weight: "bold")[#date]
      ],
      block(stroke: 0.5pt + rgb("#cccccc"), inset: (x: 12pt, y: 8pt), radius: 3pt, width: 100%)[
        #text(9pt, fill: rgb("#888888"))[제한시간]\
        #text(13pt, weight: "bold")[#time-limit]
      ],
    )

    v(1em)

    // 수험자 정보
    block(
      stroke: 1pt + rgb("#1a1a2e"),
      inset: (x: 16pt, y: 12pt),
      radius: 4pt,
      width: 100%,
    )[
      #grid(
        columns: (1fr, 1fr, 1fr),
        column-gutter: 12pt,
        stack(dir: ttb, spacing: 4pt,
          text(9pt, fill: rgb("#888888"))[이름],
          line(length: 100%, stroke: 0.8pt + rgb("#333333"))
        ),
        stack(dir: ttb, spacing: 4pt,
          text(9pt, fill: rgb("#888888"))[날짜],
          line(length: 100%, stroke: 0.8pt + rgb("#333333"))
        ),
        stack(dir: ttb, spacing: 4pt,
          text(9pt, fill: rgb("#888888"))[점수],
          grid(
            columns: (1fr, auto),
            line(length: 100%, stroke: 0.8pt + rgb("#333333")),
            text(9pt)[　/ #total-marks]
          )
        ),
      )
    ]

    v(1em)
    line(length: 100%, stroke: 1.5pt + rgb("#1a1a2e"))
    v(0.5em)

    // 주의사항
    block(fill: luma(245), inset: (x: 14pt, y: 10pt), radius: 3pt, width: 100%)[
      #text(9.5pt)[
        *수험자 유의사항*\
        #set list(marker: [•], indent: 8pt, body-indent: 6pt)
        - 모든 문제는 풀이 과정을 답안 칸에 직접 작성하세요.
        - 객관식 문제는 정답 번호에 동그라미(○)를 하세요.
        - 계산 실수를 포함한 오류는 감점 사유가 됩니다.
        - 주어진 답안 칸 외의 공간에 작성한 내용은 채점하지 않습니다.
      ]
    ]

    v(1em)
    align(right)[
      #text(9pt, fill: rgb("#888888"))[강사: #instructor | 와와 학습코칭센터 알파시티점]
    ]
  }
)

// ── 내부 헬퍼: 들여쓰기 테이블 ────────────────────────
#let indent-table(indent: 1, layer: 0, ..args) = {
  let content-width = 210mm - 2in + wawa-indent - wawa-indent * layer - 10pt
  if indent == 1 {
    table(
      columns: (wawa-indent, content-width),
      ..args
    )
  } else {
    table(
      columns: (wawa-indent, content-width),
      [], indent-table(indent: indent - 1, layer: layer + 1, ..args),
    )
  }
}

// ── 5지선다 MCQ ──────────────────────────────────────
#let mcq(question, score: 12, a, b, c, d, e) = {
  box(
    indent-table(
      context [*#counter("question").display().*],
      [
        #question
        #v(0.08in)
        #indent-table(
          layer: 1,
          inset: (y: 0.13in, x: 0pt),
          [①], a,
          [②], b,
          [③], c,
          [④], d,
          [⑤], e,
        )
        #v(0.04in)
      ],
    )
  )
  v(0.15in)
  counter("question").step()
  counter("marks").update(x => x + score)
}

// ── 단답형 / 서술형 ──────────────────────────────────
#let saq(question, score: 10, lines: 4) = {
  indent-table(
    context [*#counter("question").display().*],
    [
      #grid(
        columns: (1fr, auto),
        question,
        align(right)[
          #box(
            fill: rgb("#c0392b"),
            inset: (x: 6pt, y: 3pt),
            radius: 2pt,
          )[#text(8pt, fill: white, weight: "bold")[#score #[점]]]
        ]
      )
    ]
  )
  v(-0.2em)
  box(
    stroke: 0.5pt + rgb("#bbbbbb"),
    width: 100%,
    inset: (x: 14pt, top: 8pt, bottom: 8pt),
    radius: 3pt,
  )[
    #set par(leading: 0em, spacing: 0.3in)
    #for _ in range(lines) {
      line(
        stroke: (thickness: 0.8pt, paint: rgb("#dddddd")),
        length: 100%,
      )
    }
  ]
  counter("question").step()
  counter("marks").update(x => x + score)
  v(0.3em)
}

// ── 섹션 구분선 ──────────────────────────────────────
#let section(title) = {
  v(0.5em)
  block(
    fill: rgb("#1a1a2e"),
    width: 100%,
    inset: (x: 12pt, y: 6pt),
    radius: 3pt,
  )[
    #text(10pt, fill: white, weight: "bold")[#title]
  ]
  v(0.3em)
}
