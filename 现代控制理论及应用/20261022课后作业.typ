#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#import "../template.typ": note
#show: note.with()

=

已知系统的状态空间表达式为

$
  cases(
    dot(x) = mat(-5, -1; 6, 0) x + vec(0, 2) u,
    y = mat(0, 1) x
  )
$

+ 画出系统结构图。
+ 求系统的传递函数。
+ 判别系统能控性和能观测性。
+ 求系统状态转移矩阵 $Phi(t)$。
+ 当 $x(0) = vec(0, 3)$，$u(t) = 0$ 时，求系统输出 $y(t)$。
+ 设计全维状态观测器，将观测器极点配置在 $-10 plus.minus j 10$ 处。
+ 在 (6) 的基础上，设计状态反馈 $K$，使闭环极点配置在 $-5 plus.minus j 5$ 处。
+ 画出系统总体结构图。

#pagebreak()
== 系统结构图

#figure(
  diagram(
    node-stroke: 1pt,
    edge("r", "-|>", $u$),
    node((1, 0), $2$),
    edge("-|>"),
    node((2, 0), $times$, radius: 10pt),
    edge("-|>", $dot(x)_2$),
    node((3, 0), $integral$),
    edge("rr", "-|>"),
    node((4.5, 0.1), $x_2$, stroke: none),
    node((5, 0), $y$, stroke: none),
    edge((4, 0), "u,l", "-|>"),

    node((2, -1), $6$),
    edge((2, -2), "u", "-|>"),
    edge("d", "-|>"),
    node((2, -3), $-5$, radius: 12pt),
    edge("r", "-|>"),

    node((3, -1), $-1$, radius: 12pt),
    edge("uu", "-|>"),
    node((3, -3), $times$, radius: 10pt),
    edge("-|>", $dot(x)_1$),
    node((3, -4), $integral$),
    edge("rr", "-|>"),
    edge((4, -4), "dd,ll,d", "-|>"),
    node((4.5, -4.2), $x_1$, stroke: none),
  ),
  caption: [系统结构图],
)

#pagebreak()
== 传递函数

$
  g_(y u)(s) & = C mat(s I -A)^(-1) B \
             & = mat(0, 1) mat(s+5, 1; -6, s)^(-1) mat(0; 2) \
             & = mat(0, 1) mat(s, -1; 6, s+5)/(s^2+5s+6) mat(0; 2) \
             & = (2(s+5))/((s+2)(s+3))
$

#pagebreak()
== 能控性和能观性

$
  Psi_c = mat(0, -2; 2, 0) \
  "rank" Psi_c = 2
$

故可控

$
  Psi_o = mat(0, 6; 1, 0)^T \
  "rank" Psi_o = 2
$

故可观

#pagebreak()
== 系统状态转移矩阵

$
  Phi(t) & = upright(e)^(A t) \
  & = cal(L)^(-1) { (s I - A)^(-1) } \
  & = cal(L)^(-1) mat(s/((s+2)(s+3)), -1/((s+2)(s+3)); 6/((s+2)(s+3)), (s+5)/((s+2)(s+3))) \
  & = mat(-2 upright(e)^(-2t)+3 upright(e)^(-3t), -upright(e)^(-2t)+upright(e)^(-3t); 6 upright(e)^(-2t)-6 upright(e)^(-3t), 3 upright(e)^(-2t)-2 upright(e)^(-3t))
$

#pagebreak()
== 系统输出

$
  y(t) & = mat(0, 1) x(t) = mat(0, 1) Phi(t) mat(0; 3) \
       & = 9 upright(e)^(-2t)-6 upright(e)^(-3t)
$

#pagebreak()
== 全维状态观测器

+ 判断可观性：由第 3 题，已知可观
+ 计算期望的观测器特征多项式：

  $
    alpha^* (s) = (s + 10 - j 10)(s + 10 + j 10) = s^2 + 20 s + 200
  $

+ 设观测器反馈增益矩阵 $G = vec(g_1, g_2)$，计算观测器特征多项式：

  $
    Delta_o (s) & = mat(s I - A + G c, delim: "|") \
                & = mat(
                    s + 5, 1 + g_1;
                    -6, s + g_2,
                    delim: "|"
                  ) \
                & = s^2 + (5 + g_2) s + (5 g_2 + 6 + 6 g_1)
  $

+ 比较同次幂系数：

  $
    cases(
      5 + g_2 = 20,
      5 g_2 + 6 + 6 g_1 = 200,
    ) => cases(
      g_1 = 31 / 3,
      g_2 = 15,
    )
  $

+ 所求全维状态观测器方程为：

  $
    dot(hat(x)) = (A - G c) hat(x) + B u + G y = mat(-5, -34/3; 6, -15) hat(x) + vec(0, 2) u + vec(31/3, 15) y
  $

#pagebreak()
== 状态反馈

+ 判断可控性：由第 3 题，已知可控
+ 计算期望的特征多项式：

  $
    alpha^* (s) = (s + 5 - j 5)(s + 5 + j 5) = s^2 + 10 s + 50
  $
+ 由分离原理：
  $
    mat(s I -A + B K, delim: "|") & = mat(s+5, 1; -6+2k_1, s+2k_2, delim: "|") \
                                  & = s^2+ (5+2k_2) s -2k_1 +10k_2 +6
  $
+ 故
  $
    K = mat(-19/2; 5/2)
  $

#pagebreak()
== 系统总体结构图

由 (6)、(7) 可得带全维状态观测器的状态反馈闭环系统方程为：

$
  cases(
    dot(x) = mat(-5, -1; 6, 0) x + vec(0, 2) u,
    dot(hat(x)) = mat(-5, -34/3; 6, -15) hat(x) + vec(0, 2) u + vec(31/3, 15) y,
    u = r - K hat(x) = r + 19/2 hat(x)_1 - 5/2 hat(x)_2,
    y = mat(0, 1) x
  )
$

#figure(
  {
    set text(12pt)
    diagram(
      node-stroke: 1pt,
      // 参考输入 r 与控制律 u 求和节点
      edge((-2, 0), (-1, 0), "-|>", $r$),
      node((-1, 0), $times$, radius: 10pt),
      edge((-1, 0), (1, 0), "-|>", $u$),

      // 原系统（上半部分）
      node((1, 0), $2$),
      edge("-|>"),
      node((2, 0), $times$, radius: 10pt),
      edge("-|>", $dot(x)_2$),
      node((3, 0), $integral$),
      edge((3, 0), (6, 0), "-|>"),
      node((4.5, 0.2), $x_2$, stroke: none),
      node((6.3, 0), $y$, stroke: none),
      edge((4, 0), "u,l", "-|>"),

      node((2, -1), $6$),
      edge((2, -2), "u", "-|>"),
      edge((2, -2), "d", "-|>"),
      edge((2, -1), (2, 0), "-|>"),
      node((2, -3), $-5$, radius: 12pt),
      edge((2, -3), (3, -3), "-|>"),

      node((3, -1), $-1$, radius: 12pt),
      edge((3, -1), (3, -3), "-|>"),
      node((3, -3), $times$, radius: 10pt),
      edge((3, -3), (3, -4), "-|>", $dot(x)_1$),
      node((3, -4), $integral$),
      edge((3, -4), (5, -4), "-|>"),
      edge((4, -4), "dd,ll,d", "-|>"),
      node((4.5, -4.2), $x_1$, stroke: none),

      // 全维状态观测器（下半部分）
      // u 输入分支
      edge((0, 0), (0, 3), (1, 3), "-|>"),
      node((1, 3), $2$),
      edge((1, 3), (2, 3), "-|>"),
      node((2, 3), $times$, radius: 10pt),
      edge((2, 3), (3, 3), "-|>", $dot(hat(x))_2$),
      node((3, 3), $integral$),
      edge((3, 3), (5, 3), "-|>"),
      node((4.5, 3.2), $hat(x)_2$, stroke: none),

      // hat(x)_2 内部反馈 -15 与 -34/3
      node((2, 2), $times$, radius: 10pt),
      edge((2, 2), (2, 3), "-|>"),
      edge((4, 3), (4, 2), (3, 2), "-|>"),
      node((3, 2), $-15$, radius: 13pt),
      edge((3, 2), (2, 2), "-|>"),

      edge((4, 3), (4, 4), (3, 4), "-|>"),
      node((3, 4), $-34/3$, radius: 16pt),
      edge((3, 4), (3, 6), "-|>"),

      // y 输出分支进入观测器 G = [31/3; 15]
      edge((5.5, 0), (5.5, 1), (3, 1), "-|>"),
      node((3, 1), $15$, radius: 12pt),
      edge((3, 1), (2, 1), (2, 2), "-|>"),

      edge((5.5, 1), (5.5, 6), (4.2, 6), "-|>"),
      node((4.2, 6), $31/3$, radius: 16pt),
      edge((4.2, 6), (3, 6), "-|>"),

      // hat(x)_1 通道
      node((3, 6), $times$, radius: 10pt),
      edge((3, 6), (3, 7), "-|>", $dot(hat(x))_1$),
      node((3, 7), $integral$),
      edge((3, 7), (5, 7), "-|>"),
      node((4.5, 7.2), $hat(x)_1$, stroke: none),

      // hat(x)_1 内部反馈 -5 与 6
      edge((4, 7), (4, 8), (1.2, 8), (1.2, 5), (2, 5), (2, 4), "-|>"),
      node((2, 4), $6$),
      edge((2, 4), (2, 3), "-|>"),
      node((2, 6), $-5$, radius: 12pt),
      edge((2, 5), (2, 6), "-|>"),
      edge((2, 6), (3, 6), "-|>"),

      // 状态反馈 K = [-19/2, 5/2] => u = r + 19/2 hat(x)_1 - 5/2 hat(x)_2
      node((-1, 1.5), $times$, radius: 10pt),
      edge((-1, 1.5), (-1, 0), "-|>"),

      edge((4, 2), (4, 1.5), (0.8, 1.5), "-|>"),
      node((0.8, 1.5), $-5/2$, radius: 15pt),
      edge((0.8, 1.5), (-1, 1.5), "-|>"),

      edge((1.2, 8), (-1, 8), (-1, 5), "-|>"),
      node((-1, 5), $19/2$, radius: 15pt),
      edge((-1, 5), (-1, 1.5), "-|>"),
    )
  },
  caption: [系统总体结构图],
)
