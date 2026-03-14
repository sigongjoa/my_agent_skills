// cetz-tree.typ — 확률 트리 / 수형도 CeTZ 템플릿

#import "@preview/cetz:0.4.2"

// ── 확률 트리 (2~3단계) ──────────────────────────────
// 사용 예:
// #prob-tree(
//   root: "시작",
//   branches: (
//     (label: "앞", prob: "1/2", children: (
//       (label: "앞", prob: "1/2", value: "HH"),
//       (label: "뒤", prob: "1/2", value: "HT"),
//     )),
//     (label: "뒤", prob: "1/2", children: (
//       (label: "앞", prob: "1/2", value: "TH"),
//       (label: "뒤", prob: "1/2", value: "TT"),
//     )),
//   )
// )

#let prob-tree(
  root: "S",
  branches: (),
  node-radius: 0.18,
  h-gap: 2.8,   // 가로 간격 (cm)
  v-gap: 1.2,   // 세로 간격 (cm)
  show-prob: true,
) = cetz.canvas(length: 1cm, {
  import cetz.draw: *

  let draw-node = (x, y, lbl) => {
    circle((x, y), radius: node-radius, fill: white, stroke: 1pt)
    content((x, y), text(8pt)[#lbl])
  }

  let n-branches = branches.len()
  let total-h = (n-branches - 1) * v-gap

  // 루트
  draw-node(0, 0, root)

  // 1단계 브랜치
  for (i, b) in branches.enumerate() {
    let y1 = total-h / 2 - i * v-gap
    let x1 = h-gap

    line((node-radius, 0), (x1 - node-radius, y1), stroke: 0.8pt)
    draw-node(x1, y1, b.label)

    if show-prob {
      content(
        (h-gap / 2 - 0.1, y1 / 2 + 0.15),
        text(7pt, fill: rgb("#e74c3c"))[#b.prob]
      )
    }

    // 2단계 브랜치
    if "children" in b {
      let children = b.children
      let n-ch = children.len()
      let ch-total = (n-ch - 1) * v-gap * 0.7

      for (j, ch) in children.enumerate() {
        let y2 = y1 + ch-total / 2 - j * v-gap * 0.7
        let x2 = h-gap * 2

        line((x1 + node-radius, y1), (x2 - node-radius, y2), stroke: 0.8pt)

        if "value" in ch {
          // 끝 노드 (사각형)
          rect(
            (x2 - 0.3, y2 - 0.18),
            (x2 + 0.3, y2 + 0.18),
            stroke: 0.8pt, fill: luma(240)
          )
          content((x2, y2), text(8pt)[#ch.value])
        } else {
          draw-node(x2, y2, ch.label)
        }

        if show-prob {
          content(
            (x1 + h-gap / 2 - 0.1, (y1 + y2) / 2 + 0.15),
            text(7pt, fill: rgb("#e74c3c"))[#ch.prob]
          )
        }
      }
    }
  }
})

// ── 경우의 수 수형도 (단순) ──────────────────────────
// n단계, 각 단계 선택지 나열
#let count-tree(
  stages: (),  // (("A","B","C"), ("1","2"), ...) 각 단계의 선택지
  stage-labels: (),  // ("1차", "2차") 단계 이름
  h-gap: 2.5,
  v-gap: 0.8,
) = cetz.canvas(length: 1cm, {
  import cetz.draw: *

  // 루트
  circle((0, 0), radius: 0.15, fill: black, stroke: none)

  // 단계별로 그리기
  let prev-nodes = ((0, 0),)

  for (si, stage) in stages.enumerate() {
    let x = (si + 1) * h-gap
    let n = stage.len()
    let total-h = (n - 1) * v-gap
    let new-nodes = ()

    // 라벨
    if si < stage-labels.len() {
      content((x, total-h / 2 + 0.5), text(8pt, weight: "bold")[#stage-labels.at(si)])
    }

    for (pi, (px, py)) in prev-nodes.enumerate() {
      for (ci, choice) in stage.enumerate() {
        // 현재 prev 노드 기준으로 균등 배분
        let offset = (n - 1) * v-gap / 2 - ci * v-gap
        let ny = py - offset

        line((px + 0.15, py), (x - 0.15, ny), stroke: 0.7pt)
        circle((x, ny), radius: 0.04, fill: black, stroke: none)
        content((x + 0.05, ny + 0.15), text(7.5pt)[#choice])

        new-nodes.push((x, ny))
      }
    }
    prev-nodes = new-nodes
  }
})
