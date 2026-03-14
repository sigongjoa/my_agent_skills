# /img-gen — 수학 문제 이미지 자동 생성

문제 텍스트를 분석하여 CeTZ Typst 코드로 이미지를 생성합니다.
`/test-gen` 워크플로우에서 자동으로 호출되거나, 단독으로 사용할 수 있습니다.

---

## 호출 방식

### 단독 사용
```
/img-gen [문제 텍스트 또는 이미지 설명]
```

### test-gen 내부 자동 호출
각 문제 생성 후 이미지 필요 여부를 자동 판단하여 호출됩니다.

---

## STEP 1 — 이미지 유형 판단

문제 텍스트에서 다음 키워드를 감지하여 유형을 결정합니다.

| 유형 | 감지 키워드 | 템플릿 |
|------|------------|--------|
| `function-graph` | 함수, 그래프, f(x), 증감, 극값, 미분, log, 지수 | cetz-graphs.typ |
| `geometry` | 삼각형, 원, 좌표, 도형, 꼭짓점, 내접, 외접 | cetz-geometry.typ |
| `prob-tree` | 수형도, 경우의 수, 확률 트리, 동전, 주사위 반복 | cetz-tree.typ |
| `histogram` | 히스토그램, 도수분포, 계급, 상대도수, 평균 | cetz-chart.typ |
| `sequence` | 수열, a_n, 점화식, 등차, 등비, 귀납 | cetz-chart.typ |
| `none` | 위 키워드 없음 + 순수 계산 문제 | 이미지 불필요 |

**애매한 경우 판단 기준:**
- "그림을 참고하여" → 반드시 이미지 필요
- 수치만 주어진 단순 계산 → 이미지 불필요
- 영역/범위/구간 문제 → 함수 그래프 필요

---

## STEP 2 — CeTZ 파라미터 추출

문제에서 구체적인 수치를 추출합니다.

### function-graph 추출 대상
- 함수식: `f(x) = x² - 2x + 1` → `a:1, p:1, q:0`
- 정의역: `−3 ≤ x ≤ 3` → `x-min: -3, x-max: 3`
- 주요 점: 꼭짓점, 교점, 극값 좌표
- 점근선 유무

### geometry 추출 대상
- 꼭짓점 좌표: `A(0,0), B(4,0), C(2,3)`
- 반지름, 지름
- 특수각 여부 (30°, 45°, 60°, 90°)

### prob-tree 추출 대상
- 시행 횟수
- 각 단계 선택지와 확률
- 끝 노드 이벤트

### histogram 추출 대상
- 계급 구간
- 각 계급의 도수
- y축 단위 (명, 개 등)

### sequence 추출 대상
- 초기 항: a₁, a₂, ...
- 공차/공비
- 항의 범위 (n=1~6 등)

---

## STEP 3 — CeTZ 코드 생성

추출한 파라미터로 Typst CeTZ 코드 블록을 생성합니다.

### 함수 그래프 예시 (y = x² - 2x)

```typst
#import "@preview/cetz:0.4.2"
#import "@preview/cetz-plot:0.1.3": plot

#cetz.canvas(length: 1cm, {
  import cetz.draw: *
  plot.plot(
    size: (5, 4),
    x-min: -2, x-max: 4,
    y-min: -2, y-max: 5,
    x-tick-step: 1, y-tick-step: 1,
    x-label: $x$, y-label: $y$,
    x-grid: true, y-grid: true,
    {
      plot.add(
        x => x * x - 2 * x,
        domain: (-1.5, 3.5),
        style: (stroke: rgb("#2980b9") + 1.5pt),
        samples: 80,
      )
      // 꼭짓점 (1, -1)
      plot.add(((1, -1),), mark: "o", mark-size: 0.12,
        style: (stroke: none, fill: rgb("#e74c3c")))
    }
  )
})
```

### 확률 트리 예시 (동전 2회)

```typst
#import "@preview/cetz:0.4.2"

#cetz.canvas(length: 1cm, {
  import cetz.draw: *

  let node = (x, y, lbl) => {
    circle((x, y), radius: 0.2, fill: white, stroke: 0.8pt)
    content((x, y), text(8pt)[#lbl])
  }
  let edge = (x1, y1, x2, y2, prob) => {
    line((x1 + 0.2, y1), (x2 - 0.2, y2), stroke: 0.7pt)
    content(((x1+x2)/2 - 0.2, (y1+y2)/2 + 0.18),
      text(7pt, fill: rgb("#e74c3c"))[#prob])
  }

  node(0, 0, [S])
  node(2.5, 1.2, [H])
  node(2.5, -1.2, [T])
  edge(0, 0, 2.5, 1.2, $1/2$)
  edge(0, 0, 2.5, -1.2, $1/2$)

  node(5, 2, [H])
  node(5, 0.4, [T])
  node(5, -0.4, [H])
  node(5, -2, [T])
  edge(2.5, 1.2, 5, 2, $1/2$)
  edge(2.5, 1.2, 5, 0.4, $1/2$)
  edge(2.5, -1.2, 5, -0.4, $1/2$)
  edge(2.5, -1.2, 5, -2, $1/2$)

  // 결과
  for (y, lbl) in ((2, [HH]), (0.4, [HT]), (-0.4, [TH]), (-2, [TT])) {
    rect((5.3, y - 0.18), (6.2, y + 0.18), stroke: 0.6pt, fill: luma(240))
    content((5.75, y), text(8pt)[#lbl])
  }
})
```

### 히스토그램 예시

```typst
#import "cetz-chart.typ": histogram
#histogram(
  data: (
    ("60~70", 3),
    ("70~80", 7),
    ("80~90", 12),
    ("90~100", 5),
  ),
  y-label: "학생 수(명)",
)
```

### 수열 시각화 예시 (a_n = 2n-1)

```typst
#import "cetz-chart.typ": sequence-plot
#sequence-plot(
  terms: (1, 3, 5, 7, 9, 11),
  n-start: 1,
  style: "dot",
  show-formula: $a_n = 2n - 1$,
)
```

---

## STEP 4 — wawa-exam.typ에 삽입할 형식

생성된 CeTZ 코드를 mcq/saq 문제 블록 안에 삽입하는 형식:

```typst
// 문제 블록 내부 — 텍스트 + 이미지
#prob(번호, "배점", color, [
  문제 텍스트...

  #align(center)[
    // 여기에 CeTZ 코드 삽입
    #cetz.canvas(length: 1cm, { ... })
  ]

  나머지 문제 텍스트...
], 답안칸_높이)
```

---

## STEP 5 — 출력

이미지가 포함된 Typst 코드 블록을 출력합니다.

**단독 사용 시:**
```
이미지 유형: function-graph
파라미터: x-min=-2, x-max=4, f(x)=x²-2x, 꼭짓점(1,-1)

[생성된 Typst CeTZ 코드]
```

**test-gen 내부 호출 시:**
해당 문제 Typst 블록에 자동으로 CeTZ 코드를 삽입하고 계속 진행합니다.

---

## 이미지 품질 기준

- 축 방향 표시 (화살표)
- 주요 점 명시적 표시 (●)
- 라벨 겹침 없음
- 인쇄 시 선명도: 0.8pt 이상 stroke
- 글자 크기: 7~9pt (시험지 내 가독성)
- 전체 크기: 너비 5~7cm (2단 레이아웃 기준 한 칸에 맞게)
