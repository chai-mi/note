#import "../template.typ": note
#show: note.with()

= 极小值原理

考虑控制变量受有界闭集约束 $u(t) in U subset RR^m$ 的受控系统与性能指标：

$
  dot(x)(t) = f[x(t), u(t), t], quad x(t_0) = x_0, quad N[x(t_f), t_f] = 0
$ <状态方程>

$
  J = theta[x(t_f), t_f] + integral_(t_0)^(t_f) phi[x(t), u(t), t] dif t
$ <鲍尔扎指标>

== 求解一般步骤

+ *构造哈密顿（Hamilton）函数*：

  $
    H(x, u, lambda, t) = phi(x, u, t) + lambda^T (t) f[x(t), u(t), t]
  $ <极小值哈密顿函数>

+ *列写伴随方程与终端横截条件*：
  - 伴随（协态）方程：
    $
      dot(lambda)(t) = -frac(partial H, partial x) = -frac(partial phi, partial x) - (frac(partial f, partial x))^T lambda(t)
    $
  - 终端状态横截条件（如终端无约束时 $lambda(t_f) = frac(partial theta, partial x(t_f))$；若 $t_f$ 自由，附加 $H(t_f) = -frac(partial theta, partial t_f)$）。

+ *由极小值条件确定最优控制 $u^*(t)$*：
  在容许控制集 $U$ 上求使哈密顿函数 $H$ 取全局最小的 $u^*(t)$：

  $
    H(x^*, u^*, lambda^*, t) = min_(u in U) H[x^*, u, lambda^*, t]
  $ <极小值条件>

+ *代入状态方程求解最优轨线与最优指标*：
  将 $u^*(t)$ 代入状态方程 $dot(x)(t) = f[x(t), u(t), t]$ 并结合初末边界条件，解出最优轨线 $x^*(t)$ 及最优性能指标 $J^*$。

== 例题：终端自由、控制有界约束的最优控制

设二阶线性系统的状态方程与初始条件为：

$
  cases(
    dot(x)_1 = -x_1 + u,
    dot(x)_2 = x_1,
  ), quad x(0) = vec(1, 0)
$

控制变量受有界闭集约束：$-1 <= u(t) <= 1$。试求最优容许控制 $u^*(t)$，使性能指标

$
  min J = x_2(1)
$

达到最小，并求最优状态轨线 $x^*(t)$ 和最优性能指标 $J^*$。

解：（$t_f = 1$ 固定、$x(1)$ 自由、$theta = x_2(1), phi = 0$）

+ *构造哈密顿函数*：

  $
    H(x, u, lambda) = lambda^T f(x, u) = lambda_1 (-x_1 + u) + lambda_2 x_1
  $

+ *列写并求解伴随方程与横截条件*：
  - 伴随方程 $dot(lambda) = -frac(partial H, partial x)$：
    $
      cases(
        dot(lambda)_1 = -frac(partial H, partial x_1) = lambda_1 - lambda_2,
        dot(lambda)_2 = -frac(partial H, partial x_2) = 0,
      )
    $
  - 终端横截条件（$x(1)$ 自由）：
    $
      cases(
        lambda_1(1) = frac(partial theta, partial x_1(1)) = 0,
        lambda_2(1) = frac(partial theta, partial x_2(1)) = 1,
      )
    $
  联立求解得：
  $
    cases(
      lambda_1(t) = 1 - upright(e)^(t - 1),
      lambda_2(t) = 1,
    ), quad t in [0, 1]
  $

+ *应用极小值条件求最优控制 $u^*(t)$*：

  $
    H(x^*, u^*, lambda^*, t) & = min_(-1 <= u <= 1) {lambda_1^* (-x_1^* + u) + lambda_2^* x_1^*} \
                             & = -lambda_1^* x_1^* + lambda_2^* x_1^* + min_(-1 <= u <= 1) (lambda_1^* u)
  $

  由于在 $t in [0, 1)$ 上恒有 $t - 1 < 0 => lambda_1^*(t) = 1 - upright(e)^(t - 1) > 0$，为使线性项 $lambda_1^*(t) u$ 最小，在 $[0, 1]$ 上恒取下界：

  $
    u^*(t) = -1
  $

+ *代入状态方程求最优轨线与最优指标*：
  将 $u^*(t) = -1$ 代入状态方程：

  $
    cases(
      dot(x)_1^* = -x_1^* - 1,
      dot(x)_2^* = x_1^*,
    ), quad x(0) = vec(1, 0)
  $

  依次积分得最优解与最优性能指标：

  $
    cases(
      u^*(t) = -1,
      x_1^*(t) = 2 upright(e)^(-t) - 1,
      x_2^*(t) = -2 upright(e)^(-t) - t + 2,
    ) => J^* = x_2^*(1) = 1 - 2 upright(e)^(-1) approx 0.2642
  $

== 极小值原理定理与步骤原理

=== 庞特里亚金极小值原理（含一般终端等式约束）

/ 定理 1(庞特里亚金极小值原理): 对于系统@状态方程、终端等式约束 $N[x(t_f), t_f] = 0$（对应常值拉格朗日乘子向量 $nu in RR^r$）、有界闭集控制约束 $u(t) in U subset RR^m$ 及鲍尔扎性能指标@鲍尔扎指标，定义哈密顿函数 $H(x, u, lambda, t) = phi(x, u, t) + lambda^T (t) f[x(t), u(t), t]$，则最优控制 $u^*(t)$、最优轨线 $x^*(t)$ 和协态向量 $lambda^*(t)$ 必须同时满足下列 5 个必要条件：

+ *正则方程*：

  $
    cases(
      dot(x)(t) = frac(partial H, partial lambda) = f[x(t), u(t), t],
      dot(lambda)(t) = -frac(partial H, partial x) = -frac(partial phi, partial x) - (frac(partial f, partial x))^T lambda(t),
    )
  $ <极小值正则方程>

+ *哈密顿函数全局极小条件*：

  $
    H(x^*, u^*, lambda^*, t) = min_(u in U) H[x^*, u, lambda^*, t] quad \
    ("即" H(x^*, u^*, lambda^*, t) <= H[x^*, u, lambda^*, t], forall u(t) in U)
  $

+ *终端时刻横截条件*（当 $t_f$ 自由时）：

  $
    lr([H + frac(partial theta, partial t_f) + (frac(partial N, partial t_f))^T nu] |)_(t = t_f) = 0
  $

+ *终端状态横截条件*：

  $
    lambda(t_f) = lr([frac(partial theta, partial x(t_f)) + (frac(partial N, partial x(t_f)))^T nu] |)_(t = t_f)
  $

+ *两端点边界条件*：

  $
    x(t_0) = x_0, quad N[x(t_f), t_f] = 0
  $

=== 解题步骤的原理说明

- *全局极小条件替代古典控制方程*：当容许控制集 $U$ 为有界闭集时，最优控制 $u^*(t)$ 常位于 $U$ 的边界上（如 $H(u)$ 关于 $u$ 线性或单调时），此时边界处控制变分 $delta u$ 无法任意正负取值，且 $frac(partial H, partial u) != 0$（或不要求 $H$ 对 $u$ 可微），故变分法中的 $frac(partial H, partial u) = 0$ 推广为全局极小条件 $min_(u in U) H$。当 $U$ 为开集且 $H$ 对 $u$ 可微时，由 $min_(u in U) H$ 即退化为 $frac(partial H, partial u) = 0$。
- *充分性条件*：极小值原理一般为必要条件；对于*线性系统且性能指标为凸泛函*的问题，极小值原理既是必要条件也是充分条件。

== 其他常见变式（终态自由无约束 $N = 0$）

当终端状态 $x(t_f)$ 自由（无终端等式约束 $N = 0$，即乘子 $nu = 0$）时，不同性能指标类型下的条件简化如下：

=== 终端型（梅耶 Mayer 型：$phi(x, u, t) equiv 0$）

性能指标与哈密顿函数：

$
  J = theta[x(t_f), t_f], quad H(x, u, lambda, t) = lambda^T (t) f[x(t), u(t), t]
$

+ *正则方程*：$dot(x)(t) = frac(partial H, partial lambda) = f[x(t), u(t), t], quad dot(lambda)(t) = -frac(partial H, partial x)$
+ *极小值条件*：$H(x^*, u^*, lambda^*, t) = min_(u in U) H[x^*, u, lambda^*, t]$
+ *终端时刻条件*（$t_f$ 自由时）：$H(x^*, u^*, lambda^*, t_f^*) = -lr(frac(partial theta[x(t), t], partial t_f) |)_(t_f^*)$
+ *协态终值横截条件*：$lambda(t_f) = frac(partial theta[x(t_f)], partial x(t_f))$

=== 积分型（拉格朗日 Lagrange 型：$theta[x(t_f), t_f] equiv 0$）

性能指标与哈密顿函数：

$
  J = integral_(t_0)^(t_f) phi(x, u, t) dif t, quad H(x, u, lambda, t) = phi(x, u, t) + lambda^T (t) f[x(t), u(t), t]
$

+ *正则方程*：$dot(x)(t) = frac(partial H, partial lambda) = f[x(t), u(t), t], quad dot(lambda)(t) = -frac(partial H, partial x)$
+ *极小值条件*：$H(x^*, u^*, lambda^*, t) = min_(u in U) H[x^*, u, lambda^*, t]$
+ *$H$ 沿最优轨线的性质*（当 $H$ 不显含时间 $t$ 时）：
  $
    H(x^*, u^*, lambda^*, t) = cases(
      0 & quad "当" t_f "自由时",
      "const" & quad "当" t_f "固定时",
    )
  $
+ *协态终值横截条件*：$lambda(t_f) = 0$

#figure(
  caption: [不同性能指标类型下的极小值原理汇总（初态 $x(t_0) = x_0$ 给定，终态 $x(t_f)$ 自由）],
  table(
    columns: (auto, auto, auto, auto, auto),
    inset: (x: 4pt, y: 8pt),
    [指标类型], [性能指标 $J$], [哈密顿函数 $H$], [协态终值 $lambda(t_f)$], [$t_f$ 自由时终点条件],

    [综合型（Bolza）],
    [$theta + integral_(t_0)^(t_f) phi dif t$],
    [$phi + lambda^T f$],
    [$frac(partial theta, partial x(t_f))$],
    [$H(t_f) = -frac(partial theta, partial t_f)$],

    [终端型（Mayer）],
    [$theta[x(t_f), t_f]$],
    [$lambda^T f$],
    [$frac(partial theta, partial x(t_f))$],
    [$H(t_f) = -frac(partial theta, partial t_f)$],

    [积分型（Lagrange）], [$integral_(t_0)^(t_f) phi dif t$], [$phi + lambda^T f$], [$0$], [$H(t_f) = 0$],
  ),
)

#pagebreak()
= 典型最优控制问题

== 线性二次型最优控制（LQR 与输出调节器）

考虑线性时变受控系统与二次型性能指标泛函（控制变量无约束 $u(t) in RR^m$）：

$
  dot(x)(t) = A(t) x(t) + B(t) u(t), quad x(t_0) = x_0
$ <线性时变系统>

$
  J = 1 / 2 x^T (t_f) S x(t_f) + 1 / 2 integral_(t_0)^(t_f) [x^T (t) Q(t) x(t) + u^T (t) R(t) u(t)] dif t
$ <LQR指标>

其中终端状态加权阵 $S^T = S >= 0$，状态加权阵 $Q^T (t) = Q(t) >= 0$，控制加权阵 $R^T (t) = R(t) > 0$（对称正定，保证 $R^(-1)(t)$ 存在）。

=== 求解一般步骤

+ *提取系统矩阵与加权矩阵*：
  将状态方程与性能指标化为标准二次型，写出 $A(t), B(t)$ 及对称加权阵 $S, Q(t), R(t)$（交叉项 $2 a x_1 x_2$ 须对称化分配到非对角元）。

+ *列写并求解黎卡提（Riccati）方程求对称正定阵 $P(t)$*：
  - 有限时间状态调节器（黎卡提微分方程与终端条件）：
    $
      dot(P)(t) = -P(t) A(t) - A^T (t) P(t) + P(t) B(t) R^(-1)(t) B^T (t) P(t) - Q(t)\
      quad P(t_f) = S
    $ <黎卡提微分方程>
  - 无限时间定常调节器（$t_f -> +infinity$，退化为黎卡提代数方程 ARE，$P$ 为常值对称正定阵）：
    $
      P A + A^T P - P B R^(-1) B^T P + Q = 0
    $ <黎卡提代数方程>

+ *计算线性状态反馈最优控制律*：

  $
    u^*(t) = -R^(-1)(t) B^T (t) P(t) x(t) = -K(t) x(t)\
    quad K(t) := R^(-1)(t) B^T (t) P(t)
  $ <LQR最优反馈律>

+ *求解最优状态轨线与最优性能指标*：
  - 最优闭环系统状态方程：
    $
      dot(x)^*(t) = [A(t) - B(t) K(t)] x^*(t), quad x^*(t_0) = x_0
    $ <LQR闭环方程>
  - 最优性能指标值：
    $
      J_(min) = 1 / 2 x^T (t_0) P(t_0) x(t_0)
    $

=== 基础典型例题：二阶系统的有限时间状态调节器

设二阶线性系统和二次型性能指标泛函分别为：

$
  dot(x)_1 = x_2, quad dot(x)_2 = u
$

$
  J = 1 / 2 [x_1^2(3) + 2 x_2^2(3)] \
  + 1 / 2 integral_0^3 [2 x_1^2(t) + 4 x_2^2(t) + 2 x_1(t) x_2(t) + 1 / 2 u^2(t)] dif t
$

求最优控制律 $u^*(t)$ 所满足的方程。

解：（$t_0 = 0, t_f = 3$ 的有限时间状态调节器问题）

+ *提取系统矩阵与加权矩阵*（将交叉项 $2 x_1 x_2$ 化为对称阵）：

  $
    A = mat(0, 1; 0, 0), quad B = vec(0, 1), quad S = mat(1, 0; 0, 2), quad Q = mat(2, 1; 1, 4), quad R = 1 / 2
  $

+ *列写黎卡提微分方程与终端条件*：
  设 $2 times 2$ 对称正定阵 $P(t) = mat(p_(11)(t), p_(12)(t); p_(12)(t), p_(22)(t))$，代入 $dot(P) = -P A - A^T P + P B R^(-1) B^T P - Q$：

  $
    mat(dot(p)_(11), dot(p)_(12); dot(p)_(12), dot(p)_(22)) = & -mat(p_(11), p_(12); p_(12), p_(22)) mat(0, 1; 0, 0) - mat(0, 0; 1, 0) mat(p_(11), p_(12); p_(12), p_(22)) \
    & + mat(p_(11), p_(12); p_(12), p_(22)) vec(0, 1) 2 mat(0, 1) mat(p_(11), p_(12); p_(12), p_(22)) - mat(2, 1; 1, 4)
  $

  按对应元素展开，得到关于 $p_(11)(t), p_(12)(t), p_(22)(t)$ 的一阶非线性微分方程组及 $P(3) = S$ 的终端边界条件：

  $
    cases(
      dot(p)_(11)(t) = 2 p_(12)^2(t) - 2,
      dot(p)_(12)(t) = -p_(11)(t) + 2 p_(12)(t) p_(22)(t) - 1,
      dot(p)_(22)(t) = -2 p_(12)(t) + 2 p_(22)^2(t) - 4,
    ), quad cases(
      p_(11)(3) = 1,
      p_(12)(3) = 0,
      p_(22)(3) = 2,
    )
  $

+ *写出最优状态反馈控制律*：

  $
    u^*(t) & = -R^(-1) B^T P(t) x(t) \
           & = -2 mat(0, 1) mat(p_(11)(t), p_(12)(t); p_(12)(t), p_(22)(t)) vec(x_1(t), x_2(t)) \
           & = -2 [p_(12)(t) x_1(t) + p_(22)(t) x_2(t)]
  $

=== 核心定理与步骤原理

+ *构造哈密顿函数并求极值条件*：
  $
    H(x, u, lambda, t) = 1 / 2 x^T Q x + 1 / 2 u^T R u + lambda^T (A x + B u)
  $
  因 $u(t) in RR^m$ 无约束，令一阶偏导为零且检验二阶偏导：
  $
    frac(partial H, partial u) = R(t) u(t) + B^T (t) lambda(t) = 0\
    quad frac(partial^2 H, partial u^2) = R(t) > 0 => u^*(t) = -R^(-1)(t) B^T (t) lambda(t)
  $ <LQR控制与协态关系>

+ *引入 Riccati 变换导出闭环反馈与黎卡提方程*：
  设协态与状态满足线性变换：
  $
    lambda(t) = P(t) x(t)
  $ <协态状态变换>
  代入@LQR控制与协态关系 即得反馈控制律 $u^*(t) = -R^(-1) B^T P x$ 及闭环状态方程 $dot(x) = (A - B R^(-1) B^T P) x$。
  另一方面，由伴随方程与终端横截条件：
  $
    dot(lambda)(t) = -frac(partial H, partial x) = -Q(t) x(t) - A^T (t) lambda(t)\
    quad lambda(t_f) = frac(partial theta, partial x(t_f)) = S x(t_f)
  $
  将 $dot(lambda) = dot(P) x + P dot(x)$ 及闭环状态方程代入伴随方程：
  $
    dot(P) x + P (A - B R^(-1) B^T P) x = -(Q + A^T P) x
  $
  因上式对任意状态轨线 $x(t)$ 恒成立，消去 $x(t)$ 即得黎卡提微分方程@黎卡提微分方程；由 $lambda(t_f) = P(t_f) x(t_f) = S x(t_f)$ 即得边界条件 $P(t_f) = S$。

#figure(
  caption: [LQR 二次型性能指标泛函各项的物理意义],
  table(
    columns: (auto, auto, 230pt),
    [指标分项], [数学表达式], [物理意义与控制作用],
    [终端代价 $J_1$], [$1 / 2 x^T (t_f) S x(t_f)$], [约束终端（稳态）状态误差，使 $t_f$ 时刻状态尽量接近零平衡态],

    [状态误差代价 $J_2$],
    [$1 / 2 integral_(t_0)^(t_f) x^T (t) Q(t) x(t) dif t$],
    [约束动态过程中的状态误差大小，权阵 $Q$ 越大则动态响应越快],

    [控制能量代价 $J_3$],
    [$1 / 2 integral_(t_0)^(t_f) u^T (t) R(t) u(t) dif t$],
    [约束控制能量消耗，防止控制幅值过大（$R > 0$ 正定）],
  ),
)

=== 其他变式与进阶例题（输出调节器与无限时间问题）

当系统输出为 $y(t) = C(t) x(t)$，性能指标以输出误差 $y(t)$ 给出时：

$
  J = 1 / 2 y^T (t_f) S y(t_f) + 1 / 2 integral_(t_0)^(t_f) [y^T (t) Q(t) y(t) + u^T (t) R(t) u(t)] dif t
$

将 $y = C x$ 代入得 $y^T S y = x^T (C^T S C) x, quad y^T Q y = x^T (C^T Q C) x$，即等价于将状态调节器中的 $S, Q$ 分别替换为 $C^T S C, C^T Q C$。

#figure(
  caption: [四类典型线性二次型（LQ）调节器问题对比汇总],
  table(
    columns: (auto, auto, auto, auto),
    inset: (x: 4pt, y: 8pt),
    [调节器类型], [适用前提条件], [矩阵 $P$ 满足的黎卡提方程], [边界 / 定解条件],

    [有限时间状态调节器],
    [$R(t) > 0, Q(t) >= 0, S >= 0$],
    [$dot(P) = -P A - A^T P + P B R^(-1) B^T P - Q$],
    [$P(t_f) = S$],

    [有限时间输出调节器],
    [系统完全可观],
    [$dot(P) = -P A - A^T P + P B R^(-1) B^T P - C^T Q C$],
    [$P(t_f) = C^T (t_f) S C(t_f)$],

    [无限时间定常状态调节器],
    [系统完全可控（$S = 0$）],
    [$P A + A^T P - P B R^(-1) B^T P + Q = 0$],
    [$P = P^T > 0$（唯一正定解）],

    [无限时间定常输出调节器],
    [系统完全可控且完全可观（$S = 0$）],
    [$P A + A^T P - P B R^(-1) B^T P + C^T Q C = 0$],
    [$P = P^T > 0$（唯一正定解）],
  ),
)

==== 变式例题：二阶定常系统的无限时间输出调节器设计

设被控线性定常系统和无限时间性能指标泛函为：

$
  dot(x)(t) = mat(0, 1; 0, 0) x(t) + vec(0, 1) u(t), quad y(t) = mat(1, 0) x(t)
$

$
  J = 1 / 2 integral_0^(+infinity) [y^2(t) + q_2 u^2(t)] dif t, quad (q_2 > 0)
$

求最优控制律 $u^*(t)$ 使 $J$ 最小。

解：

+ *检验可控可观性并提取矩阵*：
  $op("rank") mat(B, A B) = op("rank") mat(0, 1; 1, 0) = 2$，$op("rank") mat(C; C A) = op("rank") mat(1, 0; 0, 1) = 2$，系统完全可控且完全可观。各矩阵为：

  $
    A = mat(0, 1; 0, 0), quad B = vec(0, 1), quad R = q_2, quad Q = 1\
    quad C^T Q C = vec(1, 0) 1 mat(1, 0) = mat(1, 0; 0, 0)
  $

+ *列写并求解黎卡提代数方程（ARE）*：
  设常值对称正定阵 $P = mat(p_(11), p_(12); p_(12), p_(22))$，代入 $P A + A^T P - P B R^(-1) B^T P + C^T Q C = 0$：

  $
    mat(0, p_(11); 0, p_(12)) + mat(0, 0; p_(11), p_(12)) - 1 / q_2 mat(p_(12)^2, p_(12) p_(22); p_(12) p_(22), p_(22)^2) + mat(1, 0; 0, 0) = mat(0, 0; 0, 0)
  $

  展开得代数方程组：

  $
    cases(
      1 / q_2 p_(12)^2 = 1,
      -p_(11) + 1 / q_2 p_(12) p_(22) = 0,
      -2 p_(12) + 1 / q_2 p_(22)^2 = 0,
    )
  $

  由 $P > 0$（要求 $p_(11) > 0, p_(22) > 0, p_(11) p_(22) - p_(12)^2 > 0$），解得唯一正定解：

  $
    p_(12) = sqrt(q_2), quad p_(22) = sqrt(2) q_2^(3 / 4), quad p_(11) = sqrt(2) q_2^(1 / 4)
  $

+ *计算最优状态反馈控制律*：

  $
    u^*(t) & = -R^(-1) B^T P x(t) \
           & = -1 / q_2 [p_(12) x_1(t) + p_(22) x_2(t)] \
           & = -q_2^(-1 / 2) x_1(t) - sqrt(2) q_2^(-1 / 4) x_2(t)
  $

== Bang-Bang 控制与最短时间控制（最速控制）

考虑控制变量受立方体有界闭集约束的线性定常系统最短时间控制问题：

$
  dot(x)(t) = A x(t) + B u(t), quad x(t_0) = x_0, quad x(t_f) = 0 quad (t_f "自由待求")
$ <最短时间系统>

$
  min J = integral_(t_0)^(t_f) 1 dif t = t_f - t_0, quad |u_i (t)| <= 1 quad (i = 1, 2, ..., m)
$

=== 求解一般步骤

+ *构造哈密顿函数*（$theta = 0, phi = 1$）：

  $
    H(x, u, lambda) = 1 + lambda^T (A x + B u) = 1 + lambda^T A x + (B^T lambda)^T u
  $

+ *求解伴随方程确定切换函数*：
  由伴随方程解出协态向量 $lambda(t)$：

  $
    dot(lambda)(t) = -frac(partial H, partial x) = -A^T lambda(t) => lambda(t) = upright(e)^(-A^T t) lambda(0)
  $

+ *由极小值条件确定 Bang-Bang 开关控制律*：
  为使 $H$ 在 $|u_i (t)| <= 1$ 上取全局极小，各控制分量取与切换函数 $B^T lambda(t)$ 符号相反的边界值：

  $
    u^*(t) = -op("sgn")[B^T lambda(t)] = -op("sgn")[B^T upright(e)^(-A^T t) lambda(0)]
  $ <BangBang控制律>

+ *分段积分状态方程求切换时刻与最优轨线*：
  根据开关次数定理确定切换次数，将 $u^* = plus.minus 1$ 分段代入状态方程消去时间 $t$ 得相平面轨线方程，结合初态 $x(t_0) = x_0$ 与终态 $x(t_f) = 0$ 确定开关曲线、切换时刻 $t_1^*$ 及最短时间 $t_f^*$。

=== 基础典型例题：二阶双重积分器系统的最短时间控制

设二阶线性定常系统状态方程与控制约束为：

$
  cases(
    dot(x)_1(t) = x_2(t),
    dot(x)_2(t) = u(t),
  ), quad |u(t)| <= 1
$

求将系统从任意初态 $x(0) = vec(x_(10), x_(20))$ 转移到原点 $x(t_f) = vec(0, 0)$ 的最短时间控制律 $u^*(t)$ 与开关曲线方程。

解：

+ *构造哈密顿函数*：

  $
    H(x, u, lambda) = 1 + lambda_1 x_2 + lambda_2 u
  $

+ *求解伴随方程确定切换函数*：

  $
    cases(
      dot(lambda)_1 = -frac(partial H, partial x_1) = 0,
      dot(lambda)_2 = -frac(partial H, partial x_2) = -lambda_1,
    ) => cases(
      lambda_1(t) = c_1,
      lambda_2(t) = -c_1 t + c_2,
    )
  $

+ *确定 Bang-Bang 最优控制形式与切换次数*：
  由 $min_(|u| <= 1) H$ 得：

  $
    u^*(t) = -op("sgn")[lambda_2(t)] = -op("sgn")(-c_1 t + c_2) = plus.minus 1
  $

  因线性函数 $lambda_2(t) = -c_1 t + c_2$ 至多改变一次符号（或由系统特征值 $s_1 = s_2 = 0$ 为实数，根据开关次数定理），$u^*(t)$ 在 $+1$ 与 $-1$ 之间*至多切换 $2 - 1 = 1$ 次*。

+ *求解相轨线与开关曲线方程*：
  将 $u = plus.minus 1$ 代入状态方程消去 $dif t$：

  $
    frac(dif x_1, dif x_2) = frac(x_2, plus.minus 1) => x_1 = plus.minus 1 / 2 x_2^2 + C
  $

  - 最后一段必经过原点 $(0, 0)$（对应 $C = 0$）：当 $u^* = +1$ 时沿下半支 $x_1 = 1 / 2 x_2^2 quad (x_2 < 0)$ 到达原点；当 $u^* = -1$ 时沿上半支 $x_1 = -1 / 2 x_2^2 quad (x_2 > 0)$ 到达原点。
  - 综合两半支得到相平面上的*开关曲线方程*：
    $
      x_1 + 1 / 2 x_2 |x_2| = 0
    $
  - *闭环最短时间控制律*：
    $
      u^*(x) = cases(
        -1 & quad "当" x_1 + 1 / 2 x_2 |x_2| > 0 "或" (x_1 + 1 / 2 x_2 |x_2| = 0 "且" x_2 > 0),
        +1 & quad "当" x_1 + 1 / 2 x_2 |x_2| < 0 "或" (x_1 + 1 / 2 x_2 |x_2| = 0 "且" x_2 < 0),
      )
    $

=== 核心定理与步骤原理

- *开关控制（Bang-Bang 控制）原理*：在最短时间控制问题中，哈密顿函数 $H$ 关于控制变量 $u$ 是线性的。当容许控制集 $U$ 为有界闭集 $|u_i| <= 1$ 时，$H$ 的全局极小值必在边界 $u_i^* = plus.minus 1$ 处取得，且在两个边界值之间跳变切换，形成最强控制作用。

/ 定理 2(时间最优控制的唯一性): 若线性定常系统@最短时间系统 存在时间最优控制 $u^*(t)$，则该时间最优控制是*唯一的*。

/ 定理 3(开关次数定理): 若 $n$ 阶线性定常系统@最短时间系统 存在时间最优控制 $u^*(t)$ 满足 $|u_i (t)| <= 1 quad (i = 1, 2, ..., m)$，且系统矩阵 $A$ 的 $n$ 个特征值*均为实数*，则每一个控制分量 $u_i^*(t)$ 都是 Bang-Bang 控制，且在两个边界值 $+1$ 与 $-1$ 之间*至多切换 $n - 1$ 次*（即最多分为 $n$ 个常值控制段）。
