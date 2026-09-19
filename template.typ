#import "@preview/numbly:0.1.0": numbly

// 三线表
#let table_stroke(stroke) = (x, y) => (
  top: if y < 2 { stroke } else { 0pt },
  bottom: stroke,
)

#let note = (body, disable-background: false) => {
  // 设置页面样式
  set page(
    height: auto,
    fill: if (disable-background) { none } else { oklch(97%, 0.005, 250deg) },
    margin: (x: 1.2cm, y: 1cm),
  )

  // 设置 heading 的样式
  set heading(numbering: numbly(
    none,
    "{2:1}.",
    "{2:1}.{3:1}.",
    none,
    none,
    none,
  ))
  show heading.where(level: 1): it => {
    // 重置计数器
    counter(math.equation).update(0)
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(figure.where(kind: raw)).update(0)

    block(
      width: 100%,
      stroke: (bottom: 1pt + black),
      inset: (bottom: 0.5em),
      it,
    )
  }

  // 设置编号
  set figure(numbering: num => numbering("1-1", counter(heading).get().first(), num))
  show figure.where(kind: table): set figure(numbering: num => numbering("1.1", counter(heading).get().first(), num))
  set math.equation(numbering: nums => numbering("(1-1)", counter(heading).get().first(), nums))

  // 设置 table 的样式
  show figure.where(kind: table): set figure.caption(position: top)
  set table(
    stroke: table_stroke(1pt),
    align: horizon,
  )

  // 设置字体
  set text(
    lang: "zh",
    font: (
      (name: "Noto Sans SC", covers: "latin-in-cjk"),
      "Noto Sans SC",
    ),
    15pt,
  )
  show math.equation: set text(font: (
    "New Computer Modern Math",
    "Noto Sans SC",
  ))
  show raw: set text(font: "Noto Sans Mono")

  // 设置公式
  set math.vec(delim: "[")
  set math.mat(delim: "[")

  body
}
