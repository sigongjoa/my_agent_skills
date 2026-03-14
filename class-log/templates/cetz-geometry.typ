// cetz-geometry.typ — 도형/기하 CeTZ 템플릿

#import "@preview/cetz:0.4.2"

// ── 좌표평면 + 점/선분 ───────────────────────────────
#let coord-plane(
  x-min: -4, x-max: 4,
  y-min: -4, y-max: 4,
  points: (),    // ((x, y, label, anchor), ...)
  segments: (),  // ((p1, p2, style), ...)
  polygons: (),  // ((pts-list, fill, stroke), ...)
  circles: (),   // ((center, r, style), ...)
  size: 5,       // cm per unit scaled
) = cetz.canvas(length: size * 1cm / (x-max - x-min), {
  import cetz.draw: *

  // 격자
  for xi in range(int(x-min), int(x-max) + 1) {
    line((xi, y-min), (xi, y-max), stroke: 0.25pt + luma(210))
  }
  for yi in range(int(y-min), int(y-max) + 1) {
    line((x-min, yi), (x-max, yi), stroke: 0.25pt + luma(210))
  }

  // 축
  line((x-min - 0.3, 0), (x-max + 0.6, 0),
    mark: (end: (symbol: ">", size: 0.25)))
  line((0, y-min - 0.3), (0, y-max + 0.6),
    mark: (end: (symbol: ">", size: 0.25)))
  content((x-max + 0.7, 0), text(9pt)[$x$])
  content((0.15, y-max + 0.65), text(9pt)[$y$])
  content((-0.22, -0.22), text(8pt)[$O$])

  // 눈금
  for xi in range(int(x-min), int(x-max) + 1) {
    if xi != 0 {
      line((xi, -0.08), (xi, 0.08))
      content((xi, -0.28), text(7pt)[#xi])
    }
  }
  for yi in range(int(y-min), int(y-max) + 1) {
    if yi != 0 {
      line((-0.08, yi), (0.08, yi))
      content((-0.3, yi), text(7pt)[#yi])
    }
  }

  // 다각형
  for (pts, fill-color, stk) in polygons {
    let style = if fill-color != none {
      (fill: fill-color, stroke: stk)
    } else {
      (stroke: stk)
    }
    line(..pts, close: true, ..style)
  }

  // 원
  for (cx, cy, r, stk) in circles {
    circle((cx, cy), radius: r, stroke: stk, fill: none)
  }

  // 선분
  for (p1, p2, stk) in segments {
    line(p1, p2, stroke: stk)
  }

  // 점
  for (px, py, lbl, anc) in points {
    circle((px, py), radius: 0.07, fill: black, stroke: none)
    let anchor = if anc == none { "south-west" } else { anc }
    content((px, py), anchor: anchor, padding: 4pt, text(9pt)[#lbl])
  }
})

// ── 삼각형 (라벨 + 각도 표시) ────────────────────────
#let triangle(
  A: (0, 0), B: (4, 0), C: (2, 3),
  labels: ("A", "B", "C"),
  side-labels: (none, none, none),  // AB, BC, CA
  show-right-angle: none,           // "A"|"B"|"C"
  color: black,
) = cetz.canvas({
  import cetz.draw: *

  let pts = (A, B, C)
  line(A, B, B, C, C, A, close: true, stroke: color + 1.2pt)

  let anchors = ("north", "north", "south")
  for (i, (px, py)) in pts.enumerate() {
    circle((px, py), radius: 0.04, fill: color, stroke: none)
    content((px, py), anchor: anchors.at(i), padding: 5pt,
      text(10pt, weight: "bold")[#labels.at(i)])
  }

  // 직각 표시
  if show-right-angle == "A" {
    let d = 0.18
    rect(A, (A.at(0) + d, A.at(1) + d), stroke: 0.7pt)
  }
})

// ── 원 (반지름, 호, 중심각) ──────────────────────────
#let circle-fig(
  center: (0, 0),
  radius: 2,
  points-on-circle: (),  // ((angle-deg, label), ...)
  show-center: true,
  center-label: $O$,
  arcs: (),              // ((start-deg, end-deg, style), ...)
  chords: (),            // ((pt1-deg, pt2-deg), ...)
) = cetz.canvas({
  import cetz.draw: *

  let (cx, cy) = center

  circle(center, radius: radius, stroke: 1.2pt)

  if show-center {
    circle(center, radius: 0.06, fill: black, stroke: none)
    content(center, anchor: "south-east", padding: 3pt, text(9pt)[#center-label])
  }

  let angle-to-pt = (deg) => {
    let rad = deg * calc.pi / 180
    (cx + radius * calc.cos(rad), cy + radius * calc.sin(rad))
  }

  for (deg, lbl) in points-on-circle {
    let pt = angle-to-pt(deg)
    circle(pt, radius: 0.06, fill: black, stroke: none)
    let anchor = if deg > 180 { "east" } else { "west" }
    content(pt, anchor: anchor, padding: 4pt, text(9pt)[#lbl])
  }

  for (d1, d2) in chords {
    line(angle-to-pt(d1), angle-to-pt(d2), stroke: 1pt)
  }
})
