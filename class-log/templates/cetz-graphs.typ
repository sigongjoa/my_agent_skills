// cetz-graphs.typ — 함수 그래프 CeTZ 템플릿
// /img-gen skill에서 호출하는 참조 라이브러리

#import "@preview/cetz:0.4.2"
#import "@preview/cetz-plot:0.1.3": plot

// ── 함수 그래프 (단일/복수 함수) ─────────────────────
// 사용 예:
// #function-graph(
//   x-min: -3, x-max: 3, y-min: -2, y-max: 6,
//   functions: ((x => x * x, (stroke: blue)),),
//   key-points: ((0, 0, $O$), (1, 1, $(1,1)$)),
// )
#let function-graph(
  x-min: -4, x-max: 4,
  y-min: -4, y-max: 4,
  functions: (),      // ((fn, style), ...) — fn: x => y값
  key-points: (),     // ((x, y, label), ...)
  asymptotes: (),     // (x값 또는 y값, "v"|"h")
  size: (5.5, 4.5),
  caption: none,
) = {
  block(breakable: false)[
    #cetz.canvas(length: 1cm, {
      import cetz.draw: *

      plot.plot(
        size: size,
        x-min: x-min, x-max: x-max,
        y-min: y-min, y-max: y-max,
        x-tick-step: 1, y-tick-step: 1,
        x-label: $x$, y-label: $y$,
        x-grid: true, y-grid: true,
        {
          for (fn, style) in functions {
            plot.add(
              fn,
              domain: (x-min + 0.01, x-max - 0.01),
              style: style,
              samples: 80,
            )
          }
          for (x, y, lbl) in key-points {
            plot.add(((x, y),), mark: "o", mark-size: 0.1, style: (stroke: none, fill: black))
          }
        }
      )
      // 주요점 라벨 (plot 밖에서)
      for (x, y, lbl) in key-points {
        let px = (x - x-min) / (x-max - x-min) * size.at(0)
        let py = (y - y-min) / (y-max - y-min) * size.at(1)
        content((px + 0.15, py + 0.15), text(8pt)[#lbl])
      }
    })
    #if caption != none { align(center, text(8pt, fill: gray)[#caption]) }
  ]
}

// ── 로그/지수 그래프 (수능 빈출) ──────────────────────
// 예: y = log₂x, y = 2^x 비교
#let log-exp-graph(
  base: 2,
  x-min: -1, x-max: 4,
  y-min: -2, y-max: 4,
  show-log: true,
  show-exp: true,
  show-identity: true,
) = function-graph(
  x-min: x-min, x-max: x-max,
  y-min: y-min, y-max: y-max,
  functions: (
    if show-exp   { (x => calc.pow(float(base), x), (stroke: rgb("#2980b9") + 1.5pt)) },
    if show-log   { (x => if x > 0.05 { calc.log(x, base: base) } else { none }, (stroke: rgb("#e74c3c") + 1.5pt)) },
    if show-identity { (x => x, (stroke: gray + 0.8pt + (dash: "dashed"))) },
  ).filter(x => x != false),
  key-points: ((1, 0, $(1,0)$),),
)

// ── 이차함수 그래프 ───────────────────────────────────
// y = a(x-p)² + q
#let quadratic-graph(
  a: 1, p: 0, q: 0,
  x-min: -4, x-max: 4,
  y-min: -3, y-max: 6,
  color: rgb("#2980b9"),
) = {
  let fn = x => a * (x - p) * (x - p) + q
  let vertex = (p, q)
  function-graph(
    x-min: x-min, x-max: x-max,
    y-min: y-min, y-max: y-max,
    functions: ((fn, (stroke: color + 1.5pt)),),
    key-points: (vertex + ($V$,),),
  )
}

// ── 증감표 (함수 그래프 보조) ─────────────────────────
#let variation-table(
  x-vals: (),   // ("−∞", −1, 0, 2, "∞")
  f-prime: (),  // ("+", 0, "−", 0, "+")  — f'의 부호
  f-vals: (),   // ("↗", "극대", "↘", "극소", "↗") 또는 구체적 값
) = {
  let n-cols = x-vals.len()
  table(
    columns: (auto,) + (1fr,) * n-cols,
    stroke: 0.5pt,
    align: center + horizon,
    inset: 6pt,
    fill: (col, row) => if col == 0 { luma(230) } else { white },
    [$x$],        ..x-vals.map(v => [$#v$]),
    [$f'(x)$],    ..f-prime.map(v => [$#v$]),
    [$f(x)$],     ..f-vals.map(v => [#v]),
  )
}
