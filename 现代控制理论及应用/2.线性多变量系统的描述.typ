#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#import "../template.typ": note
#show: note.with()

= 线性系统的状态空间描述

状态方程和输出方程总和起来，构成对一个系统的完整动态描述，称为系统的状态空间表达式

对 $n$ 个状态变量，$r$ 个输入，$m$ 个输出的动态系统

$
  cases(
    dot(x)(t) = A x(t) + B u(t),
    y(t) = C x(t) + D u(t)
  )
$

- $A in RR^(n times n)$，表征了系统内部状态的联系，称为系统矩阵
- $B in RR^(n times r)$，表征了输入对状态的作用，称为控制矩阵
- $C in RR^(m times n)$，表征了输出与状态变量的关系，称为输出矩阵
- $D in RR^(m times r)$，表征了输出与输入的关系，称为前馈矩阵

== 几类常见的线性系统及状态空间模型

==== 时变系统

$
  cases(
    dot(x)(t) = A(t) x(t) + B(t) u(t),
    y(t) = C(t) x(t) + D(t) u(t)
  )
$

==== 离散时间系统（差分方程）

$
  cases(
    x(k+1) = A x(k) + B u(k),
    y(k) = C x(k) + D u(k)
  )
$

==== 存在扰动项 $f(t)$ 的系统

$
  cases(
    dot(x)(t) = A x(t) + B u(t) + B_f f(t),
    y(t) = C x(t) + D u(t)
  )
$

==== 存在随机干扰的系统

$
  cases(
    dot(x)(t) = A x(t) + B u(t) + w(t),
    y(t) = C x(t) + D u(t) + v(t)
  )
$

=== 状态结构图

==== 画出一阶微分方程的状态结构图

$
  dot(x) = a x + b u
$

#figure(
  diagram(
    node-stroke: 1pt,
    edge("r", "-|>", $u$),
    node((1, 0), $b$),
    edge("-|>"),
    node((2, 0), $times$, radius: 10pt),
    edge("-|>", $dot(x)$),
    node((3, 0), $integral$),
    edge("rr", "-|>", $x$),
    edge((4, 0), "d,l", "-|>"),
    node((3, 1), $a$),
    edge("l,u", "-|>"),
  ),
)

#pagebreak()
= 线性系统的状态转移方程

== 线性定常齐次状态方程的解(自由解)

所谓系统的自由解，是指系统输入为零时，由初始状态引起的自由运动。此时，状态方程为齐次微分方程：

$
  dot(x) = A x(t)
$ <齐次>

若初始时刻 $t_0$ 时的状态给定为 $x(t_0)= x_0$，则@齐次 有唯一确定解：

$
  x(t) = upright(e)^(A (t-t_0)) x(t_0), t >= t_0,
$

若初始时刻从 $t_0 = 0$ 开始，即 $x(0) = x_0$ ，则其解为

$
  x(t) = upright(e)^(A t) x(0) = upright(e)^(A t) x_0
$

从时间的角度而言，这意味着它使状态向量随着时间的推移，不断地在状态空间中作转移，所以，也称为状态转移矩阵，记为

$
  Phi(t) := upright(e)^(A (t-t_0))
$

== 线性定常非齐次状态方程的解

状态方程为非齐次微分方程：

$
  dot(x) = A x(t) + B u(t)
$

解该微分方程得到：

$
  x(t) & = upright(e)^(A (t-t_0)) x(t_0) + integral^t_(t_0) upright(e)^(A (t-tau)) B u(tau) dif tau \
       & = Phi(t-t_0) x(t_0) + integral^t_(t_0) Phi(t-tau) B u(tau) dif tau
$
