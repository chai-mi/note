#import "@preview/fletcher:0.6.0" as fletcher: diagram, edge, node
#import "@preview/note-me:0.6.0"
#import "@preview/zap:0.6.0"

#import "../template.typ": note
#show: note.with()

#let circuit-diagram(body) = context {
  let bg = if page.fill == none { white } else { page.fill }
  zap.circuit({
    import zap: *
    zap.cetz.draw.set-style(
      zap: (
        background: bg,
        stroke: 1pt,
        wire: (stroke: 0.9pt),
        node: (radius: 0.065, stroke: 0.85pt, nofill: bg),
        resistor: (width: 1.05, height: 0.42),
        inductor: (variant: "ieee", width: 1.15, height: 0.36, bumps: 4),
        capacitor: (width: 0.85, distance: 0.24),
        vsource: (variant: "ieee", radius: 0.45),
        decoration: (
          stroke: 0.9pt,
          scale: 1.15,
          current: (
            distance: 50%,
          ),
        ),
      ),
    )
    body
  })
}

= 线性系统的状态空间描述

经典控制理论通过传递函数描述单输入单输出（SISO）系统在零初始条件下的外部输入-输出关系，无法揭示系统内部动态特性；状态空间法引入内部*状态变量*，可统一描述多输入多输出（MIMO）、非零初态、时变及离散系统。

== 核心概念

/ 状态: 表征系统运动状况并能确定未来行为的最小信息集合。

/ 状态变量: 足以完全表征系统运动状态的*最少个数*的一组变量 $x_1(t), x_2(t), ..., x_n(t)$。给定初值 $x(t_0)$ 及 $t >= t_0$ 的输入 $u(t)$，即可唯一确定系统在 $t >= t_0$ 的全部动态行为。

/ 状态向量: 由状态变量构成的 $n$ 维列向量 $x(t) = mat(x_1(t), x_2(t), ..., x_n(t))^T$。

/ 状态空间与状态轨迹: 以状态变量为坐标轴构成的 $n$ 维线性空间称为*状态空间*；状态向量随时间在状态空间中描绘出的曲线称为*状态轨迹*。

#note-me.note[
  - 状态变量相互独立，其选取*不唯一*，但个数等于系统阶次（电路/物理系统中不少于独立储能元件的个数）。
  - 状态变量不必是可直接测量的物理输出量，但工程上常优先选取易测量的量以利于实现状态反馈。
]

== 列写状态空间表达式的一般步骤

给定物理系统（如电路或机械网络）列写状态空间表达式：

+ *确定变量*：明确输入向量 $u(t)$、输出向量 $y(t)$，选取独立状态变量 $x_1, ..., x_n$（电路系统通常选电容电压 $u_c$ 和电感电流 $i_L$）。
+ *列写状态方程*：根据物理定律（如 KCL/KVL、牛顿定律）列出各状态变量的一阶导数方程，消去中间非状态变量，整理为
  $
    dot(x)(t) = A x(t) + B u(t)
  $
+ *列写输出方程*：用状态变量 $x(t)$ 与输入 $u(t)$ 表示输出 $y(t)$，整理为代数方程
  $
    y(t) = C x(t) + D u(t)
  $

== 基础典型例题

=== 例 1（并联支路 RLC 电路）

某电路由电压源 $u(t)$ 经串联电感 $L$ 向并联电容 $C$ 与电阻 $R$ 供电（$L = 0.5" H"$，$R = 0.33" "Omega$，$C = 1" F"$），输出 $y(t)$ 为电阻支路电流 $i(t)$。已知其二阶输入-输出微分方程为
$
  y''(t) + frac(1, R C) y'(t) + frac(1, C L) y(t) = frac(1, R C L) u(t)
$
试建立该电路的状态空间表达式。

#figure(
  caption: [例 1 并联支路 RLC 电路图],
  circuit-diagram({
    import zap: *
    import zap.cetz.draw: content

    // 电压源 u(t)
    vsource("u", (0, 0), (0, 3.4), label: $u(t)$)

    // 上支路：电感电流 i_L(t) 与串联电感 L
    inductor("l", (0, 3.4), (4.4, 3.4), position: 69%, label: $L$, i: (
      content: $i_L (t)$,
      anchor: "north-west",
      distance: 42%,
      invert: true,
    ))

    // 并联电容 C 与电容电压 u_c(t)
    capacitor("c", (4.4, 3.4), (4.4, 0), n: "*-*", label: (
      content: $C$,
      anchor: "south",
    ))
    content((5.55, 2.75), $+$)
    content((5.55, 1.7), $u_c (t)$)
    content((5.55, 0.65), $-$)

    // 并联电阻 R 与输出电流 i(t)
    wire((4.4, 3.4), (7.8, 3.4))
    resistor("r", (7.8, 3.4), (7.8, 0), label: $R$, i: (
      content: $i(t)$,
      anchor: "north-west",
      distance: 45%,
      label-distance: 0.58,
      invert: true,
    ))

    // 底部公共回路
    wire((0, 0), (7.8, 0))
  }),
)

解：

+ *选取状态变量*：取两个独立储能元件对应的电感电流 $x_1 = i_L(t)$ 与电容电压 $x_2 = u_c(t)$。
+ *列写一阶微分方程并化为矩阵形式*：由基尔霍夫定律（KVL、KCL）得
  $
        & cases(
            L frac(dif i_L(t), dif t) = -u_c(t) + u(t),
            C frac(dif u_c(t), dif t) = i_L(t) - frac(1, R) u_c(t),
          ) \
    ==> & frac(dif, dif t) vec(i_L(t), u_c(t))
          = mat(0, -1 / L; 1 / C, -1 / (R C)) vec(i_L(t), u_c(t))
          + vec(1 / L, 0) u(t)
  $
+ *写出输出方程*：输出为电阻电流 $y(t) = i(t) = frac(1, R) u_c(t)$，故
  $
    y(t) = mat(0, 1 / R) vec(i_L(t), u_c(t))
  $

=== 例 2（串联 RLC 网络）

设有串联 $R$-$L$-$C$ 网络，输入电压 $u(t)$ 加在 $R, L, C$ 两端，输出为电容电压 $y(t) = u_c(t)$，回路电流为 $i(t)$。试求其传递函数与状态空间表达式。

#figure(
  caption: [例 2 串联 RLC 网络电路图],
  circuit-diagram({
    import zap: *
    import zap.cetz.draw: content

    // 左端输入端口 u(t)
    node("in+", (0, 3.4), fill: false)
    node("in-", (0, 0), fill: false)
    content((0, 2.75), $+$)
    content((0, 1.7), $u(t)$)
    content((0, 0.65), $-$)

    // 上支路：回路电流 i(t)、串联电阻 R、电感 L
    resistor("r", (0, 3.4), (4.3, 3.4), position: 70%, label: $R$, i: (
      content: $i(t)$,
      anchor: "north-west",
      distance: 42%,
      invert: true,
    ))
    inductor("l", (4.3, 3.4), (6.9, 3.4), label: $L$)

    // 并联输出电容 C
    capacitor("c", (6.9, 3.4), (6.9, 0), n: "*-*", label: (
      content: $C$,
      anchor: "south",
    ))

    // 右端输出端口 u_c(t)
    wire((6.9, 3.4), (8.7, 3.4))
    wire((0, 0), (8.7, 0))
    node("out+", (8.7, 3.4), fill: false)
    node("out-", (8.7, 0), fill: false)
    content((8.7, 2.75), $+$)
    content((8.7, 1.7), $u_c (t)$)
    content((8.7, 0.65), $-$)
  }),
)

解：由回路方程与电容特性列写微分方程组：
$
  cases(
    C frac(dif u_c, dif t) = i,
    L frac(dif i, dif t) + i R + u_c = u,
  )
$ <例2原始方程>

- *传递函数描述*：消去中间变量 $i$ 得 $L C frac(dif^2 u_c, dif t^2) + R C frac(dif u_c, dif t) + u_c = u$，零初态下取拉氏变换得
  $
    frac(U_c(s), U(s)) = frac(1, L C s^2 + R C s + 1)
  $
  传递函数仅反映外部输入-输出关系，无法体现内部电流 $i(t)$ 的动态。
- *状态空间描述*：选取状态变量 $x = vec(u_c, i)$，改写@例2原始方程 得
  $
    cases(
      dot(u)_c = frac(1, C) i,
      dot(i) = -frac(1, L) u_c - frac(R, L) i + frac(1, L) u,
    )
    ==>
    cases(
      vec(dot(u)_c, dot(i)) = mat(0, 1 / C; -1 / L, -R / L) vec(u_c, i) + vec(0, 1 / L) u,
      y(t) = u_c(t) = mat(1, 0) vec(u_c, i),
    )
  $

== 一般表达式与常见模型变式

对 $n$ 个状态变量、$r$ 个输入、$m$ 个输出的 MIMO 线性定常系统，状态空间表达式为：

$
  cases(
    dot(x)(t) = A x(t) + B u(t),
    y(t) = C x(t) + D u(t),
  )
$ <一般状态空间>

#figure(
  caption: [MIMO 线性定常系统矩阵与向量维数汇总],
  table(
    columns: (auto, auto, auto, 220pt),
    [符号], [名称], [维数], [物理意义（SISO 时特例）],
    [$x(t)$], [状态向量], [$n times 1$], [系统内部独立状态变量集合],
    [$u(t)$], [输入向量], [$r times 1$], [外部控制作用（SISO 时为标量 $u$）],
    [$y(t)$], [输出向量], [$m times 1$], [外部可测输出（SISO 时为标量 $y$）],
    [$A$], [系统矩阵], [$n times n$], [表征各状态变量间的内部联系],
    [$B$], [控制（输入）矩阵], [$n times r$], [表征输入对各状态的作用（SISO 时为列向量 $b in RR^n$）],

    [$C$], [输出矩阵], [$m times n$], [表征输出与各状态变量的关系（SISO 时为行向量 $c in RR^(1 times n)$）],

    [$D$], [前馈（直接传递）矩阵], [$m times r$], [表征输入对输出的直接传递，通常 $D = 0$（SISO 时为标量 $d$）],
  ),
)

#figure(
  caption: [几类常见的线性系统状态空间模型变式],
  table(
    columns: (auto, auto, auto),
    [系统类型], [状态方程], [输出方程],
    [线性时变系统], [$dot(x)(t) = A(t) x(t) + B(t) u(t)$], [$y(t) = C(t) x(t) + D(t) u(t)$],

    [离散时间系统], [$x(k + 1) = A x(k) + B u(k)$], [$y(k) = C x(k) + D u(k)$],
    [含确定性扰动 $f(t)$], [$dot(x)(t) = A x(t) + B u(t) + B_f f(t)$], [$y(t) = C x(t) + D u(t)$],

    [含随机干扰 $w(t), v(t)$], [$dot(x)(t) = A x(t) + B u(t) + w(t)$], [$y(t) = C x(t) + D u(t) + v(t)$],

    [广义系统], [$E dot(x)(t) = A x(t) + B u(t)$], [$y(t) = C x(t) + D u(t)$],
  ),
)

== 状态结构图

状态结构图仅由*积分器*、*比例器*和*加法器*三类基本环节组成。绘制步骤如下：

+ *画出所有积分器*：积分器个数等于状态变量个数 $n$，每个积分器的输出对应一个状态变量 $x_i$，输入为 $dot(x)_i$；
+ *画出加法器与比例器*：根据状态方程与输出方程中的系数与求和关系放置比例增益与求和点；
+ *按信号流向连线*：用有向箭头将各元件连接起来。

#figure(
  caption: [一般线性系统的状态结构图（$dot(X) = A X + B u, quad Y = C X + D u$）],
  diagram(
    node-stroke: 1pt,
    spacing: (22pt, 18pt),
    node((0, 0), $u(t)$, stroke: none),
    edge("-|>"),
    node((1, 0), $B$),
    edge("-|>"),
    node((2, 0), $+$, radius: 9pt),
    edge("-|>", $dot(X)$),
    node((3, 0), $integral$),
    edge("rr", "-|>", $X$, label-pos: 0.35),
    node((5, 0), $C$),
    edge("-|>"),
    node((6, 0), $+$, radius: 9pt),
    edge("-|>", $Y(t)$),
    node((7, 0), [], stroke: none),
    edge((4, 0), (4, 1), (3, 1), "-|>"),
    node((3, 1), $A$),
    edge("l,u", "-|>"),
    edge((0.4, 0), (0.4, -1), (3, -1), "-|>"),
    node((3, -1), $D$),
    edge((3, -1), (6, -1), (6, 0), "-|>"),
  ),
)

=== 例 3（一阶系统）

绘制一阶微分方程 $dot(x) = a x + b u$ 的状态结构图：

#figure(
  caption: [例 3 一阶系统状态结构图],
  diagram(
    node-stroke: 1pt,
    spacing: (22pt, 16pt),
    node((0, 0), $u$, stroke: none),
    edge("-|>"),
    node((1, 0), $b$),
    edge("-|>"),
    node((2, 0), $+$, radius: 9pt),
    edge("-|>", $dot(x)$),
    node((3, 0), $integral$),
    edge("rr", "-|>", $x$),
    node((5, 0), [], stroke: none),
    edge((4, 0), "d,l", "-|>"),
    node((3, 1), $a$),
    edge("l,u", "-|>"),
  ),
)

=== 例 4（一般二阶 SISO 系统）

画出下述二阶系统（$D = 0$）的状态结构图：
$
  cases(
    dot(x)_1 = a_(11) x_1 + a_(12) x_2 + b_1 u,
    dot(x)_2 = a_(21) x_1 + a_(22) x_2 + b_2 u,
    y = c_1 x_1 + c_2 x_2,
  )
$

#figure(
  caption: [例 4 二阶 SISO 系统状态结构图],
  diagram(
    node-stroke: 1pt,
    spacing: (22pt, 18pt),
    // 上支路 x1
    node((0, 1.5), $u$, stroke: none),
    edge((0, 1.5), (0.5, 1.5), (0.5, 0), (1, 0), "-|>"),
    edge((0, 1.5), (0.5, 1.5), (0.5, 3), (1, 3), "-|>"),
    node((1, 0), $b_1$),
    edge("-|>"),
    node((2, 0), $+$, radius: 9pt),
    edge("-|>", $dot(x)_1$),
    node((3, 0), $integral$),
    edge((3, 0), (5.5, 0), "-|>", $x_1$, label-pos: 0.28),
    node((5.5, 0), $c_1$),
    edge((5.5, 0), (6.5, 0), (6.5, 1.5), "-|>"),
    // 下支路 x2
    node((1, 3), $b_2$),
    edge("-|>"),
    node((2, 3), $+$, radius: 9pt),
    edge("-|>", $dot(x)_2$),
    node((3, 3), $integral$),
    edge((3, 3), (5.5, 3), "-|>", $x_2$, label-pos: 0.28),
    node((5.5, 3), $c_2$),
    edge((5.5, 3), (6.5, 3), (6.5, 1.5), "-|>"),
    // 输出求和
    node((6.5, 1.5), $+$, radius: 9pt),
    edge("-|>", $y$),
    node((7.5, 1.5), [], stroke: none),
    // 自反馈 a11, a22
    edge((4.2, 0), (4.2, -1), (3, -1), "-|>"),
    node((3, -1), $a_(11)$),
    edge((3, -1), (2, -1), (2, 0), "-|>"),
    edge((4.2, 3), (4.2, 4), (3, 4), "-|>"),
    node((3, 4), $a_(22)$),
    edge((3, 4), (2, 4), (2, 3), "-|>"),
    // 交叉耦合 a12 (x2 -> 上求和点), a21 (x1 -> 下求和点)
    edge((4.3, 3), (4.3, 1), (3.1, 1), "-|>"),
    node((3.1, 1), $a_(12)$),
    edge((3.1, 1), (2, 1), (2, 0), "-|>"),
    edge((4.7, 0), (4.7, 2), (3.1, 2), "-|>"),
    node((3.1, 2), $a_(21)$),
    edge((3.1, 2), (2, 2), (2, 3), "-|>"),
  ),
)

=== 例 5（三阶串联积分器结构）

画出下述状态空间表达式的结构图：
$
  cases(
    dot(x) = mat(0, 1, 0; 0, 0, 1; -6, -3, -2) x + vec(0, 0, 1) u,
    y = mat(1, 1, 0) x,
  )
  ==>
  cases(
    dot(x)_1 = x_2,
    dot(x)_2 = x_3,
    dot(x)_3 = -6 x_1 - 3 x_2 - 2 x_3 + u,
    y = x_1 + x_2,
  )
$

#figure(
  caption: [例 5 三阶系统状态结构图],
  diagram(
    node-stroke: 1pt,
    spacing: (22pt, 16pt),
    node((0, 0), $u$, stroke: none),
    edge("-|>"),
    node((1, 0), $+$, radius: 9pt),
    edge("-|>", $dot(x)_3$),
    node((2, 0), $integral$),
    edge("rr", "-|>", $x_3 = dot(x)_2$, label-pos: 0.45),
    node((4, 0), $integral$),
    edge("rr", "-|>", $x_2 = dot(x)_1$, label-pos: 0.45),
    node((6, 0), $integral$),
    edge("rr", "-|>", $x_1$, label-pos: 0.45),
    node((8, 0), $+$, radius: 9pt),
    edge("-|>", $y$),
    node((9, 0), [], stroke: none),
    // 输出分支 x2 -> +
    edge((5, 0), (5, -1), (8, -1), (8, 0), "-|>"),
    // 反馈 -2, -3, -6
    edge((3, 0), (3, 1), (2, 1), "-|>"),
    node((2, 1), $-2$),
    edge((2, 1), (1, 1), (1, 0), "-|>"),
    edge((5, 0), (5, 2), (3, 2), "-|>"),
    node((3, 2), $-3$),
    edge((3, 2), (1, 2), (1, 0), "-|>"),
    edge((7, 0), (7, 3), (4, 3), "-|>"),
    node((4, 3), $-6$),
    edge((4, 3), (0.8, 3), (0.8, 0), "-|>"),
  ),
)

=== 练习（二阶 SISO 系统）

画出二阶 SISO 系统
$
  vec(dot(x)_1, dot(x)_2) = mat(2, -1; 1, 3) vec(x_1, x_2) + vec(1, 2) u(t),
  quad y(t) = mat(2, 4) vec(x_1, x_2)
$
的状态结构图。

解：展开为标量方程 $dot(x)_1 = 2 x_1 - x_2 + u$，$dot(x)_2 = x_1 + 3 x_2 + 2 u$，$y = 2 x_1 + 4 x_2$（结构同例 4，只需将参数替换为 $a_(11) = 2, a_(12) = -1, a_(21) = 1, a_(22) = 3, b_1 = 1, b_2 = 2, c_1 = 2, c_2 = 4$）。

#figure(
  caption: [练习二阶系统状态结构图],
  diagram(
    node-stroke: 1pt,
    spacing: (22pt, 18pt),
    // 上支路 x1
    node((0, 1.5), $u$, stroke: none),
    edge((0, 1.5), (0.5, 1.5), (0.5, 0), (2, 0), "-|>"),
    edge((0, 1.5), (0.5, 1.5), (0.5, 3), (1, 3), "-|>"),
    node((2, 0), $+$, radius: 9pt),
    edge("-|>", $dot(x)_1$),
    node((3, 0), $integral$),
    edge((3, 0), (5.5, 0), "-|>", $x_1$, label-pos: 0.28),
    node((5.5, 0), $2$),
    edge((5.5, 0), (6.5, 0), (6.5, 1.5), "-|>"),
    // 下支路 x2
    node((1, 3), $2$),
    edge("-|>"),
    node((2, 3), $+$, radius: 9pt),
    edge("-|>", $dot(x)_2$),
    node((3, 3), $integral$),
    edge((3, 3), (5.5, 3), "-|>", $x_2$, label-pos: 0.28),
    node((5.5, 3), $4$),
    edge((5.5, 3), (6.5, 3), (6.5, 1.5), "-|>"),
    // 输出求和
    node((6.5, 1.5), $+$, radius: 9pt),
    edge("-|>", $y$),
    node((7.5, 1.5), [], stroke: none),
    // 自反馈 2, 3
    edge((4.2, 0), (4.2, -1), (3, -1), "-|>"),
    node((3, -1), $2$),
    edge((3, -1), (2, -1), (2, 0), "-|>"),
    edge((4.2, 3), (4.2, 4), (3, 4), "-|>"),
    node((3, 4), $3$),
    edge((3, 4), (2, 4), (2, 3), "-|>"),
    // 交叉耦合 -1 (x2 -> 上求和点), 1 (x1 -> 下求和点)
    edge((4.3, 3), (4.3, 1), (3.1, 1), "-|>"),
    node((3.1, 1), $-1$),
    edge((3.1, 1), (2, 1), (2, 0), "-|>"),
    edge((4.7, 0), (4.7, 2), (3.1, 2), "-|>"),
    node((3.1, 2), $1$),
    edge((3.1, 2), (2, 2), (2, 3), "-|>"),
  ),
)

#pagebreak()
= 线性系统的状态转移方程

建立状态空间表达式后，需求解给定初态 $x(t_0)$ 与输入 $u(t)$ 下系统状态随时间演化的规律，即*状态转移方程*。

== 求解一般步骤

对于线性定常系统 $dot(x)(t) = A x(t) + B u(t)$，已知初始状态 $x(t_0)$（常取 $t_0 = 0$）：

+ *求状态转移矩阵 $Phi(t) = upright(e)^(A t)$*：
  - 幂级数定义法：$Phi(t) = I + A t + frac(1, 2!) A^2 t^2 + dots.c + frac(1, k!) A^k t^k + dots.c$（当 $A$ 为对角或幂零阵时可直接截断）；
  - 拉氏反变换法：由 $(s I - A)^(-1)$ 逐项求拉氏反变换得 $Phi(t) = cal(L)^(-1)[(s I - A)^(-1)]$。
+ *求自由解（零输入响应）*：当 $u(t) equiv 0$ 时，齐次方程 $dot(x) = A x$ 的解为
  $
    x_"zi"(t) = Phi(t - t_0) x(t_0) = upright(e)^(A (t - t_0)) x(t_0), quad t >= t_0
  $
  当 $t_0 = 0$ 时，$x_"zi"(t) = Phi(t) x(0) = upright(e)^(A t) x_0$。
+ *求全解（状态转移方程）*：叠加零输入响应与零状态响应
  $
    x(t) & = upright(e)^(A (t - t_0)) x(t_0) + integral_(t_0)^t upright(e)^(A (t - tau)) B u(tau) dif tau \
         & = Phi(t - t_0) x(t_0) + integral_(t_0)^t Phi(t - tau) B u(tau) dif tau
  $ <状态转移方程>
  当 $t_0 = 0$ 时，$x(t) = Phi(t) x(0) + integral_0^t Phi(t - tau) B u(tau) dif tau$。

== 基础典型例题

已知线性定常系统
$
  dot(x)(t) = mat(0, 1; -2, -3) x(t) + vec(0, 1) u(t), quad x(0) = vec(1, 0)
$
求系统在单位阶跃输入 $u(t) = 1(t)$（$t >= 0$）下的状态转移矩阵 $Phi(t)$ 与状态响应 $x(t)$。

解：

+ *求状态转移矩阵 $Phi(t)$*：构造 $s I - A = mat(s, -1; 2, s + 3)$，其行列式为 $(s + 1)(s + 2)$，故
  $
    (s I - A)^(-1) = frac(1, (s + 1)(s + 2)) mat(s + 3, 1; -2, s)
    = mat(
      frac(2, s + 1) - frac(1, s + 2), frac(1, s + 1) - frac(1, s + 2);
      frac(-2, s + 1) + frac(2, s + 2), frac(-1, s + 1) + frac(2, s + 2)
    )
  $
  逐项取拉氏反变换得
  $
    Phi(t) = cal(L)^(-1)[(s I - A)^(-1)] = mat(
      2 upright(e)^(-t) - upright(e)^(-2 t), upright(e)^(-t) - upright(e)^(-2 t);
      -2 upright(e)^(-t) + 2 upright(e)^(-2 t), -upright(e)^(-t) + 2 upright(e)^(-2 t)
    )
  $
+ *求零输入响应*：
  $
    x_"zi"(t) = Phi(t) x(0) = vec(2 upright(e)^(-t) - upright(e)^(-2 t), -2 upright(e)^(-t) + 2 upright(e)^(-2 t))
  $
+ *求零状态响应与全解*：令积分变量代换 $v = t - tau$，因 $u(tau) = 1$ 有
  $
    x_"zs"(t) & = integral_0^t Phi(t - tau) vec(0, 1) dif tau
                = integral_0^t vec(upright(e)^(-v) - upright(e)^(-2 v), -upright(e)^(-v) + 2 upright(e)^(-2 v)) dif v \
              & = vec(
                  1 / 2 - upright(e)^(-t) + 1 / 2 upright(e)^(-2 t),
                  upright(e)^(-t) - upright(e)^(-2 t)
                )
  $
  两项叠加即得系统全响应：
  $
    x(t) = x_"zi"(t) + x_"zs"(t)
    = vec(1 / 2 + upright(e)^(-t) - 1 / 2 upright(e)^(-2 t), -upright(e)^(-t) + upright(e)^(-2 t))
  $

== 核心概念、性质与推导原理

=== 状态转移矩阵及其基本性质

矩阵指数函数 $Phi(t - t_0) := upright(e)^(A(t - t_0))$ 是一个 $n times n$ 时变函数矩阵，它将 $t_0$ 时刻的状态向量转移到 $t$ 时刻，因此称为*状态转移矩阵*。

#figure(
  caption: [状态转移矩阵的基本性质（对应指数幂性质）],
  table(
    columns: (auto, auto, auto),
    [性质名称], [状态转移矩阵形式], [矩阵指数形式],
    [初值特性], [$Phi(0) = I$], [$upright(e)^0 = I$],
    [分解特性],
    [$Phi(t_1 plus.minus t_2) = Phi(t_1) Phi(plus.minus t_2)$],
    [$upright(e)^(A(t_1 plus.minus t_2)) = upright(e)^(A t_1) upright(e)^(plus.minus A t_2)$],

    [传递特性],
    [$Phi(t_2 - t_1) Phi(t_1 - t_0) = Phi(t_2 - t_0)$],
    [$upright(e)^(A(t_2 - t_1)) upright(e)^(A(t_1 - t_0)) = upright(e)^(A(t_2 - t_0))$],

    [可逆性],
    [$Phi^(-1)(t - t_0) = Phi(t_0 - t), quad Phi^(-1)(t) = Phi(-t)$],
    [$(upright(e)^(A(t - t_0)))^(-1) = upright(e)^(-A(t - t_0)) = upright(e)^(A(t_0 - t))$],

    [可微性],
    [$frac(dif Phi(t), dif t) = A Phi(t) = Phi(t) A$],
    [$frac(dif upright(e)^(A t), dif t) = A upright(e)^(A t) = upright(e)^(A t) A$],
  ),
)

=== 非齐次状态方程解的推导原理（积分因子法）

在非齐次状态方程 $dot(x)(t) - A x(t) = B u(t)$ 两边左乘积分因子 $upright(e)^(-A t)$，利用乘积求导法则得：
$
  upright(e)^(-A t)[dot(x)(t) - A x(t)] = frac(dif, dif t)[upright(e)^(-A t) x(t)] = upright(e)^(-A t) B u(t)
$
对等式两边从 $t_0$ 到 $t$ 积分：
$
  lr([upright(e)^(-A tau) x(tau)] |)_(t_0)^t = upright(e)^(-A t) x(t) - upright(e)^(-A t_0) x(t_0) = integral_(t_0)^t upright(e)^(-A tau) B u(tau) dif tau
$
两边左乘 $upright(e)^(A t)$ 并整理，即得@状态转移方程。解由*零输入响应*（初态引起的自由运动）与*零状态响应*（控制激励引起的强制运动）两部分组成。

#pagebreak()
= 状态空间描述与传递矩阵之间的转换

线性定常系统的三种数学模型——*传递函数（阵）*、*输入-输出微分方程*与*状态空间表达式*——可相互转换。

== 由状态空间表达式求传递函数（阵）

=== 求解一般步骤

给定状态空间表达式 $(A, B, C, D)$：

+ 构造特征矩阵 $s I - A$；
+ 计算特征多项式 $det(s I - A)$ 与伴随矩阵 $"adj"(s I - A)$，求出预解矩阵 $(s I - A)^(-1) = frac("adj"(s I - A), det(s I - A))$；
+ 代入传递函数阵公式并化简：
  $
    G_(y u)(s) = C (s I - A)^(-1) B + D = C frac("adj"(s I - A), det(s I - A)) B + D
  $ <传递矩阵公式>
  SISO 系统时，$B = b$、$D = d$，@传递矩阵公式 退化为标量传递函数 $g_(y u)(s) = C (s I - A)^(-1) b + d$。

=== 典型例题

==== 例 6（二阶 SISO 系统）

已知系统状态空间表达式
$
  dot(x)(t) = mat(0, 1; -6, -5) x(t) + vec(0, 1) u(t), quad y(t) = mat(1, 1) x(t)
$
求系统传递函数 $g(s)$。

解：
$
  g(s) & = C(s I - A)^(-1) b
         = mat(1, 1) mat(s, -1; 6, s + 5)^(-1) vec(0, 1) \
       & = mat(1, 1) frac(mat(s + 5, 1; -6, s), s^2 + 5 s + 6) vec(0, 1)
         = frac(s + 1, s^2 + 5 s + 6)
$

==== 例 7（三阶 SISO 系统）

已知系统状态空间表达式
$
  dot(x)(t) = mat(1, 1, 0; 0, 2, 3; -1, 0, 1) x(t) + vec(1, 0, 1) u(t), quad y(t) = mat(1, 2, 1) x(t)
$
求系统传递函数 $g(s)$。

解：构造 $s I - A = mat(s - 1, -1, 0; 0, s - 2, -3; 1, 0, s - 1)$，求得 $det(s I - A) = (s - 1)^2 (s - 2) + 3 = s^3 - 4 s^2 + 5 s + 1$，则
$
  g(s) & = mat(1, 2, 1) frac("adj"(s I - A), det(s I - A)) vec(1, 0, 1) \
       & = mat(1, 2, 1) frac(
           mat(
             (s - 1)(s - 2), s - 1, 3;
             -3, (s - 1)^2, 3(s - 1);
             -(s - 2), -1, (s - 1)(s - 2)
           ),
           s^3 - 4 s^2 + 5 s + 1
         ) vec(1, 0, 1) \
       & = mat(1, 2, 1) frac(vec(s^2 - 3 s + 5, 3 s - 6, s^2 - 4 s + 4), s^3 - 4 s^2 + 5 s + 1)
         = frac(2 s^2 - s - 3, s^3 - 4 s^2 + 5 s + 1)
$

==== 例 8（MIMO 系统求传递函数阵）

求下述双输入双输出系统的传递函数矩阵 $G_(y u)(s)$：
$
  dot(x)(t) = mat(0, 1, 0; 0, -4, 3; -1, -1, -2) x(t) + mat(0, 0; 1, 0; 0, 1) u(t),
  quad y(t) = mat(1, 0, 0; 0, 0, 1) x(t)
$

解：构造 $s I - A = mat(s, -1, 0; 0, s + 4, -3; 1, 1, s + 2)$，计算得 $det(s I - A) = s^3 + 6 s^2 + 11 s + 3$ 及
$
  "adj"(s I - A) = mat(
    s^2 + 6 s + 11, s + 2, 3;
    -3, s^2 + 2 s, 3 s;
    -s - 4, -s - 1, s^2 + 4 s
  )
$
代入公式得
$
  G_(y u)(s) & = C (s I - A)^(-1) B \
             & = frac(1, s^3 + 6 s^2 + 11 s + 3) mat(1, 0, 0; 0, 0, 1) mat(
                 s^2 + 6 s + 11, s + 2, 3;
                 -3, s^2 + 2 s, 3 s;
                 -s - 4, -s - 1, s^2 + 4 s
               ) mat(0, 0; 1, 0; 0, 1) \
             & = frac(1, s^3 + 6 s^2 + 11 s + 3) mat(s + 2, 3; -(s + 1), s(s + 4))
$
其中 $G_(y u)(s)$ 的 $(i, j)$ 元素 $g_(i j)(s)$ 表示仅第 $j$ 个输入作用时，第 $i$ 个输出 $Y_i(s)$ 对第 $j$ 个输入 $U_j(s)$ 的传递函数。

=== 推导原理与传递函数阵的不变性

- *公式推导*：在零初始状态 $x(0) = 0$ 下对@一般状态空间 取拉氏变换，得 $(s I - A) X(s) = B U(s)$ 与 $Y(s) = C X(s) + D U(s)$，消去 $X(s)$ 即得 $Y(s) = [C(s I - A)^(-1) B + D] U(s)$。

/ 定理 1(传递函数阵的等价不变性): 引入非奇异线性变换 $z(t) = P x(t)$（$P$ 可逆），变换后的系统状态空间表达式为
$
  cases(
    dot(z)(t) = overline(A) z(t) + overline(B) u(t) = P A P^(-1) z(t) + P B u(t),
    y(t) = overline(C) z(t) + overline(D) u(t) = C P^(-1) z(t) + D u(t),
  )
$
其传递函数矩阵保持不变：
$
  overline(G)(s) & = overline(C)(s I - overline(A))^(-1) overline(B) + overline(D) \
                 & = C P^(-1) (s I - P A P^(-1))^(-1) P B + D \
                 & = C (s I - A)^(-1) B + D = G(s)
$

== 系统的实现问题

由输入-输出微分方程或传递函数反求状态空间表达式的问题称为*实现问题*。同一传递函数的实现*不唯一*（但系统矩阵 $A$ 的特征根相同）；当传递函数分子分母无公因子（即无零极点对消）时，所得 $n$ 维实现称为*最小实现*。

考虑一般 SISO 线性定常系统的微分方程与传递函数（$m <= n$）：
$
  & y^((n)) + a_(n-1) y^((n-1)) + dots.c + a_1 dot(y) + a_0 y \
  & = b_m u^((m)) + b_(m-1) u^((m-1)) + dots.c + b_1 dot(u) + b_0 u
$ <一般高阶微分方程>
$
  G(s) = frac(Y(s), U(s)) = frac(b_m s^m + b_(m-1) s^(m-1) + dots.c + b_1 s + b_0, s^n + a_(n-1) s^(n-1) + dots.c + a_1 s + a_0)
$

=== 情形一：不含输入导数项（无零点，$m = 0$）

方程形式为 $y^((n)) + a_(n-1) y^((n-1)) + dots.c + a_1 dot(y) + a_0 y = b_0 u$。

==== 求解一般步骤（两种标准形模板）

+ *可控标准形实现*：取 $x_1 = y, quad x_2 = dot(y), quad ..., quad x_n = y^((n-1))$，直接写出
  $
    dot(x) = mat(
      0, 1, 0, dots.c, 0;
      0, 0, 1, dots.down, dots.v;
      dots.v, dots.down, dots.down, dots.down, 0;
      0, dots.c, 0, 0, 1;
      -a_0, -a_1, -a_2, dots.c, -a_(n-1)
    ) x + vec(0, 0, dots.v, 0, b_0) u,
    quad y = mat(1, 0, dots.c, 0) x
  $
+ *可观标准形实现*：取 $x_n = y, quad x_(n-1) = dot(y) + a_(n-1) y, quad ...$，直接写出
  $
    dot(x) = mat(
      0, 0, dots.c, 0, -a_0;
      1, 0, dots.c, 0, -a_1;
      0, dots.down, dots.down, dots.v, dots.v;
      dots.v, dots.down, dots.down, 0, -a_(n-2);
      0, dots.c, 0, 1, -a_(n-1)
    ) x + vec(b_0, 0, dots.v, 0) u,
    quad y = mat(0, dots.c, 0, 1) x
  $

==== 基础例题（例 9）

已知系统的输入-输出微分方程为 $dot.triple(y) + 6 diaer(y) + 11 dot(y) + 6 y = 6 u$，求其可控标准形与可观标准形状态空间表达式。

解：对照标准形式得 $a_2 = 6, a_1 = 11, a_0 = 6, b_0 = 6$。

- *可控标准形*：
  $
    A = mat(0, 1, 0; 0, 0, 1; -6, -11, -6), quad b = vec(0, 0, 6), quad c = mat(1, 0, 0), quad d = 0
  $
- *可观标准形*：
  $
    A = mat(0, 0, -6; 1, 0, -11; 0, 1, -6), quad b = vec(6, 0, 0), quad c = mat(0, 0, 1), quad d = 0
  $

==== 推导原理与三阶可控标准形结构图

- *可控标准形推导*：令 $x_1 = y, x_2 = dot(y), ..., x_n = y^((n-1))$，则 $dot(x)_1 = x_2, ..., dot(x)_(n-1) = x_n$，且 $dot(x)_n = y^((n)) = -a_0 x_1 - a_1 x_2 - dots.c - a_(n-1) x_n + b_0 u$。三阶系统 $dot.triple(y) + a_2 diaer(y) + a_1 dot(y) + a_0 y = b_0 u$ 的结构图如下：

#figure(
  caption: [三阶无零点系统的可控标准形状态结构图],
  diagram(
    node-stroke: 1pt,
    spacing: (22pt, 16pt),
    node((0, 0), $u$, stroke: none),
    edge("-|>"),
    node((1, 0), $b_0$),
    edge("-|>"),
    node((2, 0), $+$, radius: 9pt),
    edge("-|>", $dot(x)_3$),
    node((3, 0), $integral$),
    edge("rr", "-|>", $x_3$, label-pos: 0.45),
    node((5, 0), $integral$),
    edge("rr", "-|>", $x_2$, label-pos: 0.45),
    node((7, 0), $integral$),
    edge("rr", "-|>", $x_1 = y$, label-pos: 0.5),
    node((9, 0), [], stroke: none),
    edge((4, 0), (4, 1), (3, 1), "-|>"),
    node((3, 1), $-a_2$),
    edge((3, 1), (2, 1), (2, 0), "-|>"),
    edge((6, 0), (6, 2), (4, 2), "-|>"),
    node((4, 2), $-a_1$),
    edge((4, 2), (2, 2), (2, 0), "-|>"),
    edge((8, 0), (8, 3), (5, 3), "-|>"),
    node((5, 3), $-a_0$),
    edge((5, 3), (1.8, 3), (1.8, 0), "-|>"),
  ),
)

- *可观标准形推导*：选取状态变量
  $
        & cases(
            x_1 = y^((n-1)) + a_(n-1) y^((n-2)) + dots.c + a_1 y,
            x_2 = y^((n-2)) + a_(n-1) y^((n-3)) + dots.c + a_2 y,
            dots.v,
            x_(n-1) = dot(y) + a_(n-1) y,
            x_n = y,
          ) \
    ==> & cases(
            dot(x)_1 = y^((n)) + a_(n-1) y^((n-1)) + dots.c + a_1 dot(y) = b_0 u - a_0 x_n,
            dot(x)_2 = x_1 - a_1 x_n,
            dots.v,
            dot(x)_n = x_(n-1) - a_(n-1) x_n,
          )
  $

=== 情形二：含输入导数项（含零点，$m >= 1$）

若微分方程右端含有 $u$ 的导数项，直接取 $x_1 = y, x_2 = dot(y), ...$ 会导致方程右端出现 $dot(u), diaer(u), ...$，造成物理实现困难且解不唯一，需采用下述两种消去 $u$ 导数项的方法。

==== 两种实现方法求解步骤汇总

#figure(
  caption: [含输入导数项微分方程（@一般高阶微分方程）的两种实现方法对比],
  table(
    columns: (auto, 1fr, 1fr),
    [矩阵 / 参数], [方法一：中间变量法（可控标准形）], [方法二：待定系数 $beta_i$ 法],

    [$A$ 矩阵],
    [$mat(0, 1, dots.c, 0; dots.v, dots.down, dots.down, dots.v; 0, dots.c, 0, 1; -a_0, -a_1, dots.c, -a_(n-1))$],
    [$mat(0, 1, dots.c, 0; dots.v, dots.down, dots.down, dots.v; 0, dots.c, 0, 1; -a_0, -a_1, dots.c, -a_(n-1))$],

    [$b$ 向量], [$vec(0, dots.v, 0, 1)$], [$vec(beta_1, beta_2, dots.v, beta_n)$],

    [$c$ 向量],

    $cases(
      m < n: mat(b_0, dots.c, b_m, underbrace(0 dots.c 0, n - m - 1)),
      m = n: mat(b_0 - b_n a_0, dots.c, b_(n-1) - b_n a_(n-1))
    )$,
    [$mat(1, 0, dots.c, 0)$],

    [$d$ 标量],
    $cases(
      m < n: d = 0,
      m = n: d = b_n
    )$,
    [$d = beta_0 = b_n$（若 $m < n$ 则 $b_n = 0$）],
  ),
)

*方法二递推计算公式*（将右端补齐到 $n$ 阶，缺项 $b_k = 0$）：
$
  cases(
    beta_0 = b_n,
    beta_1 = b_(n-1) - a_(n-1) beta_0,
    beta_2 = b_(n-2) - a_(n-1) beta_1 - a_(n-2) beta_0,
    dots.v,
    beta_n = b_0 - a_(n-1) beta_(n-1) - a_(n-2) beta_(n-2) - dots.c - a_1 beta_1 - a_0 beta_0,
  )
$ <beta递推>

==== 基础例题（例 10）

已知 SISO 线性定常连续系统的微分方程为
$
  dot.triple(y) + 2 diaer(y) + 5 dot(y) + y = diaer(u) + dot(u) + 3 u
$
求其状态空间表达式。

解：（采用*方法二*）

+ *读取系数*（$n = 3$，将右端补齐至 3 阶）：
  $
    a_2 = 2, quad a_1 = 5, quad a_0 = 1; \
    b_3 = 0, quad b_2 = 1, quad b_1 = 1, quad b_0 = 3
  $
+ *按@beta递推 依次计算待定系数 $beta_0, beta_1, beta_2, beta_3$*：
  $
    cases(
      beta_0 = b_3 = 0,
      beta_1 = b_2 - a_2 beta_0 = 1 - 2 times 0 = 1,
      beta_2 = b_1 - a_2 beta_1 - a_1 beta_0 = 1 - 2 times 1 - 5 times 0 = -1,
      beta_3 = b_0 - a_2 beta_2 - a_1 beta_1 - a_0 beta_0 = 3 - 2 times (-1) - 5 times 1 - 1 times 0 = 0,
    )
  $
+ *写出状态空间表达式*：
  $
    dot(x) = mat(0, 1, 0; 0, 0, 1; -1, -5, -2) vec(x_1, x_2, x_3) + vec(1, -1, 0) u,
    quad y = x_1 = mat(1, 0, 0) x
  $

#note-me.note[
  若对本例使用*方法一*（$m = 2 < n = 3$），则得 $A = mat(0, 1, 0; 0, 0, 1; -1, -5, -2)$，$b = vec(0, 0, 1)$，$c = mat(3, 1, 1)$，$d = 0$。两种实现均对应同一传递函数 $G(s) = frac(s^2 + s + 3, s^3 + 2 s^2 + 5 s + 1)$。
]

==== 推导原理

- *方法一原理*：构造满足无零点方程的中间变量 $x_1$：
  $
    x_1^((n)) + a_(n-1) x_1^((n-1)) + dots.c + a_1 dot(x)_1 + a_0 x_1 = u
  $ <中间变量方程>
  再令 $x_2 = dot(x)_1, dots.c, x_n = dot(x)_(n-1) = x_1^((n-1))$，即得 $dot(x)_n = -a_0 x_1 - dots.c - a_(n-1) x_n + u$。将@中间变量方程 连续求导 $k$ 次（$k = 1, ..., m$）并利用 $x_(k+1) = x_1^((k))$，得到
  $
    x_(k+1)^((n)) + a_(n-1) x_(k+1)^((n-1)) + dots.c + a_1 dot(x)_(k+1) + a_0 x_(k+1) = u^((k))
  $
  代入原微分方程@一般高阶微分方程：
  $
    & y^((n)) + a_(n-1) y^((n-1)) + dots.c + a_0 y \
    & = sum_(k = 0)^m b_k (x_(k+1)^((n)) + a_(n-1) x_(k+1)^((n-1)) + dots.c + a_0 x_(k+1))
  $
  - 当 $m < n$ 时，直接对比同阶导数即得 $y = b_0 x_1 + b_1 x_2 + dots.c + b_m x_(m+1)$；
  - 当 $m = n$ 时，$x_(n+1) := dot(x)_n = -a_0 x_1 - dots.c - a_(n-1) x_n + u$，代入上式并合并同类项即得 $y = sum_(k=0)^(n-1) (b_k - b_n a_k) x_(k+1) + b_n u$。

- *方法二原理*：构造包含待定常数的状态变量以逐级吸收 $u$ 的导数项：
  $
    cases(
      x_1 = y - beta_0 u,
      x_2 = dot(x)_1 - beta_1 u = dot(y) - beta_0 dot(u) - beta_1 u,
      dots.v,
      x_n = dot(x)_(n-1) - beta_(n-1) u = y^((n-1)) - beta_0 u^((n-1)) - dots.c - beta_(n-1) u,
    )
  $
  将各 $y^((k))$ 用 $x_(k+1)$ 及 $u$ 的各阶导数表示，分别乘以 $a_k$ 后与 $y^((n)) = dot(x)_n + sum_(j=0)^(n-1) beta_j u^((n-j))$ 相加，令结果等于原方程右端 $sum_(k=0)^n b_k u^((k))$：
  $
    & {dot(x)_n + a_(n-1) x_n + dots.c + a_0 x_1} + beta_0 u^((n)) \
    & + (beta_1 + a_(n-1) beta_0) u^((n-1)) + dots.c + (a_(n-1) beta_(n-1) + dots.c + a_0 beta_0) u \
    & = b_n u^((n)) + b_(n-1) u^((n-1)) + dots.c + b_0 u
  $
  对比两端 $u^((k))$ 系数即得@beta递推，同时余项满足 $dot(x)_n + a_(n-1) x_n + dots.c + a_0 x_1 = beta_n u$，联立 $dot(x)_k = x_(k+1) + beta_k u$（$k = 1, ..., n - 1$）与 $y = x_1 + beta_0 u$ 即成。

#pagebreak()
= 线性离散系统的描述

离散时间系统既可直接描述离散动态过程，也可作为连续系统的采样离散化模型。将连续系统采样离散化时，采样频率 $omega_s$ 需满足*香农（Shannon）采样定理*：$omega_s > 2 omega_c$（$omega_c$ 为信号频谱上限频率）。通常约定采样时刻 $t_k = k T$ 简记为整数步 $k$（$k = 0, plus.minus 1, plus.minus 2, ...$）。

== 离散系统传递函数求解

+ *由差分方程求脉冲传递函数*：对线性定常差分方程
  $
    & y(k + n) + a_(n-1) y(k + n - 1) + dots.c + a_0 y(k) \
    & = b_n u(k + n) + b_(n-1) u(k + n - 1) + dots.c + b_0 u(k)
  $
  在零初始条件下取 Z 变换（利用位移性质 $cal(Z){x(k + 1)} = z X(z) - z x(0)$），得脉冲传递函数
  $
    G(z) = frac(Y(z), U(z)) = frac(b_n z^n + b_(n-1) z^(n-1) + dots.c + b_0, z^n + a_(n-1) z^(n-1) + dots.c + a_0)
  $
+ *由离散状态空间表达式求传递函数（阵）*：对离散状态空间表达式
  $
    cases(
      x(k + 1) = G x(k) + H u(k),
      y(k) = C x(k) + D u(k),
    )
  $
  在零初始条件下取 Z 变换得 $z X(z) = G X(z) + H U(z)$、$Y(z) = C X(z) + D U(z)$，消去 $X(z)$ 得
  $
    G_(y u)(z) = C (z I - G)^(-1) H + D
  $

== 离散状态转移方程的求解一般步骤

给定线性定常离散系统 $x(k + 1) = G x(k) + H u(k)$、初态 $x(0) = x_0$ 及输入序列 $u(0), u(1), ...$：

- *方法一（逐拍递推法，适合求前几步数值解）*：依次令 $k = 0, 1, 2, ...$ 代入 $x(k + 1) = G x(k) + H u(k)$ 计算 $x(1), x(2), x(3), ...$。
- *方法二（状态转移矩阵法，适合求通项解析解）*：
  + 计算离散状态转移矩阵 $Phi(k) = G^k$；
  + 代入离散状态转移方程，叠加零输入响应与零状态响应：
    $
      x(k) & = G^k x(0) + sum_(i = 0)^(k - 1) G^(k - i - 1) H u(i) \
           & = Phi(k) x(0) + sum_(i = 0)^(k - 1) Phi(k - i - 1) H u(i)
    $ <离散状态转移方程>

== 基础典型例题

已知线性定常离散时间系统的状态方程为
$
  x(k + 1) = mat(0, 1; -0.16, -1) x(k) + vec(1, 1) u(k)
$
给定初始状态 $x(0) = vec(1, -1)$ 及输入 $u(k) = 1$（$k = 0, 1, 2, ...$），求 $x(1), x(2), x(3)$。

解：按逐拍递推法依次代入 $k = 0, 1, 2$：
$
  x(1) & = mat(0, 1; -0.16, -1) vec(1, -1) + vec(1, 1) times 1 = vec(0, 1.84) \
  x(2) & = mat(0, 1; -0.16, -1) vec(0, 1.84) + vec(1, 1) times 1 = vec(2.84, -0.84) \
  x(3) & = mat(0, 1; -0.16, -1) vec(2.84, -0.84) + vec(1, 1) times 1 = vec(0.16, 1.3856)
$
同理可递推求得任意时刻的状态 $x(k)$。

== 离散状态转移矩阵性质与连续/离散对比

- *递推公式推导*：由 $x(1) = G x(0) + H u(0)$，$x(2) = G x(1) + H u(1) = G^2 x(0) + G H u(0) + H u(1)$，数学归纳即得@离散状态转移方程。
- *离散状态转移矩阵* $Phi(k) = G^k$ 满足差分方程与初值条件：$Phi(k + 1) = G Phi(k)$，$Phi(0) = I$。

#figure(
  caption: [线性定常连续系统与离散系统描述对比汇总],
  table(
    columns: (auto, auto, auto),
    [对比项目], [连续时间系统], [离散时间系统],
    [状态与输出方程],
    [$dot(x)(t) = A x(t) + B u(t) \ y(t) = C x(t) + D u(t)$],
    [$x(k + 1) = G x(k) + H u(k) \ y(k) = C x(k) + D u(k)$],

    [传递函数（阵）], [$G(s) = C (s I - A)^(-1) B + D$], [$G(z) = C (z I - G)^(-1) H + D$],

    [状态转移矩阵],
    [$Phi(t) = upright(e)^(A t), quad dot(Phi)(t) = A Phi(t), quad Phi(0) = I$],
    [$Phi(k) = G^k, quad Phi(k + 1) = G Phi(k), quad Phi(0) = I$],

    [状态转移方程\ （$t_0 = 0, k_0 = 0$）],
    [$x(t) = Phi(t) x(0) + integral_0^t Phi(t - tau) B u(tau) dif tau$],
    [$x(k) = Phi(k) x(0) + sum_(i = 0)^(k - 1) Phi(k - i - 1) H u(i)$],
  ),
)
