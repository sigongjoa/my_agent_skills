// cetz-chart.typ — 히스토그램 / 도수분포 / 수열 CeTZ 템플릿

#import "@preview/cetz:0.4.2"
#import "@preview/cetz-plot:0.1.3": chart, plot

// ── 히스토그램 / 도수분포 막대그래프 ─────────────────
// 사용 예:
// #histogram(
//   data: (("60이상~70미만", 3), ("70이상~80미만", 7), ("80이상~90미만", 12), ("90이상~100미만", 5)),
//   y-label: "도수(명)",
// )
#let histogram(
  data: (),          // ((계급, 도수), ...)
  y-label: "도수",
  bar-color: rgb("#2980b9"),
  size: (6, 4),
  show-freq-table: true,
) = {
  block(breakable: false)[
    #cetz.canvas(length: 1cm, {
      import cetz.draw: *

      let max-val = data.fold(0, (acc, d) => calc.max(acc, d.at(1)))
      let n = data.len()
      let bar-w = size.at(0) / n

      // 축
      line((0, 0), (size.at(0) + 0.5, 0), mark: (end: (symbol: ">", size: 0.2)))
      line((0, 0), (0, size.at(1) + 0.4), mark: (end: (symbol: ">", size: 0.2)))
      content((0, size.at(1) + 0.5), text(8pt)[#y-label])

      // 막대
      for (i, (lbl, val)) in data.enumerate() {
        let bh = val / max-val * size.at(1)
        let bx = i * bar-w

        rect(
          (bx, 0), (bx + bar-w, bh),
          fill: bar-color.transparentize(20%),
          stroke: bar-color + 0.8pt
        )

        // x축 라벨
        content(
          (bx + bar-w / 2, -0.35),
          text(6.5pt, angle: -30deg)[#lbl]
        )

        // 값 표시
        content(
          (bx + bar-w / 2, bh + 0.2),
          text(8pt, weight: "bold")[#val]
        )
      }

      // y축 눈금
      let step = calc.ceil(max-val / 5)
      for yi in range(0, max-val + 1, step: step) {
        let ypos = yi / max-val * size.at(1)
        line((-0.08, ypos), (0, ypos))
        content((-0.35, ypos), text(7pt)[#yi])
      }
    })

    // 도수분포표
    #if show-freq-table {
      v(0.5em)
      table(
        columns: (auto,) + (1fr,) * data.len(),
        stroke: 0.4pt,
        align: center + horizon,
        inset: 5pt,
        fill: (col, row) => if row == 0 or col == 0 { luma(225) } else { white },
        [계급], ..data.map(d => text(8pt)[#d.at(0)]),
        [도수], ..data.map(d => [#d.at(1)]),
        [상대도수], ..data.map(d => {
          let total = data.fold(0, (a, x) => a + x.at(1))
          text(8pt)[#calc.round(d.at(1) / total, digits: 2)]
        }),
      )
    }
  ]
}

// ── 수열 시각화 (점/막대) ─────────────────────────────
// a_n 값들을 점 또는 막대로 표시
#let sequence-plot(
  terms: (),       // (a1, a2, a3, ...) 값 리스트
  n-start: 1,
  style: "dot",    // "dot" | "bar"
  color: rgb("#e74c3c"),
  size: (6, 4),
  show-formula: none,  // 예: $a_n = 2n - 1$
) = {
  let n = terms.len()
  let max-val = terms.fold(0, (a, v) => calc.max(a, v))
  let min-val = terms.fold(max-val, (a, v) => calc.min(a, v))

  block(breakable: false)[
    #cetz.canvas(length: 1cm, {
      import cetz.draw: *

      // 축
      line((-0.2, 0), (size.at(0) + 0.5, 0), mark: (end: (symbol: ">", size: 0.2)))
      line((0, min-val / max-val * size.at(1) - 0.2), (0, size.at(1) + 0.4),
        mark: (end: (symbol: ">", size: 0.2)))
      content((size.at(0) + 0.6, 0), text(8pt)[$n$])
      content((0.15, size.at(1) + 0.5), text(8pt)[$a_n$])

      let x-unit = size.at(0) / (n + 1)
      let y-unit = size.at(1) / max-val

      for (i, val) in terms.enumerate() {
        let nx = (i + 1) * x-unit
        let ny = val * y-unit

        // n축 라벨
        let n-idx = n-start + i
        content((nx, -0.3), text(8pt)[#n-idx])

        if style == "bar" {
          line((nx, 0), (nx, ny), stroke: color + 2pt)
          circle((nx, ny), radius: 0.09, fill: color, stroke: none)
        } else {
          circle((nx, ny), radius: 0.09, fill: color, stroke: none)
          content((nx + 0.15, ny + 0.2), text(7pt)[#val])
        }

        // y축 값
        line((-0.06, ny), (0.06, ny), stroke: 0.5pt)
        content((-0.3, ny), text(7pt)[#val])
      }

      // 점들 연결 (dot 스타일)
      if style == "dot" and n > 1 {
        for i in range(n - 1) {
          let x1 = (i + 1) * x-unit
          let y1 = terms.at(i) * y-unit
          let x2 = (i + 2) * x-unit
          let y2 = terms.at(i + 1) * y-unit
          line((x1, y1), (x2, y2), stroke: color + 0.5pt + (dash: "dashed"))
        }
      }
    })

    #if show-formula != none {
      align(center, text(9pt, fill: gray)[#show-formula])
    }
  ]
}
