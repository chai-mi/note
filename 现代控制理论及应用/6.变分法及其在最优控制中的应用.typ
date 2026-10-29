#import "../template.typ": note
#show: note.with()

= 最优控制的基本概念

*最优控制*是现代控制理论的核心内容之一，其核心问题是：在给定约束条件下，如何选择控制律使控制系统的性能指标达到最优（极大或极小）。

- *经典控制理论的局限性*：主要解决单输入单输出（SISO）线性定常系统的分析与综合问题（采用时域分析、劳斯判据、根轨迹、伯德图等方法），首要目标是保证系统稳定并兼顾暂态性能与稳态误差，难以处理高阶、多输入多输出（MIMO）系统，也难以直接顾及能量消耗最少、时间最短等综合最优要求。
- *最优控制问题的基本构成*：由*性能指标*和*约束条件*共同构成。两者形式组合的不同，决定了不同类型的最优控制问题及最优解的存在性。
- *求解最优控制问题的三大主要方法*：
  + *变分法*（1954 年钱学森在《工程控制论》中提出将其用于最优控制器设计，适用于容许控制属于*开集*即控制变量无约束的最优控制问题）；
  + *极小值原理 / 极大值原理*（1956～1960 年庞特里亚金 Pontryagin 等提出，将最优控制转化为带约束的非经典变分问题，适用于容许控制属于*闭集*的问题）；
  + *动态规划法*（1953～1957 年贝尔曼 Bellman 基于 Hamilton-Jacobi 理论提出，同样可解决容许控制属于*闭集*的问题）。

== 最优控制问题的典型实例

=== 登月舱的月球软着陆问题（燃料消耗最少控制）

设飞船质量为 $m(t)$，离月球表面高度为 $h(t)$，垂直速度为 $v(t)$，发动机推力为 $u(t)$，月球表面重力加速度为 $g$，飞船干质量为 $M$，初始燃料质量为 $F$，推力与燃料消耗率的比例系数为 $k$，则运动方程（状态方程）为：

$
  cases(
    dot(h)(t) = v(t),
    dot(v)(t) = -g + u(t) / m(t),
    dot(m)(t) = -k u(t),
  )
$

- *初始条件*：$h(t_0) = h_0, quad v(t_0) = v_0, quad m(t_0) = M + F$
- *终端条件*：$h(t_f) = 0, quad v(t_f) = 0$（软着陆要求着陆时高度和速度均为零）
- *容许控制*：$0 <= u(t) <= a$
- *控制目标（性能指标）*：使着陆过程燃料消耗最少，等价于着陆时刻剩余质量最大：

  $
    max J(u(t)) = m(t_f)
  $

=== 升降机的最快升降问题（最短时间控制）

设升降机质量为 $M$，距地面高度为 $x(t)$，控制加速度 $u(t)$ 向上为正。由牛顿第二定律有 $diaer(x) = u - g$。取状态变量 $x_1 = x, x_2 = dot(x)$，状态方程为：

$
  cases(
    dot(x)_1 = x_2,
    dot(x)_2 = u - g,
  )
$

- *边界条件*：初态 $x_1(t_0) = x_1^0, x_2(t_0) = x_2^0$；末态 $x_1(t_f) = 0, x_2(t_f) = 0$
- *控制目标（性能指标）*：使升降机从初态转移到末态 $(0, 0)$ 的过渡时间最短（$t_f$ 待求）：

  $
    min J(u(t)) = integral_(t_0)^(t_f) dif t = t_f - t_0
  $

=== 生产库存控制问题（综合成本最小控制）

记商品库存量为 $x(t)$，已知销售率为 $r(t)$，生产率（控制变量）为 $u(t)$，则状态方程与容许控制约束为：

$
  dot(x)(t) = -r(t) + u(t), quad 0 <= u_0 <= u(t) <= u_1
$

设单位时间生产成本为 $h[u(t)]$，单位时间单位商品储存费用为 $b > 0$，则给定终端时刻 $t_f$ 下的总成本性能指标为：

$
  min J[u(t)] = integral_(t_0)^(t_f) {h[u(t)] + b x(t)} dif t
$

== 最优控制问题的一般性提法

=== 已知约束条件

+ *被控系统的状态方程*：

  $
    cases(
      dot(x)(t) = f[x(t), u(t), t] & quad "（连续时间系统）",
      x(k + 1) = f[x(k), u(k), k] & quad "（离散时间系统）",
    )
  $

+ *控制变量的约束（容许控制集）*：
  在实际控制问题中，控制量通常受客观物理条件限制。在 $RR^m$ 空间中，将满足约束条件的点 $u(t)$ 的集合 $U$ 称为*控制域*（或容许控制集），属于控制域 $U$ 的控制 $u(t) in U$ 称为*容许控制*。

+ *目标集（末端状态与初始状态的约束）*：
  规定的末端状态目标集一般表示为

  $
    Omega_f = {x(t_f) in RR^n : g_1(x(t_f), t_f) = 0, g_2(x(t_f), t_f) <= 0}
  $

  根据端点给定的不同情况，分为：
  - *固定终端*：终端时刻 $t_f$ 和终端状态 $x(t_f)$ 都给定；
  - *自由终端*：终端时刻 $t_f$ 给定，终端状态 $x(t_f)$ 任意取值；
  - *可变终端*：终端状态满足约束集 $x(t_f) in Omega_f$。
  - （同理，初始时刻 $t_0$ 通常给定；若初态 $x(t_0)$ 给定称为*固定始端*，任意称为*自由始端*，满足约束集称为*可变始端*。）

=== 性能指标（目标函数）

对于连续时间系统，评价控制品质好坏的性能指标泛函一般表示为：

$
  J = phi[x(t_f), t_f] + integral_(t_0)^(t_f) L[x(t), u(t), t] dif t
$

#figure(
  caption: [最优控制性能指标的三种基本类型],
  table(
    columns: 3,
    [类型名称], [表达式], [物理意义与作用],
    [综合型（鲍尔扎 Bolza 型）],
    [$J = phi[x(t_f), t_f] + integral_(t_0)^(t_f) L[x(t), u(t), t] dif t$],
    [兼顾终端状态精度与动态过程综合品质],

    [终端型（梅耶 Mayer 型）], [$J = phi[x(t_f), t_f]$], [仅含*终端项*，保证在终端时刻 $t_f$ 系统状态尽量接近期望终态],

    [积分型（拉格朗日 Lagrange 型）],
    [$J = integral_(t_0)^(t_f) L[x(t), u(t), t] dif t$],
    [仅含*积分项*，保证系统在整个转移过程中的动态综合性能（如耗时、耗能）],
  ),
)

/ 最优控制问题的标准定义: 从可供选择的容许控制集 $U$ 中，寻求一个控制向量 $u(t), t in [t_0, t_f]$，使被控系统 $dot(x) = f(x, u, t)$ 从初始状态 $x(t_0) = x_0$ 出发，在 $t_f > t_0$ 时刻转移到终态 $x(t_f)$ 或目标集 $x(t_f) in Omega_f$，并使性能指标 $J$ 取极小（或极大）值。满足上述条件的控制律 $u^*(t)$ 称为*最优控制*；在 $u^*(t)$ 作用下状态方程的解 $x^*(t)$ 称为*最优轨线*；沿最优轨线使性能指标达到的最优值 $J^*$ 称为*最优指标*。

#pagebreak()
= 变分法

变分法是研究*泛函极值问题*的数学方法。

== 泛函与泛函的变分

=== 泛函的概念

如果对于某个函数集合 ${y(x)}$ 中的每一个函数 $y(x)$，变量 $J$ 都有唯一确定的值与之对应，则称变量 $J$ 为依赖于函数 $y(x)$ 的*泛函*，记作 $J[y(x)]$。

- 通俗地说，泛函就是“*函数的函数*”。
- *泛函与函数的区别*：泛函的宗量（自变量）是*函数* $y(x)$，而普通函数的宗量是独立变量（实数或向量）$x$。
- 例如：$J[x] = integral_0^3 x(t) dif t$ 是定义在 $[0, 3]$ 上连续可积函数类上的泛函；当 $x(t) = t$ 时 $J = 4.5$，当 $x(t) = upright(e)^t$ 时 $J = upright(e)^3 - 1$。

=== 函数的接近度与泛函的极值

- *零阶接近度*：若对定义域中的一切 $x$ 均成立 $|y(x) - y_0(x)| <= epsilon$（$epsilon > 0$ 为小常量），则称函数 $y(x)$ 与 $y_0(x)$ 具有*零阶接近度*。
- *一阶接近度*：若同时满足 $|y(x) - y_0(x)| <= epsilon$ 且 $|y'(x) - y'_0(x)| <= epsilon$，则称函数 $y(x)$ 与 $y_0(x)$ 具有*一阶接近度*。
- *泛函的极值*：若泛函 $J[y(x)]$ 在任何一条与 $y_0(x)$ 接近的曲线上所取的值不小于 $J[y_0(x)]$，即
  $
    Delta J = J[y(x)] - J[y_0(x)] >= 0
  $
  则称泛函 $J[y(x)]$ 在曲线 $y_0(x)$ 上达到了*极小值*（反之若 $Delta J <= 0$ 则为*极大值*）。
  - *强极值*：在与 $y_0(x)$ 仅具有*零阶接近度*的曲线 $y(x)$ 中比较得出的极值；
  - *弱极值*：在与 $y_0(x)$ 具有*一阶（或一阶以上）接近度*的曲线 $y(x)$ 中比较得出的极值。
  - 由于强极值是从范围更大的一类函数中比较得出的，故强极值必为弱极值，反之不然。

=== 泛函的连续性与线性泛函

- *泛函的连续性*：若对任意给定的 $epsilon > 0$，总存在 $delta > 0$，当 $|y(x) - y_0(x)| <= delta$ 时有 $|J[y(x)] - J[y_0(x)]| < epsilon$，则称泛函 $J[y(x)]$ 在 $y_0(x)$ 处连续。
- *线性泛函*：若泛函 $J[y(x)]$ 连续，且同时满足齐次性与可加性：
  $
    J[a y(x)] = a J[y(x)], quad J[y_1(x) + y_2(x)] = J[y_1(x)] + J[y_2(x)]
  $
  则称 $J[y(x)]$ 为线性泛函。

=== 宗量的变分与泛函的变分

- *宗量的变分*：指同一自变量下两函数之差，记为
  $
    delta y(x) := y(x) - y_0(x)
  $
- *泛函的变分*：若连续泛函 $J[y(x)]$ 的增量可以表示为
  $
    Delta J[y(x)] & = J[y(x) + delta y(x)] - J[y(x)] \
                  & = L[y(x), delta y(x)] + R[y(x), delta y(x)]
  $
  其中第一项 $L[y(x), delta y(x)]$ 是关于 $delta y(x)$ 的*线性连续泛函*，第二项 $R[y(x), delta y(x)]$ 是关于 $delta y(x)$ 的高阶无穷小，则称线性主部 $L[y(x), delta y(x)]$ 为*泛函的（一次）变分*，记作
  $
    delta J = L[y(x), delta y(x)]
  $
  当泛函存在变分时，称该*泛函是可微的*。

=== 泛函变分的计算

/ 引理(泛函变分的计算公式): 可微泛函 $J[y(x)]$ 的变分可通过引入标量参数 $a$ 转化为普通函数的偏导数进行计算：
$
  delta J = lr(frac(partial, partial a) J[y(x) + a delta y(x)] |)_(a = 0)
$

==== 例 1：求泛函 $J = integral_0^1 y^2(x) dif x$ 的变分

解：根据泛函变分计算引理：

$
  delta J & = lr(frac(partial, partial a) J[y(x) + a delta y(x)] |)_(a = 0) \
          & = lr(frac(partial, partial a) integral_0^1 [y(x) + a delta y(x)]^2 dif x |)_(a = 0) \
          & = integral_0^1 lr(frac(partial, partial a) [y(x) + a delta y(x)]^2 |)_(a = 0) dif x \
          & = integral_0^1 lr(2[y(x) + a delta y(x)] delta y(x) |)_(a = 0) dif x \
          & = 2 integral_0^1 y(x) delta y(x) dif x
$

（直观规律：被积函数对宗量 $y(x)$ 求导后再乘以宗量的变分 $delta y(x)$。）

== 无约束泛函极值问题（拉格朗日问题）

/ 定理 1(泛函极值定理): 若可微泛函 $J[y(x)]$ 在 $y = y_0(x)$ 上达到极值，则泛函 $J[y(x)]$ 在 $y = y_0(x)$ 处的一次变分必等于零，即：
$
  delta J = 0
$
该必要条件同样适用于多元泛函 $J = J[y_1(x), y_2(x), ..., y_n(x)]$。

从容许函数类中寻找函数 $x(t)$ 使积分型泛函 $J = integral_(t_0)^(t_f) L(x, dot(x), t) dif t$ 取极小的无约束变分问题称为*拉格朗日（Lagrange）问题*（同理，含终端项的 $J = Phi[x(t_f), t_f] + integral_(t_0)^(t_f) L(x, dot(x), t) dif t$ 称为*鲍尔扎问题*，仅含终端项的 $J = Phi[x(t_f), t_f]$ 称为*麦耶问题*）。

/ 定理 2(拉格朗日问题的欧拉方程与横截条件): 对于拉格朗日问题中的积分型性能指标
$
  J[x] = integral_(t_0)^(t_f) L(x, dot(x), t) dif t
$
其中 $L(x, dot(x), t)$ 及 $x(t)$ 在 $[t_0, t_f]$ 上连续可微，$t_0$ 和 $t_f$ 给定，则 $J[x]$ 取极值的*必要条件*是同时满足：

+ *欧拉-拉格朗日方程（简称欧拉方程）*：

  $
    frac(partial L, partial x) - frac(dif, dif t) frac(partial L, partial dot(x)) = 0
  $ <欧拉方程>

+ *横截条件（边界条件）*：

  $
    lr((frac(partial L, partial dot(x)))^T |)_(t_f) delta x(t_f) - lr((frac(partial L, partial dot(x)))^T |)_(t_0) delta x(t_0) = 0
  $ <横截条件>

=== 不同端点边界条件下的横截条件形式

欧拉方程一般是二阶微分方程，其通解含有两个待定积分常数，需由两端点条件或横截条件确定：

#figure(
  caption: [初始与末端时刻 $t_0, t_f$ 固定时不同端点状态下的边界与横截条件],
  table(
    columns: 3,
    [端点状态给定情况], [端点变分特点], [对应的边界条件 / 横截条件],
    [(1) 两端都固定：$x(t_0) = x_0, x(t_f) = x_f$],
    [$delta x(t_0) = 0, quad delta x(t_f) = 0$],
    [$x(t_0) = x_0, quad x(t_f) = x_f$],

    [(2) 始端固定、末端自由：$x(t_0) = x_0$ 给定，$x(t_f)$ 自由],
    [$delta x(t_0) = 0, quad delta x(t_f)$ 任意],
    [$x(t_0) = x_0, quad lr(frac(partial L, partial dot(x)) |)_(t_f) = 0$],

    [(3) 两端都自由：$x(t_0), x(t_f)$ 均自由],
    [$delta x(t_0), delta x(t_f)$ 均任意],
    [$lr(frac(partial L, partial dot(x)) |)_(t_0) = 0, quad lr(frac(partial L, partial dot(x)) |)_(t_f) = 0$],

    [(4) 始端自由、末端固定：$x(t_0)$ 自由，$x(t_f) = x_f$ 给定],
    [$delta x(t_0)$ 任意，$delta x(t_f) = 0$],
    [$lr(frac(partial L, partial dot(x)) |)_(t_0) = 0, quad x(t_f) = x_f$],
  ),
)

==== 例 2：固定端点下的泛函极值曲线

求泛函 $J[x(t)] = integral_0^(pi / 2) (dot(x)^2 - x^2) dif t$ 在边界条件 $x(0) = 0, x(pi / 2) = 1$ 下的极值曲线。

解：被积函数 $L(x, dot(x), t) = dot(x)^2 - x^2$，代入欧拉方程：

$
  frac(partial L, partial x) - frac(dif, dif t) frac(partial L, partial dot(x)) = -2 x - 2 diaer(x) = 0 => diaer(x) + x = 0
$

其通解为 $x(t) = c_1 cos t + c_2 sin t$。代入边界条件 $x(0) = 0, x(pi / 2) = 1$ 得 $c_1 = 0, c_2 = 1$。故极值曲线为：

$
  x(t) = sin t
$

==== 例 3：不同边界条件下的最优轨线

求泛函 $J[x(t)] = integral_0^(t_f) [t dot(x)(t) + 0.5 dot(x)^2(t)] dif t$ 在下列两种边界条件下达到极值的最优轨线 $x^*(t)$：
(1) $t_f = 1, x(0) = 0, x(1) = 1$；quad (2) $t_f = 2, x(0) = 1, x(2)$ 自由。

解：被积函数 $L(x, dot(x), t) = t dot(x) + 0.5 dot(x)^2$，其中 $frac(partial L, partial x) = 0, frac(partial L, partial dot(x)) = t + dot(x)$。由欧拉方程得：

$
  frac(partial L, partial x) - frac(dif, dif t) frac(partial L, partial dot(x)) = -frac(dif, dif t) (t + dot(x)) = -1 - diaer(x)(t) = 0 => diaer(x)(t) = -1
$

积分两次得最优轨线通解：

$
  x^*(t) = -1 / 2 t^2 + c_1 t + c_2
$

- 对情况 (1)：代入 $x^*(0) = 0, x^*(1) = 1$，得 $c_2 = 0, c_1 = 3 / 2$，故最优轨线为：
  $
    x^*(t) = -1 / 2 t^2 + 3 / 2 t
  $
- 对情况 (2)：由 $x^*(0) = 1$ 得 $c_2 = 1$；因末端状态 $x(2)$ 自由，由横截条件得：
  $
    lr(frac(partial L, partial dot(x)) |)_(t_f) = t_f + dot(x)^*(t_f) = t_f + (-t_f + c_1) = c_1 = 0
  $
  故最优轨线为：
  $
    x^*(t) = -1 / 2 t^2 + 1
  $

== 条件极值——拉格朗日乘子法

在最优控制问题中，泛函 $J$ 的宗量函数还要受到系统状态方程等式约束的限制，这类问题称为*条件极值问题*。

考虑泛函

$
  J = integral_(t_0)^(t_f) L(x, dot(x), t) dif t
$

在微分/代数等式约束

$
  Psi(x, dot(x), t) = 0, quad t in [t_0, t_f]
$

下的条件极值问题。引入*拉格朗日乘子向量* $lambda(t)$，构造增广被积函数

$
  overline(L)(x, dot(x), lambda, t) = L(x, dot(x), t) + lambda^T (t) Psi(x, dot(x), t)
$

从而将原条件极值问题转化为增广泛函

$
  J_1 = integral_(t_0)^(t_f) [L(x, dot(x), t) + lambda^T (t) Psi(x, dot(x), t)] dif t
$

的无约束极值问题。

/ 定理 3(拉格朗日乘子定理): 设 $x(t)$ 使泛函 $J$ 在等式约束 $Psi(x, dot(x), t) = 0$ 下取极值，则必存在适当的拉格朗日乘子函数向量 $lambda(t)$ 使增广泛函 $J_1$ 达到无条件极值，即满足增广欧拉方程：
$
  frac(partial overline(L), partial x) - frac(dif, dif t) frac(partial overline(L), partial dot(x)) = 0
$

#pagebreak()
= 用变分法求解最优控制问题

考虑非线性受控系统状态方程：

$
  dot(x)(t) = f[x(t), u(t), t], quad x(t_0) = x_0
$ <受控系统>

其中 $x(t) in RR^n$ 为状态向量，$u(t) in RR^m$ 为无约束控制向量（容许控制集为开集），$f$ 为 $n$ 维连续可微向量函数。性能指标泛函为综合型（Bolza 型）：

$
  J = theta[x(t_f), t_f] + integral_(t_0)^(t_f) phi(x, u, t) dif t
$ <综合性能指标>

== 初始和末端时刻固定、末端状态自由的最优控制

=== 必要条件推导

已知 $t_0, t_f$ 固定，初态 $x(t_0) = x_0$ 固定，末端状态 $x(t_f)$ 自由，性能指标为

$
  J = theta[x(t_f)] + integral_(t_0)^(t_f) phi(x, u, t) dif t
$

+ *引入拉格朗日乘子（协态向量 / 伴随向量）* $lambda(t) = mat(lambda_1(t), lambda_2(t), ..., lambda_n(t))^T$，将状态方程约束 $f(x, u, t) - dot(x)(t) = 0$ 并入性能指标，得到等价增广泛函：

  $
    J_1 = theta[x(t_f)] + integral_(t_0)^(t_f) {phi(x, u, t) + lambda^T (t) [f(x, u, t) - dot(x)(t)]} dif t
  $

+ *定义哈密顿（Hamilton）函数*：

  $
    H(x, u, lambda, t) := phi(x, u, t) + lambda^T (t) f(x, u, t)
  $ <哈密顿函数>

  并对 $-integral_(t_0)^(t_f) lambda^T (t) dot(x)(t) dif t$ 项进行分部积分，得：

  $
    J_1 = theta[x(t_f)] - lr(lambda^T (t) x(t) |)_(t_0)^(t_f) + integral_(t_0)^(t_f) [H(x, u, lambda, t) + dot(lambda)^T (t) x(t)] dif t
  $

+ *计算一次变分并令 $delta J_1 = 0$*：
  在该问题中，*可变的量*为 $u(t), x(t), x(t_f)$；*不可变的量*为 $t_0, t_f, x(t_0)$ 以及待定的乘子函数 $lambda(t)$。对 $J_1$ 求一次变分：

  $
    delta J_1 = [frac(partial theta, partial x(t_f)) - lambda(t_f)]^T delta x(t_f) + integral_(t_0)^(t_f) {[frac(partial H, partial x) + dot(lambda)]^T delta x + [frac(partial H, partial u)]^T delta u} dif t = 0
  $

  由于状态变分 $delta x(t)$ 与终端变分 $delta x(t_f)$ 由控制变分 $delta u(t)$ 引起、并非完全独立，可通过适当选取待定乘子 $lambda(t)$ 使 $delta x(t)$ 和 $delta x(t_f)$ 前的系数为零，再由 $delta u(t)$ 的任意性使 $delta u(t)$ 的系数为零，从而得到极值必要条件。（注：亦可令 $overline(H) = phi + lambda^T (f - dot(x))$，直接对宗量 $x$ 和 $u$ 列写欧拉方程得到完全相同的结果。）

/ 定理 4(终端时刻固定、终端状态自由的最优控制必要条件): 对于受控系统@受控系统 与性能指标 $J = theta[x(t_f)] + integral_(t_0)^(t_f) phi(x, u, t) dif t$，当初始和末端时刻 $t_0, t_f$ 固定、末端状态 $x(t_f)$ 自由时，为使 $u^*(t)$ 和 $x^*(t)$ 成为最优控制和最优轨线，必存在协态向量 $lambda(t)$ 满足：

+ *正则方程（状态方程与协态/伴随方程）*：

  $
    cases(
      dot(x)(t) = frac(partial H, partial lambda) = f(x, u, t),
      dot(lambda)(t) = -frac(partial H, partial x) = -frac(partial phi, partial x) - (frac(partial f, partial x))^T lambda(t),
    )
  $ <正则方程>

+ *控制方程（极值条件）*：

  $
    frac(partial H, partial u) = frac(partial phi, partial u) + (frac(partial f, partial u))^T lambda(t) = 0
  $ <控制方程>

+ *边界条件（初值条件与终端横截条件）*：

  $
    x(t_0) = x_0, quad lambda(t_f) = frac(partial theta, partial x(t_f))
  $ <固定终端时刻横截条件>

（注：$delta J = 0$ 是泛函取极值的必要条件，是否为极小值还需由二次变分 $delta^2 J > 0$ 判断。）

=== 哈密顿函数沿最优轨线的性质

计算哈密顿函数 $H(x, u, lambda, t)$ 沿最优轨线对时间 $t$ 的全导数：

$
  frac(dif H, dif t) = (frac(partial H, partial x))^T dot(x) + (frac(partial H, partial u))^T dot(u) + (frac(partial H, partial lambda))^T dot(lambda) + frac(partial H, partial t)
$

沿最优轨线代入控制方程 $frac(partial H, partial u) = 0$ 以及正则方程 $dot(x) = frac(partial H, partial lambda), dot(lambda) = -frac(partial H, partial x)$，前两项正负相消：

$
  (frac(partial H, partial x))^T dot(x) + (frac(partial H, partial lambda))^T dot(lambda) = (frac(partial H, partial x))^T frac(partial H, partial lambda) - (frac(partial H, partial lambda))^T frac(partial H, partial x) = 0
$

故有：

$
  frac(dif H, dif t) = frac(partial H, partial t)
$

*结论*：哈密顿函数 $H$ 沿最优轨线对时间的全导数等于它对时间的偏导数。特别地，*当 $H$ 不显含时间 $t$（即 $frac(partial H, partial t) = 0$）时，沿最优轨线 $H$ 恒为常数*：

$
  H(x^*, u^*, lambda) = "const", quad t in [t_0, t_f]
$

=== 求解最优控制问题的一般步骤

+ *第 1 步（构造哈密顿函数并求控制方程）*：
  构造 $H(x, u, lambda, t) = phi(x, u, t) + lambda^T (t) f(x, u, t)$，由控制方程 $frac(partial H, partial u) = 0$ 解出 $u^*(t) = u(x^*, lambda^*)$。
+ *第 2 步（求解两点边值问题）*：
  将 $u^*(t) = u(x^*, lambda^*)$ 代入正则方程（状态方程与伴随方程），结合给定的初值条件 $x(t_0) = x_0$ 和终端横截条件求解出最优轨线 $x^*(t)$ 和协态向量 $lambda^*(t)$。
+ *第 3 步（回代求最优控制律）*：
  将求得的 $x^*(t)$ 和 $lambda^*(t)$ 代入 $u(x^*, lambda^*)$，得到最优控制 $u^*(t)$ 及最优性能指标 $J^*$。

== 初始时刻固定、末端时刻自由的最优控制

已知初始时刻 $t_0$ 和初始状态 $x(t_0) = x_0$ 固定，*末端时刻 $t_f$ 自由*（末端状态 $x(t_f)$ 自由或固定），性能指标为：

$
  J = theta[x(t_f), t_f] + integral_(t_0)^(t_f) phi(x, u, t) dif t
$

此时除 $u(t), x(t), x(t_f)$ 外，*末端时刻 $t_f$ 也是一个可变的参量*。在求增广泛函 $J_1$ 的一次变分时，还需计入积分上限 $t_f$ 和终端项对 $t_f$ 的变分 $delta t_f$：

$
  delta J_1 & = [frac(partial theta, partial x(t_f)) - lambda(t_f)]^T delta x(t_f) + integral_(t_0)^(t_f) [(frac(partial H, partial x) + dot(lambda))^T delta x + (frac(partial H, partial u))^T delta u] dif t \
  & quad + [frac(partial theta, partial t_f) + H(x(t_f), u(t_f), lambda(t_f), t_f)] delta t_f = 0
$

由 $delta t_f$ 的任意性，可得确定最优终端时刻 $t_f^*$ 的附加终端条件。

/ 定理 5(末端时刻自由的最优控制必要条件): 对于末端时刻 $t_f$ 自由、末端状态 $x(t_f)$ 自由的最优控制问题，最优控制 $u^*(t)$、最优轨线 $x^*(t)$ 与协态向量 $lambda(t)$ 必须满足：

+ *正则方程*：$dot(x)(t) = frac(partial H, partial lambda) = f(x, u, t), quad dot(lambda)(t) = -frac(partial H, partial x)$
+ *控制方程*：$frac(partial H, partial u) = 0$
+ *边界条件*：$x(t_0) = x_0, quad lambda(t_f) = frac(partial theta, partial x(t_f))$（若末端状态 $x(t_f) = x_f$ 固定，则后一式替换为 $x(t_f) = x_f$）
+ *终端时刻横截条件*（哈密顿函数在最优轨线末端满足的条件）：

  $
    H(t_f) = -frac(partial theta, partial t_f)
  $ <终端时刻自由横截条件>

#figure(
  caption: [不同终端约束下最优控制的 $2n$ 个边界条件与附加条件汇总（初态 $x(t_0) = x_0$ 固定）],
  table(
    columns: 4,
    [终端时刻 $t_f$], [终端状态 $x(t_f)$], [状态与协态边界条件（共 $2n$ 个）], [确定 $t_f$ 的附加横截条件],

    [固定], [固定 $x(t_f) = x_f$], [$x(t_0) = x_0, quad x(t_f) = x_f$], [无（$t_f$ 已知）],

    [固定], [自由], [$x(t_0) = x_0, quad lambda(t_f) = frac(partial theta, partial x(t_f))$], [无（$t_f$ 已知）],

    [自由], [固定 $x(t_f) = x_f$], [$x(t_0) = x_0, quad x(t_f) = x_f$], [$H(t_f) = -frac(partial theta, partial t_f)$],

    [自由],
    [自由],
    [$x(t_0) = x_0, quad lambda(t_f) = frac(partial theta, partial x(t_f))$],
    [$H(t_f) = -frac(partial theta, partial t_f)$],
  ),
)

#pagebreak()
= 例题

== 终端时刻固定、终端状态自由的最优控制

已知系统状态方程为 $dot(x) = u$，初始条件 $x(t_0) = x_0$（$t_0, t_f$ 固定，$x(t_f)$ 自由），性能指标为

$
  J = 1 / 2 c x^2(t_f) + 1 / 2 integral_(t_0)^(t_f) u^2 dif t, quad (c > 0)
$

试求最优控制 $u^*(t)$、最优轨线 $x^*(t)$ 及最优性能指标 $J^*$。

解：

+ *构造哈密顿函数*（其中 $theta = 1 / 2 c x^2(t_f), phi = 1 / 2 u^2, f = u$）：

  $
    H(x, u, lambda, t) = 1 / 2 u^2 + lambda u
  $

+ *列写控制方程、伴随方程与横截条件*：
  - 由控制方程：
    $
      frac(partial H, partial u) = u + lambda = 0 => u^*(t) = -lambda(t)
    $
  - 由伴随方程：
    $
      dot(lambda) = -frac(partial H, partial x) = 0 => lambda(t) = "const"
    $
  - 由终端横截条件：
    $
      lambda(t_f) = frac(partial theta, partial x(t_f)) = frac(partial, partial x(t_f)) [1 / 2 c x^2(t_f)] = c x(t_f)
    $
  因 $lambda(t)$ 为常数，故对任意 $t in [t_0, t_f]$ 有 $lambda(t) = lambda(t_f) = c x(t_f)$，从而：
  $
    u^*(t) = -lambda(t) = -c x(t_f)
  $

+ *代入状态方程求解最优轨线*：
  将 $dot(x) = u^* = -c x(t_f)$ 积分并代入初值 $x(t_0) = x_0$，得：

  $
    x^*(t) = -c x(t_f) (t - t_0) + x_0
  $

  令 $t = t_f$，解出终端状态值：

  $
    x(t_f) = -c x(t_f)(t_f - t_0) + x_0 => x(t_f) = frac(x_0, 1 + c(t_f - t_0))
  $

+ *整理最优解*：
  - *最优控制律*：
    $
      u^*(t) = -frac(c x_0, 1 + c(t_f - t_0))
    $
  - *最优状态轨线*：
    $
      x^*(t) = frac(c x_0 (t_f - t) + x_0, 1 + c(t_f - t_0))
    $
  - *最优性能指标*：
    $
      J^* = 1 / 2 c x^2(t_f) + 1 / 2 integral_(t_0)^(t_f) (u^*)^2 dif t = frac(c x_0^2, 2[1 + c(t_f - t_0)])
    $

== 初末状态固定、终端时刻自由的最优控制

已知系统状态方程为 $dot(x) = u$，边界条件 $x(0) = 1, x(t_f) = 0$（终端时刻 $t_f$ 自由），性能指标为

$
  J = t_f^2 + integral_0^(t_f) u^2 dif t
$

求最优控制 $u^*(t)$ 和最优末端时刻 $t_f^*$，使 $J$ 取极小值。

解：

+ *构造哈密顿函数*（其中 $theta(t_f) = t_f^2, phi = u^2, f = u$）：

  $
    H(x, u, lambda) = u^2 + lambda u
  $

+ *求解控制方程与伴随方程*：
  - 控制方程：$frac(partial H, partial u) = 2 u^* + lambda = 0 => u^* = -1 / 2 lambda$
  - 伴随方程：$dot(lambda) = -frac(partial H, partial x) = 0 => lambda = c_1 = "const" => u^* = -1 / 2 c_1$

+ *代入状态方程与边界条件*：
  由 $dot(x) = u^* = -1 / 2 c_1$ 积分得 $x(t) = -1 / 2 c_1 t + c_2$。代入 $x(0) = 1, x(t_f) = 0$ 得：

  $
    c_2 = 1, quad c_1 = 2 / t_f
  $

+ *利用终端时刻横截条件确定 $t_f^*$*：
  由 $H(t_f) = -frac(partial theta, partial t_f)$ 得：

  $
    (u^*(t_f))^2 + lambda(t_f) u^*(t_f) = -2 t_f
  $

  将 $lambda = c_1 = 2 / t_f$ 及 $u^* = -1 / 2 c_1 = -1 / t_f$ 代入上式：

  $
    1 / t_f^2 - 2 / t_f^2 + 2 t_f = 0 => 2 t_f = 1 / t_f^2 => t_f^* = 2^(-1 / 3)
  $

  从而得到：

  $
    c_1 = root(3, 16) = 2^(4 / 3), quad u^*(t) = -2^(-2 / 3), quad x^*(t) = -2^(1 / 3) t + 1
  $

== 室内温度的最优控制问题（终端状态固定、终端时刻自由）

设室内温度为 $theta(t)$，外部恒定环境温度为 $theta_a = 15^circle.small$，加热速率为 $u(t)$。温度动力学方程为 $dot(theta)(t) = -a(theta(t) - theta_a) + b u(t)$。定义温差状态变量 $x(t) = theta(t) - theta_a$，则状态方程与边界条件为：

$
  dot(x)(t) = -a x(t) + b u(t), quad x(0) = 0^circle.small, quad x(t_f) = 10^circle.small
$

性能指标（兼顾升温时间与加热能耗，$t_f$ 自由）定义为：

$
  J = t_f + 1 / 2 integral_0^(t_f) u^2(t) dif t
$

解：

+ *构造哈密顿函数*（终端项 $theta = t_f$，被积项 $phi = 1 / 2 u^2$）：

  $
    H = 1 / 2 u^2(t) + lambda(t) [-a x(t) + b u(t)]
  $

+ *列写伴随方程与控制方程*：
  - 伴随方程：$dot(lambda) = -frac(partial H, partial x) = a lambda => lambda(t) = lambda(t_f) upright(e)^(-a(t_f - t))$
  - 控制方程：$frac(partial H, partial u) = u + b lambda = 0 => u(t) = -b lambda(t)$
  （因初、末状态 $x(0)$ 和 $x(t_f)$ 全部给定，故状态无终端横截条件。）

+ *利用终端时刻横截条件求 $lambda(t_f)$*：
  由 $H(t_f) = -frac(partial theta, partial t_f) = -1$ 并代入 $u(t_f) = -b lambda(t_f)$，得：

  $
    1 / 2 u^2(t_f) + lambda(t_f) [-a x(t_f) + b u(t_f)] = -1 / 2 b^2 lambda^2(t_f) - a x(t_f) lambda(t_f) = -1
  $

  即二次方程 $1 / 2 b^2 lambda^2(t_f) + a x(t_f) lambda(t_f) - 1 = 0$。代入参数 $x(t_f) = 10, b = 1$（取 $a = 0.035$）解得两个根：

  $
    lambda_1(t_f) approx 1.104, quad lambda_2(t_f) approx -1.811
  $

+ *求解状态方程并确定最优终端时刻 $t_f$*：
  将 $u(t) = -b lambda(t) = -b lambda(t_f) upright(e)^(-a(t_f - t))$ 代入状态方程：

  $
    dot(x)(t) = -a x(t) - b^2 lambda(t_f) upright(e)^(-a(t_f - t))
  $

  对上式取拉氏变换（利用 $x(0) = 0$）：

  $
    X(s) = -frac(b^2 lambda(t_f) upright(e)^(-a t_f), (s + a)(s - a)) = -frac(b^2, a) lambda(t_f) upright(e)^(-a t_f) dot 1 / 2 (frac(1, s - a) - frac(1, s + a))
  $

  拉氏反变换得状态轨线：

  $
    x(t) = -frac(b^2, a) lambda(t_f) upright(e)^(-a t_f) (frac(upright(e)^(a t) - upright(e)^(-a t), 2)) = -frac(b^2, a) lambda(t_f) upright(e)^(-a t_f) sinh(a t)
  $

  代入终态条件 $x(t_f) = 10$，可得：

  $
    lambda(t_f) = -frac(20 a, b^2 (1 - upright(e)^(-2 a t_f)))
  $

  因 $t_f > 0$ 时必有 $lambda(t_f) < 0$，故舍去正根 $lambda_1(t_f) = 1.104$（对应 $t_(f 1) = -6.999 < 0$），取 $lambda_2(t_f) = -1.811$，解得 $t_f^* approx 6.999$。

+ *最优控制、最优轨线与最优协态*：

  $
    u^*(t) = frac(10 a upright(e)^(a t), b sinh(a t_f)), quad x^*(t) = 10 frac(sinh(a t), sinh(a t_f)), quad lambda^*(t) = -frac(10 a upright(e)^(a t), b^2 sinh(a t_f))
  $
