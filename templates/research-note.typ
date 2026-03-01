// ── Research Note Template ──────────────────────────────────────────
#let note(
  title:          "Untitled",
  date:           datetime.today(),
  status:         "solved",
  tags:           (),
  project:        none,
  version:        none,
  background:     [],
  problem:        [],
  investigation:  [],
  solution:       [],
  verification:   [],
  root-cause:     [],
  conclusion:     [],
  related-issues: (),
  references:     [],
) = {

// ── 페이지 설정 ───────────────────────────────────────────────────
set document(title: title)
set page(
  paper: "a4",
  margin: (x: 2.8cm, y: 3.0cm),
  header: context {
    if counter(page).get().first() > 1 {
      grid(
        columns: (1fr, auto),
        align(left, text(8pt, luma(150), "Research Note")),
        align(right, text(8pt, luma(150), date.display("[year]-[month]-[day]"))),
      )
      line(length: 100%, stroke: 0.4pt + luma(200))
    }
  },
  footer: context {
    align(center, text(8pt, luma(150), counter(page).display("1 / 1", both: true)))
  },
)
set text(font: ("Linux Libertine", "Noto Sans CJK KR", "New Computer Modern"), size: 10.5pt)
set par(leading: 0.85em, justify: true)

// 코드블록 스타일
show raw.where(block: true): it => block(
  width: 100%,
  fill: luma(248),
  stroke: 0.5pt + luma(220),
  radius: 4pt,
  inset: (x: 10pt, y: 8pt),
  text(font: "DejaVu Sans Mono", size: 9pt, it),
)
show raw.where(block: false): it => box(
  fill: luma(245),
  radius: 3pt,
  inset: (x: 4pt, y: 2pt),
  text(font: "DejaVu Sans Mono", size: 9pt, it),
)

// ── 상태 색상 ─────────────────────────────────────────────────────
let (sc, sb) = if status == "solved" {
  (rgb("#2d6a4f"), rgb("#d8f3dc"))
} else if status == "in-progress" {
  (rgb("#e76f00"), rgb("#fff3cd"))
} else {
  (rgb("#c1121f"), rgb("#fde8e8"))
}

// ── 태그 칩 헬퍼 ──────────────────────────────────────────────────
let chip(bg, fg, content) = box(
  fill: bg, radius: 3pt, inset: (x: 6pt, y: 2pt),
  text(8pt, fg, content),
)

// ── 타이틀 블록 ───────────────────────────────────────────────────
block(
  width: 100%, fill: luma(247), radius: 6pt,
  inset: (x: 18pt, y: 14pt),
  grid(
    columns: (1fr, auto),
    gutter: 8pt,
    [
      #text(17pt, weight: "bold", title) \
      #v(4pt)
      #text(9pt, luma(100), date.display("[year].[month].[day]"))
      #if project != none { h(6pt); chip(luma(235), luma(60), "📁 " + project) }
      #if version != none { h(4pt); chip(luma(235), luma(60), "v" + version) }
      #v(3pt)
      #for tag in tags { chip(rgb("#e8f4fd"), rgb("#1565c0"), tag); h(4pt) }
    ],
    align(horizon,
      box(
        fill: sb, stroke: 0.5pt + sc, radius: 4pt,
        inset: (x: 10pt, y: 5pt),
        text(8.5pt, sc, weight: "bold", upper(status)),
      )
    ),
  )
)

v(1.6em)

// ── 섹션 헬퍼 ─────────────────────────────────────────────────────
let section(icon, heading, body, accent: luma(210)) = {
  if body != [] {
    grid(
      columns: (auto, 1fr), gutter: 6pt,
      text(13pt, icon),
      text(12pt, weight: "bold", heading),
    )
    v(2pt)
    block(
      width: 100%, fill: luma(252),
      stroke: (left: 3pt + accent, rest: none),
      inset: (left: 12pt, right: 8pt, y: 8pt),
      body,
    )
    v(1.3em)
  }
}

// ── 본문 섹션 ─────────────────────────────────────────────────────
section("🔍", "Background",             background)
section("❗", "Problem Statement",       problem)
section("🧪", "Investigation",           investigation)
section("✅", "Solution",                solution)
section("🔬", "Verification",            verification,   accent: rgb("#2d6a4f"))
section("🧠", "Root Cause",              root-cause)
section("📌", "Conclusion & Takeaways",  conclusion)

// ── Related Issues ────────────────────────────────────────────────
if related-issues.len() > 0 {
  grid(
    columns: (auto, 1fr), gutter: 6pt,
    text(13pt, "🔗"),
    text(12pt, weight: "bold", "Related Issues"),
  )
  v(2pt)
  block(
    width: 100%, fill: luma(252),
    stroke: (left: 3pt + rgb("#1565c0"), rest: none),
    inset: (left: 12pt, right: 8pt, y: 8pt),
    for issue in related-issues {
      box(
        fill: rgb("#e8f4fd"), radius: 3pt,
        inset: (x: 6pt, y: 3pt),
        text(9pt, rgb("#1565c0"), weight: "bold", "#" + str(issue)),
      )
      h(6pt)
    },
  )
  v(1.3em)
}

// ── References ────────────────────────────────────────────────────
section("📚", "References", references)

} // end note
