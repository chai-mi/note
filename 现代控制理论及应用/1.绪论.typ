#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#import "../template.typ": note
#show: note.with()

= 自动控制理论的产生和发展分为三个阶段

+ 经典控制理论
+ 现代控制理论
+ 智能控制

#{
  set text(12pt)
  diagram(
    node-stroke: 1pt,
    node((-1, 0), [设定值], stroke: none),
    edge("-|>"),
    node((0, 0), $times$, radius: 10pt),
    edge("-|>"),
    node((1, 0), [控制器]),
    edge("-|>"),
    node((2, 0), [执行器]),
    edge("-|>"),
    node((3, 0), [被控对象]),

    edge((3, -1), "d", "-|>", [扰动]),
    edge("-|>"),
    node((5, 0), [被控变量], stroke: none),

    edge((4, 0), "d,l,l", "-|>"),
    edge((2, 1), "l,l,u", "-|>"),
    node((2, 1), [检测传感器]),
  )
}

#pagebreak()
= 经典控制

== 建模方法

+ 微分方程
+ 传递函数
+ 信号框图
+ 结构图

== 分析方法

+ 时域
+ 频域
+ 根轨迹

特性

+ 稳定性
+ 快速性
+ 准确性

== 矫正

+ 超前
+ 滞后
