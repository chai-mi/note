#import "@preview/fletcher:0.6.0" as fletcher: diagram, edge, node
#import "@preview/note-me:0.6.0"

#import "../template.typ": note
#show: note.with()

= 状态反馈与极点配置

控制系统的*综合问题*是指：已知被控对象的状态空间描述与期望性能指标，设计反馈控制律 $u$ 使闭环系统达到期望特性。考虑线性定常系统：

$
  cases(
    dot(x) = A x + B u,
    y = C x + D u,
  )
$ <线性系统>

其中 $x in RR^n, u in RR^m, y in RR^l$。若控制作用依赖于状态或输出，分别构成*状态反馈控制*与*输出反馈控制*：

$
  u = -K x + r quad "（状态反馈）", quad
  u = -F y + r quad "（输出反馈）"
$ <反馈控制律>

#figure(
  caption: [控制系统综合中常见的五类性能指标与问题类型],
  table(
    columns: (auto, 1fr),
    [综合问题类型], [期望性能指标],
    [镇定问题], [使闭环系统达到渐近稳定],
    [极点配置问题], [将闭环系统极点配置在 $s$ 平面期望位置，以获得期望动态性能],
    [解耦控制问题],
    [使多输入多输出系统实现“一个输入只控制一个输出”（闭环传递阵对角化）],

    [跟踪问题], [使系统输出 $y$ 无静差地跟踪外部参考信号 $y_0 (t)$],
    [最优控制问题], [使含状态 $x$ 与控制 $u$ 的性能指标泛函取极小（或极大）值],
  ),
)

在状态反馈控制律 $u = -K x + r$ 中，$K in RR^(m times n)$ 称为*状态反馈增益矩阵*，$r in RR^m$ 为参考输入（调节问题中常取 $r = 0$）。将其代入 @线性系统 得状态反馈闭环系统方程：

$
  cases(
    dot(x) = (A - B K) x + B r,
    y = (C - D K) x + D r,
  )
$ <状态反馈闭环>

#figure(
  caption: [状态反馈闭环系统结构图],
  diagram(
    node-stroke: 1pt,
    spacing: (26pt, 22pt),
    node((0, 0), $r$, stroke: none),
    edge("-|>", $+$, label-pos: 0.75, label-side: left),
    node((1, 0), $+$, radius: 9pt),
    edge("-|>", $u$),
    node((2, 0), $B$),
    edge("-|>"),
    node((3, 0), $+$, radius: 9pt),
    edge("-|>", $dot(x)$),
    node((4, 0), $integral$),
    edge("rr", "-|>", $x$, label-pos: 0.4),
    node((6, 0), $C$),
    edge("-|>"),
    node((7, 0), $y$, stroke: none),

    // 内部状态反馈 A
    edge((5, 0), (5, 1.15), (4, 1.15), "-|>"),
    node((4, 1.15), $A$),
    edge((4, 1.15), (3, 1.15), (3, 0), "-|>"),

    // 状态反馈通道 K
    edge((5.4, 0), (5.4, 2.25), (3.5, 2.25), "-|>"),
    node((3.5, 2.25), $K$),
    edge((3.5, 2.25), (1, 2.25)),
    edge((1, 2.25), (1, 0), "-|>", $-$, label-pos: 0.82, label-side: right),
  ),
)

当 $D = 0$ 时，闭环系统传递函数阵与特征方程分别为：

$
      G_k (s) & = C [s I - (A - B K)]^(-1) B \
  Delta_c (s) & = det[s I - (A - B K)] = 0
$ <状态反馈特征方程>

状态反馈不增加系统维数，而是通过选择 $K$ 直接改变闭环矩阵 $A - B K$ 的特征值（闭环极点），这一过程称为*极点配置*。

== 单输入系统极点配置

单输入（$m = 1$，$B = b in RR^(n times 1)$，$K in RR^(1 times n)$）线性定常系统极点配置的反馈阵 $K$ *唯一确定*。

=== 求解一般步骤

设计单输入状态反馈矩阵 $K$ 使闭环极点位于 $lambda_1, lambda_2, ..., lambda_n$，先检验系统完全可控（$"rank" Psi_c = "rank" mat(b, A b, ..., A^(n - 1) b) = n$），再按系统阶次选用以下方法：

==== 方法一：直接比较系数法（推荐用于 $n <= 3$ 的低阶系统）

+ 设待求反馈增益行向量 $K = mat(k_1, k_2, ..., k_n)$，展开闭环特征多项式：
  $
    Delta_c (s) = det(s I - A + b K)
  $
+ 根据期望极点写出期望闭环特征多项式：
  $
    a^* (s) = product_(i = 1)^n (s - lambda_i) = s^n + alpha^*_(n - 1) s^(n - 1) + ... + alpha^*_1 s + alpha^*_0
  $ <期望特征多项式>
+ 令 $Delta_c (s) = a^* (s)$，比较 $s$ 各次幂系数，解关于 $k_1, ..., k_n$ 的线性方程组即得 $K$。

==== 方法二：可控标准形变换法（通用标准六步算法）

+ 计算开环系统 $A$ 的特征多项式：
  $
    a(s) = det(s I - A) = s^n + alpha_(n - 1) s^(n - 1) + ... + alpha_1 s + alpha_0
  $
+ 按 @期望特征多项式 计算期望特征多项式 $a^* (s)$ 的系数 $alpha^*_0, alpha^*_1, ..., alpha^*_(n - 1)$；
+ 计算可控标准形下的状态反馈增益阵：
  $
    overline(K) = mat(alpha^*_0 - alpha_0, alpha^*_1 - alpha_1, ..., alpha^*_(n - 1) - alpha_(n - 1))
  $ <标准形反馈阵>
+ 计算化为可控标准形（$overline(A) = P^(-1) A P, overline(b) = P^(-1) b$）的变换阵 $P$：
  $
    P = mat(A^(n - 1) b, A^(n - 2) b, ..., b) mat(
      1, 0, ..., ..., 0;
      alpha_(n - 1), 1, dots.down, , dots.v;
      dots.v, dots.down, dots.down, dots.down, dots.v;
      alpha_2, , dots.down, 1, 0;
      alpha_1, alpha_2, ..., alpha_(n - 1), 1
    )
  $ <可控标准形变换阵>
+ 求变换阵的逆 $P^(-1)$；
+ 还原原系统的状态反馈增益阵：
  $
    K = overline(K) P^(-1)
  $

==== 补充速算：Ackermann（阿克曼）公式

无需显式构造变换阵 $P$，直接由可控性矩阵 $Psi_c = mat(b, A b, ..., A^(n - 1) b)$ 与矩阵多项式 $a^* (A) = A^n + alpha^*_(n - 1) A^(n - 1) + ... + alpha^*_1 A + alpha^*_0 I$ 一步算得：

$
  K = mat(0, 0, ..., 0, 1) Psi_c^(-1) a^* (A)
$ <Ackermann状态反馈>

=== 基础典型例题

==== 例 1（二阶系统直接比较系数法）

已知系统状态方程为

$
  dot(x) = mat(-2, -3; 4, 9) x + vec(3, 1) u
$

试求状态反馈增益矩阵 $K$，使闭环极点配置在 $lambda_(1, 2) = -1 plus.minus j 2$ 处。

解：

+ *检验可控性*：
  $
    Psi_c = mat(b, A b) = mat(3, -9; 1, 21), quad det Psi_c = 72 != 0
  $
  系统完全可控，可任意配置极点。

+ *计算期望特征多项式*：
  $
    a^* (s) = (s + 1 - j 2)(s + 1 + j 2) = s^2 + 2 s + 5
  $

+ *计算闭环特征多项式并比较系数*：
  设 $K = mat(k_1, k_2)$，则
  $
    Delta_c (s) & = mat(
                    s + 2 + 3 k_1, 3 + 3 k_2;
                    -4 + k_1, s - 9 + k_2,
                    delim: "|"
                  ) \
                & = s^2 + (-7 + 3 k_1 + k_2) s + (-6 - 30 k_1 + 14 k_2)
  $
  令 $Delta_c (s) = a^* (s)$，比较同次幂系数：
  $
    cases(
      -7 + 3 k_1 + k_2 = 2,
      -6 - 30 k_1 + 14 k_2 = 5,
    ) => cases(
      3 k_1 + k_2 = 9,
      -30 k_1 + 14 k_2 = 11,
    ) => cases(
      k_1 = 115 / 72,
      k_2 = 101 / 24,
    )
  $
  故所求状态反馈阵为 $K = mat(115 / 72, 101 / 24)$。

==== 例 2（三阶系统可控标准形变换法）

给定单输入线性定常系统：

$
  dot(x) = mat(
    0, 0, 0;
    1, -6, 0;
    0, 1, -12
  ) x + vec(1, 0, 0) u
$

试设计状态反馈矩阵 $K$，使闭环极点为 $lambda_1 = -2, lambda_2 = -1 + j, lambda_3 = -1 - j$。

解：

+ *检验可控性*：
  $
    b = vec(1, 0, 0), quad A b = vec(0, 1, 0), quad A^2 b = vec(0, -6, 1) \
    "rank" Psi_c = "rank" mat(1, 0, 0; 0, 1, -6; 0, 0, 1) = 3
  $
  系统完全可控，满足极点配置条件。

+ *第一步：计算开环特征多项式*：
  $
    a(s) = mat(s, 0, 0; -1, s + 6, 0; 0, -1, s + 12, delim: "|") = s^3 + 18 s^2 + 72 s
  $
  得 $alpha_2 = 18, alpha_1 = 72, alpha_0 = 0$。

+ *第二步：计算期望特征多项式*：
  $
    a^* (s) = (s + 2)(s + 1 - j)(s + 1 + j) = s^3 + 4 s^2 + 6 s + 4
  $
  得 $alpha^*_2 = 4, alpha^*_1 = 6, alpha^*_0 = 4$。

+ *第三步：计算标准形反馈阵 $overline(K)$*：
  $
    overline(K) = mat(alpha^*_0 - alpha_0, alpha^*_1 - alpha_1, alpha^*_2 - alpha_2) = mat(4, -66, -14)
  $

+ *第四步：计算可控标准形变换阵 $P$*：
  $
    P & = mat(A^2 b, A b, b) mat(1, 0, 0; alpha_2, 1, 0; alpha_1, alpha_2, 1) \
      & = mat(0, 0, 1; -6, 1, 0; 1, 0, 0) mat(1, 0, 0; 18, 1, 0; 72, 18, 1)
        = mat(72, 18, 1; 12, 1, 0; 1, 0, 0)
  $

+ *第五步：求逆矩阵 $P^(-1)$*：
  $
    P^(-1) = mat(0, 0, 1; 0, 1, -12; 1, -18, 144)
  $

+ *第六步：计算所求状态反馈增益阵 $K$*：
  $
    K = overline(K) P^(-1) = mat(4, -66, -14) mat(0, 0, 1; 0, 1, -12; 1, -18, 144) = mat(-14, 186, -1220)
  $

=== 核心定理与步骤原理

/ 定理 1（状态反馈对可控性与可观性的影响）: 状态反馈的引入，*不改变系统的可控性*，但*可能改变系统的可观性*。

*证明思路（可控性不变）*：设原系统与闭环系统的可控性矩阵分别为 $Psi_c = mat(B, A B, ..., A^(n - 1) B)$ 与 $Psi_(c K) = mat(B, (A - B K) B, ..., (A - B K)^(n - 1) B)$。因 $(A - B K)^k B$ 的各列均可表为 $mat(B, A B, ..., A^k B)$ 列的线性组合，故 $"rank" Psi_(c K) <= "rank" Psi_c$；反过来将原方程写作 $dot(x) = [(A - B K) + B K] x + B u$，同理可得 $"rank" Psi_c <= "rank" Psi_(c K)$，从而 $"rank" Psi_(c K) = "rank" Psi_c$。

/ 定理 2（极点配置定理）: 采用状态反馈对线性定常系统 @线性系统 任意配置闭环极点的*充分必要条件*是系统*完全可控*。

*证明思路与步骤原理*：
- *必要性（反证法）*：若 $(A, B)$ 不完全可控，按可控性分解存在非奇异阵 $P$ 使
  $
    overline(A) = P^(-1) A P = mat(overline(A)_c, overline(A)_(12); 0, overline(A)_(overline(c))), quad
    overline(B) = P^(-1) B = vec(overline(B)_c, 0)
  $
  记 $overline(K) = K P = mat(overline(K)_1, overline(K)_2)$，则对任意 $K$ 均有
  $
    det(s I - A + B K)
    = det(s I - overline(A)_c + overline(B)_c overline(K)_1) dot det(s I - overline(A)_(overline(c)))
  $
  不可控部分 $overline(A)_(overline(c))$ 的特征值无法被状态反馈改变，故不能任意配置极点，矛盾。
- *充分性（可控标准形构造原理）*：单输入可控系统必可经 $x = P overline(x)$ 化为可控标准形
  $
    overline(A) = mat(
      0, 1, 0, ..., 0;
      dots.v, dots.down, dots.down, dots.down, dots.v;
      0, ..., 0, 0, 1;
      -alpha_0, -alpha_1, ..., -alpha_(n - 2), -alpha_(n - 1)
    ), quad
    overline(b) = vec(0, dots.v, 0, 1)
  $
  引入 $overline(K) = mat(alpha^*_0 - alpha_0, ..., alpha^*_(n - 1) - alpha_(n - 1))$ 后，$overline(b) overline(K)$ 仅修改 $overline(A)$ 的最后一行，使其变为 $(-alpha^*_0, -alpha^*_1, ..., -alpha^*_(n - 1))$，从而 $det(s I - A + b K) = det(s I - overline(A) + overline(b) overline(K)) = a^* (s)$，变换回原坐标系即得 $K = overline(K) P^(-1)$。

==== 例 3（状态反馈破坏可观性）

试分析系统

$
  dot(x) = mat(1, 2; 0, 3) x + vec(0, 1) u, quad y = mat(1, 1) x
$

引入状态反馈 $K = mat(0, 4)$ 与 $K = mat(0, 5)$ 后的可控性与可观性。

解：开环系统可控性与可观性判别阵为：

$
  "rank" mat(b, A b) = "rank" mat(0, 2; 1, 3) = 2 quad "（可控）", \
  "rank" mat(C; C A) = "rank" mat(1, 1; 1, 5) = 2 quad "（可观）"
$

- 当 $K = mat(0, 4)$ 时，$A' = A - b K = mat(1, 2; 0, -1)$：
  $
    "rank" mat(b, A' b) = "rank" mat(0, 2; 1, -1) = 2 quad "（仍可控）", \
    "rank" mat(C; C A') = "rank" mat(1, 1; 1, 1) = 1 < 2 quad "（变为不可观）"
  $
- 当 $K = mat(0, 5)$ 时，$A' = A - b K = mat(1, 2; 0, -2)$：
  $
    "rank" mat(C; C A') = "rank" mat(1, 1; 1, 0) = 2 quad "（仍可观）"
  $

可见状态反馈不改变可控性，但特定 $K$ 值会因闭环零极点对消而破坏系统可观性。

==== 例 4（给定传递函数配置闭环极点与零极点对消）

已知开环传递函数为

$
  G(s) = ((s - 1)(s + 2)) / ((s + 1)(s - 2)(s + 3))
$

求可控标准形实现下的状态反馈增益阵 $K$，使闭环传递函数变为

$
  G_k (s) = (s - 1) / ((s + 2)(s + 3))
$

解：状态反馈只能移动极点、*不能改变系统零点*。为在闭环传递函数中消去零点 $(s + 2)$，必须将一个闭环极点配置在 $s = -2$ 处实现零极点对消（此时该模态变为不可观）。

+ 开环分母特征多项式：
  $
    a(s) = (s + 1)(s - 2)(s + 3) = s^3 + 2 s^2 - 5 s - 6
  $
+ 期望闭环特征多项式（补回被对消的因子 $s + 2$）：
  $
    a^* (s) = (s + 2)(s + 2)(s + 3) = s^3 + 7 s^2 + 16 s + 12
  $
+ 写出开环传递函数的可控标准形实现：
  $
    dot(x) = mat(0, 1, 0; 0, 0, 1; 6, 5, -2) x + vec(0, 0, 1) u, quad y = mat(-2, 1, 1) x
  $
+ 直接由标准形系数差得：
  $
    K = mat(12 - (-6), 16 - (-5), 7 - 2) = mat(18, 21, 5)
  $

== 多输入系统极点配置（并矢设计法）

对于多输入系统（$m > 1$），反馈阵 $K in RR^(m times n)$ 含有 $m n$ 个待定元素，而极点配置只提供 $n$ 个特征多项式系数方程，因此存在 $(m - 1) n$ 个多余*自由度*，满足同一极点配置要求的反馈阵 $K$ *不唯一*，且不同 $K$ 对应的闭环响应模式（特征向量与暂态轨迹）也不同。

工程中常利用*并矢设计法*将反馈阵限定为秩 1 矩阵 $K = f k^T$（仅设计 $n$ 个参数），化为线性方程组直接求解。

=== 求解一般步骤（并矢设计法）

给定完全可控的多输入系统 $dot(x) = A x + B u$（$B in RR^(n times m)$）及期望极点 $lambda_1, ..., lambda_n$：

+ *求开环与期望特征多项式及系数差向量*：
  $
    Delta_o (s) = det(s I - A) = s^n + a_(n - 1) s^(n - 1) + ... + a_1 s + a_0 \
    Delta^*_c (s) = product_(i = 1)^n (s - lambda_i) = s^n + d_(n - 1) s^(n - 1) + ... + d_1 s + d_0 \
    delta = vec(d_0 - a_0, d_1 - a_1, ..., d_(n - 1) - a_(n - 1))
  $ <并矢系数差>
+ *选定列向量 $f$，构造秩 1 反馈阵*：
  设 $K = f k^T$，其中 $f in RR^(m times 1)$ 事先选定，须保证等效单输入对 $(A, B f)$ *完全可控*，$k in RR^(n times 1)$ 为待求向量；
+ *展开伴随向量多项式并提取系数矩阵 $Z$*：
  计算 $"adj"(s I - A) B f in RR^(n times 1)$，将其第 $i$ 个分量按 $s$ 的升幂写成 $N_i (s) = beta_(i 0) + beta_(i 1) s + ... + beta_(i, n - 1) s^(n - 1)$，整理为
  $
    "adj"(s I - A) B f = mat(
      beta_(10), beta_(11), ..., beta_(1, n - 1);
      beta_(20), beta_(21), ..., beta_(2, n - 1);
      dots.v, dots.v, dots.down, dots.v;
      beta_(n 0), beta_(n 1), ..., beta_(n, n - 1)
    ) vec(1, s, dots.v, s^(n - 1)) = Z^T vec(1, s, dots.v, s^(n - 1))
  $ <并矢伴随矩阵>
  即 $Z$ 为上述多项式系数矩阵的*转置*；
+ *求解 $k$ 并构造 $K$*：
  由 $Z k = delta$ 解出 $k = Z^(-1) delta$，从而得到
  $
    K = f k^T = f delta^T Z^(-T)
  $ <并矢公式>

=== 典型例题

==== 例 5（多输入系统极点配置的非唯一性）

已知两输入线性定常系统 $dot(x) = A x + B u$，其中

$
  A = mat(-0.01, 0; 0, -0.02), quad B = mat(1, 1; -0.25, 0.75)
$

试求反馈阵 $K$，使闭环期望特征多项式为 $Delta^*_c (s) = s^2 + 0.2050 s + 0.01295$（对应极点约 $-0.1025 plus.minus j 0.0494$）。

解：系统完全可控。设 $K = mat(k_(11), k_(12); k_(21), k_(22))$，计算闭环特征多项式：

$
  Delta_c (s) & = det(s I - A + B K) \
              & = s^2 + (0.03 + k_(11) - 0.25 k_(12) + k_(21) + 0.75 k_(22)) s \
              & quad + 0.0002 + 0.02 k_(11) - 0.0025 k_(12) + 0.02 k_(21) \
              & quad + 0.0075 k_(22) + k_(11) k_(22) - k_(12) k_(21)
$

令 $Delta_c (s) = Delta^*_c (s)$，得含 4 个未知数、2 个方程的欠定方程组：

$
  cases(
    k_(11) - 0.25 k_(12) + k_(21) + 0.75 k_(22) = 0.175,
    0.02 k_(11) - 0.0025 k_(12) + 0.02 k_(21) + 0.0075 k_(22),
    quad + k_(11) k_(22) - k_(12) k_(21) = 0.01275,
  )
$

该方程组有无穷多组解，例如以下三组反馈阵均满足相同的闭环极点要求：

$
  K_I = mat(1.1, 3.7; 0, 0), quad
  K_(I I) = mat(0, 0; 1.1, -37 / 30), quad
  K_(I I I) = mat(0.1, 0; 0, 0.1)
$

尽管三者具有完全相同的闭环特征方程，但因闭环矩阵 $A - B K$ 不同，在相同初态下产生的状态暂态响应曲线各不相同。

==== 例 6（三阶双输入系统并矢设计法）

已知线性定常系统：

$
  dot(x) = mat(
    -2, 1, 2;
    -1, -2, 2;
    -2, 0, 2
  ) x + mat(
    0, 0;
    1, 0;
    0, 1
  ) u
$

试求状态反馈增益阵 $K$，使闭环极点全部配置在 $\{-2, -2, -2\}$。

解：

+ *检验可控性*：
  $
    Psi_c = mat(B, A B, A^2 B) = mat(
      0, 0, 1, 2, -4, 2;
      1, 0, -2, 2, 3, -2;
      0, 1, 0, 2, -2, 0
    ), quad "rank" Psi_c = 3
  $
  系统完全可控。

+ *计算开环、期望特征多项式及系数差向量 $delta$*：
  $
    Delta_o (s) = det(s I - A) = s^3 + 2 s^2 + s + 2 \
    Delta^*_c (s) = (s + 2)^3 = s^3 + 6 s^2 + 12 s + 8 \
    delta = vec(8 - 2, 12 - 1, 6 - 2) = vec(6, 11, 4)
  $

+ *选定 $f$ 并计算 $"adj"(s I - A) B f$*：
  取 $f = vec(1, 1)$，则 $B f = vec(0, 1, 1)$（易验 $"rank" mat(B f, A B f, A^2 B f) = 3$，可控）。由
  $
    s I - A = mat(s + 2, -1, -2; 1, s + 2, -2; 2, 0, s - 2)
  $
  求伴随矩阵：
  $
    "adj"(s I - A) = mat(
      s^2 - 4, s - 2, 2(s + 3);
      -(s + 2), s^2, 2(s + 1);
      -2(s + 2), -2, s^2 + 4 s + 5
    )
  $
  右乘 $B f = vec(0, 1, 1)$ 并按升幂整理：
  $
    "adj"(s I - A) B f = vec(3 s + 4, s^2 + 2 s + 2, s^2 + 4 s + 3) = mat(
      4, 3, 0;
      2, 2, 1;
      3, 4, 1
    ) vec(1, s, s^2)
  $

+ *求矩阵 $Z, Z^(-1)$ 与向量 $k$*：
  $
    Z = mat(4, 3, 0; 2, 2, 1; 3, 4, 1)^T = mat(4, 2, 3; 3, 2, 4; 0, 1, 1)
    ==> Z^(-1) = -1 / 5 mat(-2, 1, 2; -3, 4, -7; 3, -4, 2)
  $
  $
    k = Z^(-1) delta = -1 / 5 mat(-2, 1, 2; -3, 4, -7; 3, -4, 2) vec(6, 11, 4) = -1 / 5 vec(7, -2, -18)
  $

+ *计算状态反馈增益矩阵 $K$*：
  $
    K = f k^T = vec(1, 1) dot (-1 / 5) mat(7, -2, -18) = 1 / 5 mat(-7, 2, 18; -7, 2, 18)
  $

+ *验算*：
  $
    det[s I - (A - B K)] & = 1 / 125 mat(
                             5 s + 10, -5, -10;
                             -2, 5 s + 12, 8;
                             3, 2, 5 s + 8,
                             delim: "|"
                           ) \
                         & = s^3 + 6 s^2 + 12 s + 8 = (s + 2)^3
  $
  验证无误。

=== 并矢设计法推导原理与方法对比

利用矩阵行列式引理 $det(I_n + u v^T) = 1 + v^T u$，将 $K = f k^T$ 代入闭环特征多项式：

$
  Delta_c (s) & = det(s I - A + B f k^T) \
              & = det(s I - A) dot det[I + (s I - A)^(-1) B f k^T] \
              & = det(s I - A) dot [1 + k^T (s I - A)^(-1) B f] \
              & = det(s I - A) + k^T "adj"(s I - A) B f
$

移项即得 $k^T "adj"(s I - A) B f = Delta^*_c (s) - Delta_o (s) = delta^T vec(1, s, ..., s^(n - 1))$。将 @并矢伴随矩阵 代入并比较多项式各项系数，立即得到 $k^T Z^T = delta^T <==> Z k = delta$。

#figure(
  caption: [单输入与多输入系统极点配置方法对比],
  table(
    columns: (auto, auto, 1.1fr, auto),
    [设计方法], [适用范围], [核心公式], [解的唯一性],
    [直接比较系数法],
    [单输入，$n <= 3$],
    [比较 $det(s I - A + b K) = a^* (s)$ 同次幂系数],
    [唯一],

    [可控标准形法],
    [单输入，任意阶],
    [$K = overline(K) P^(-1)$，$overline(K) = mat(alpha^*_0 - alpha_0, ...)$],
    [唯一],

    [Ackermann 公式],
    [单输入，任意阶],
    [$K = mat(0, ..., 0, 1) Psi_c^(-1) a^* (A)$],
    [唯一],

    [并矢设计法],
    [多输入，任意阶],
    [选 $f$ 使 $(A, B f)$ 可控，$K = f delta^T Z^(-T)$],
    [不唯一（取决于 $f$）],
  ),
)

#pagebreak()
= 状态观测器设计

构造状态反馈控制律的前提是全部状态变量可直接测量。当部分或全部状态无法直接测量时，可利用系统可测的输入 $u$ 和输出 $y$ 构造一个物理可实现的动态系统 $hat(Sigma)$，使其输出（估计状态）$hat(x)$ 渐近收敛于真实状态 $x$（即 $lim_(t -> infinity) norm(x(t) - hat(x)(t)) = 0$），该动态系统称为*状态观测器*（Luenberger 观测器）。

若仅复制原系统模型构造*$n$ 维开环观测器* $dot(hat(x)) = A hat(x) + B u$，其估计误差满足 $x(t) - hat(x)(t) = upright(e)^(A t) [x(0) - hat(x)(0)]$，仅当初态严格相等时才无误差，且对扰动与参数摄动敏感、不稳定对象不可用。因此实用中均采用引入输出误差校正的*闭环渐近观测器*。

== 全维（$n$ 维）渐近状态观测器

对线性定常系统（设 $D = 0$）

$
  cases(
    dot(x) = A x + B u,
    y = C x,
  )
$ <观测对象>

利用输出估计误差 $(y - hat(y))$ 经 $n times l$ 维反馈增益矩阵 $G$ 校正观测器，得到*全维渐近状态观测器*：

$
  cases(
    dot(hat(x)) = A hat(x) + B u + G (y - hat(y)) = (A - G C) hat(x) + B u + G y,
    hat(y) = C hat(x),
  )
$ <全维观测器>

#figure(
  caption: [全维渐近状态观测器结构图],
  diagram(
    node-stroke: 1pt,
    spacing: (24pt, 20pt),
    // 被控对象（上行）
    node((0, 0), $u$, stroke: none),
    edge((0, 0), (1.3, 0), "-|>"),
    node((1.3, 0), $B$),
    edge("-|>"),
    node((2.4, 0), $+$, radius: 8.5pt),
    edge("-|>", $dot(x)$),
    node((3.6, 0), $integral$),
    edge((3.6, 0), (5.8, 0), "-|>", $x$, label-pos: 0.35),
    node((5.8, 0), $C$),
    edge((5.8, 0), (7.4, 0), "-|>", $y$, label-pos: 0.72),
    node((7.4, 0), [], stroke: none),

    // 被控对象内部 A
    edge((4.8, 0), (4.8, 1.05), (3.6, 1.05), "-|>"),
    node((3.6, 1.05), $A$),
    edge((3.6, 1.05), (2.4, 1.05), (2.4, 0), "-|>"),

    // 观测器输入分支 u
    edge((0.55, 0), (0.55, 3.35), (1.3, 3.35), "-|>"),

    // 全维状态观测器（下行）
    node((1.3, 3.35), $B$),
    edge("-|>"),
    node((2.4, 3.35), $+$, radius: 8.5pt),
    edge("-|>", $dot(hat(x))$),
    node((3.6, 3.35), $integral$),
    edge((3.6, 3.35), (5.8, 3.35), "-|>", $hat(x)$, label-pos: 0.35),
    node((5.8, 3.35), $C$),
    edge((5.8, 3.35), (6.8, 3.35)),
    edge(
      (6.8, 3.35),
      (6.8, 2.25),
      "-|>",
      $-$,
      label-pos: 0.72,
      label-side: right,
    ),

    // 观测器内部 A
    edge((4.8, 3.35), (4.8, 4.4), (3.6, 4.4), "-|>"),
    node((3.6, 4.4), $A$),
    edge((3.6, 4.4), (2.4, 4.4), (2.4, 3.35), "-|>"),

    // 输出误差比较与校正通道 G
    edge(
      (6.8, 0),
      (6.8, 2.25),
      "-|>",
      $+$,
      label-pos: 0.85,
      label-side: right,
    ),
    node((6.8, 2.25), $+$, radius: 8.5pt),
    edge((6.8, 2.25), (3.6, 2.25), "-|>", $y - hat(y)$, label-pos: 0.45),
    node((3.6, 2.25), $G$),
    edge((3.6, 2.25), (2.4, 2.25), (2.4, 3.35), "-|>"),

    // 观测器虚线外框
    node(
      enclose: ((1.3, 2.25), (5.8, 4.4), (6.8, 2.25)),
      stroke: (paint: rgb("#2563eb"), dash: "dashed", thickness: 0.9pt),
      inset: 11pt,
      corner-radius: 4pt,
      fill: rgb("#dbeafe").transparentize(85%),
      layer: -1,
    ),
    node(
      (4.0, 5.25),
      text(size: 11pt, fill: rgb("#1d4ed8"))[全维渐近状态观测器],
      stroke: none,
    ),
  ),
)

=== 求解一般步骤

设计全维观测器增益阵 $G$ 使观测器极点位于 $mu_1, mu_2, ..., mu_n$，先检验系统完全可观（$"rank" Psi_o = "rank" mat(C; C A; dots.v; C A^(n - 1)) = n$），再选用以下方法之一：

==== 方法一：对偶系统极点配置法（通用标准三步）

+ 导出原系统的对偶系统矩阵对 $(A^*, B^*) = (A^T, C^T)$；
+ 将 $(A^*, B^*)$ 视作状态反馈系统，利用第 1 节的极点配置算法求出反馈矩阵 $K$，使
  $
    det(s I - A^* + B^* K) = product_(i = 1)^n (s - mu_i) = alpha^* (s)
  $
+ 取转置即得观测器增益矩阵：
  $
    G = K^T
  $ <对偶观测器公式>

==== 方法二：直接比较系数法（推荐用于 $n <= 3$ 的低阶单输出系统）

+ 设待求列向量 $G = vec(g_1, g_2, ..., g_n)$，计算观测器特征多项式：
  $
    Delta_o (s) = det[s I - (A - G C)]
  $
+ 根据期望极点写出期望特征多项式 $alpha^* (s) = product_(i = 1)^n (s - mu_i)$；
+ 令 $Delta_o (s) = alpha^* (s)$，比较同次幂系数，解线性方程组求得 $G$。

==== 补充速算：Ackermann（阿克曼）观测器公式（单输出 $C = c$）

$
  G = alpha^* (A) Psi_o^(-1) vec(0, dots.v, 0, 1), quad
  Psi_o = mat(c; c A; dots.v; c A^(n - 1))
$ <Ackermann观测器>

=== 基础典型例题

==== 例 1（三阶系统全维观测器：对偶法与直接法双解）

已知系统状态空间表达式为

$
  dot(x) = mat(
    1, 0, 0;
    0, 2, 1;
    0, 0, 2
  ) x + vec(1, 0, 1) u, quad
  y = mat(1, 1, 0) x
$

要求设计全维状态观测器，使其期望特征值为 $-3, -4, -5$。

解：先判断系统可观性：

$
  C = mat(1, 1, 0), quad
  C A = mat(1, 2, 1), quad
  C A^2 = mat(1, 4, 4) \
  "rank" Psi_o = "rank" mat(1, 1, 0; 1, 2, 1; 1, 4, 4) = 3
$

系统完全可观，可任意配置观测器极点。期望特征多项式为：

$
  alpha^* (s) = (s + 3)(s + 4)(s + 5) = s^3 + 12 s^2 + 47 s + 60
$

*解法一（对偶系统极点配置法）*：

+ 导出对偶系统矩阵对：
  $
    A^* = A^T = mat(1, 0, 0; 0, 2, 0; 0, 1, 2), quad
    B^* = C^T = vec(1, 1, 0)
  $
+ 开环特征多项式为 $a(s) = det(s I - A^*) = (s - 1)(s - 2)^2 = s^3 - 5 s^2 + 8 s - 4$，故 $alpha_2 = -5, alpha_1 = 8, alpha_0 = -4$，标准形增益阵为：
  $
    overline(K) = mat(60 - (-4), 47 - 8, 12 - (-5)) = mat(64, 39, 17)
  $
+ 计算对偶系统的可控标准形变换阵 $P$ 与 $P^(-1)$（利用 $A^* B^* = vec(1, 2, 1), (A^*)^2 B^* = vec(1, 4, 4)$）：
  $
    P & = mat((A^*)^2 B^*, A^* B^*, B^*) mat(1, 0, 0; -5, 1, 0; 8, -5, 1) \
      & = mat(1, 1, 1; 4, 2, 1; 4, 1, 0) mat(1, 0, 0; -5, 1, 0; 8, -5, 1)
        = mat(4, -4, 1; 2, -3, 1; -1, 1, 0)
  $
  $
    P^(-1) = mat(1, -1, 1; 1, -1, 2; 1, 0, 4)
  $
+ 求 $K$ 并转置得 $G$：
  $
    K = overline(K) P^(-1) = mat(64, 39, 17) mat(1, -1, 1; 1, -1, 2; 1, 0, 4) = mat(120, -103, 210) \
    ==> G = K^T = vec(120, -103, 210)
  $

*解法二（直接比较系数法）*：

设 $G = vec(g_1, g_2, g_3)$，展开观测器特征多项式：

$
  Delta_o (s) & = det[s I - (A - G C)]
                = mat(
                  s - 1 + g_1, g_1, 0;
                  g_2, s - 2 + g_2, -1;
                  g_3, g_3, s - 2,
                  delim: "|"
                ) \
              & = s^3 + (g_1 + g_2 - 5) s^2 + (-4 g_1 - 3 g_2 + g_3 + 8) s \
              & quad + (4 g_1 + 2 g_2 - g_3 - 4)
$

与 $alpha^* (s) = s^3 + 12 s^2 + 47 s + 60$ 比较系数：

$
  cases(
    g_1 + g_2 - 5 = 12,
    -4 g_1 - 3 g_2 + g_3 + 8 = 47,
    4 g_1 + 2 g_2 - g_3 - 4 = 60,
  ) ==> G = vec(120, -103, 210)
$

==== 例 2（二阶系统全维观测器与观测器方程）

已知系统状态空间表达式为

$
  cases(
    dot(x) = mat(-5, -1; 6, 0) x + vec(0, 2) u,
    y = mat(0, 1) x,
  )
$

试设计全维状态观测器，将观测器极点配置在 $mu_(1, 2) = -10 plus.minus j 10$ 处。

解：

+ *判别可观性*：
  $
    Psi_o = mat(c; c A) = mat(0, 1; 6, 0), quad "rank" Psi_o = 2
  $
  系统完全可观。

+ *计算期望特征多项式*：
  $
    alpha^* (s) = (s + 10 - j 10)(s + 10 + j 10) = s^2 + 20 s + 200
  $

+ *设 $G = vec(g_1, g_2)$ 并比较系数*：
  $
    Delta_o (s) = mat(s + 5, 1 + g_1; -6, s + g_2, delim: "|")
    = s^2 + (5 + g_2) s + (5 g_2 + 6 + 6 g_1)
  $
  $
    cases(
      5 + g_2 = 20,
      5 g_2 + 6 + 6 g_1 = 200,
    ) ==> cases(
      g_1 = 31 / 3,
      g_2 = 15,
    )
  $

+ *写出全维状态观测器方程*：
  $
    dot(hat(x)) = (A - G c) hat(x) + B u + G y
    = mat(-5, -34 / 3; 6, -15) hat(x) + vec(0, 2) u + vec(31 / 3, 15) y
  $

=== 核心定理、对偶原理与极点选取原则

定义状态估计误差 $tilde(x) = x - hat(x)$。将原系统 @观测对象 与观测器 @全维观测器 相减，得误差动态方程及其解：

$
  dot(tilde(x)) = (A - G C) tilde(x) ==> tilde(x)(t) = upright(e)^((A - G C) t) tilde(x)(0)
$ <观测器误差方程>

只要 $A - G C$ 的全部特征值均具负实部，对任意初始误差 $tilde(x)(0)$ 均有 $lim_(t -> infinity) tilde(x)(t) = 0$。

/ 定理 3（全维渐近观测器存在定理）: 对线性定常系统 @观测对象：\ (1) 存在渐近观测器 @全维观测器 的充要条件是 $(C, A)$ *可检测*（即不可观子系统渐近稳定）；\ (2) 存在渐近观测器且观测器极点可任意配置的充要条件是 $(C, A)$ *完全可观*。

*对偶原理*：由矩阵转置不改变行列式的值，有

$
  det[s I - (A - G C)] = det[s I - (A^T - C^T G^T)]
$

因此，设计 $(A, C)$ 的观测器增益阵 $G$ 与设计对偶系统 $(A^T, C^T)$ 的状态反馈阵 $K = G^T$ 在数学上完全等价。

#note-me.note[
  *观测器极点的工程选取原则*：
  - *足够快*：为使估计误差 $tilde(x)(t)$ 迅速衰减，观测器极点实部应比状态反馈闭环主导极点更负，通常取观测器响应速度比闭环系统快 *$2 tilde 5$ 倍*；
  - *不宜过远*：极点离虚轴过远会导致增益 $G$ 过大、系统带宽过宽，从而显著放大高频测量噪声。
]

== 降维（$n - l$ 维）状态观测器（Luenberger 最小阶观测器）

若输出矩阵 $C in RR^(l times n)$ 行满秩（$"rank" C = l$），则输出 $y = C x$ 本身已直接提供 $l$ 个线性独立的状态信息，只需设计一个 *$n - l$ 维*（最小阶）观测器来重构其余 $n - l$ 个状态分量，可节省积分器并避免重复估计。

通过非奇异变换 $x = T overline(x)$ 使 $overline(C) = C T = mat(0, I_l)$，原系统化为分块形式：

$
  cases(
    vec(dot(overline(x))_1, dot(overline(x))_2) = mat(overline(A)_(11), overline(A)_(12); overline(A)_(21), overline(A)_(22)) vec(overline(x)_1, overline(x)_2) + vec(overline(B)_1, overline(B)_2) u,
    y = mat(0, I_l) vec(overline(x)_1, overline(x)_2) = overline(x)_2,
  )
$ <降维分块方程>

#figure(
  caption: [经线性变换 $x = T overline(x)$ 分解后的系统结构（上为待重构子系统，下为可直接测量部分）],
  diagram(
    node-stroke: 1pt,
    spacing: (24pt, 20pt),
    // 输入 u
    node((0, 1.55), $u$, stroke: none),
    edge((0, 1.55), (0.6, 1.55), (0.6, 0), (1.3, 0), "-|>"),
    edge((0.6, 1.55), (0.6, 3.1), (1.3, 3.1), "-|>"),

    // 上支路：待重构状态 x_1 (n-l 维)
    node((1.3, 0), $overline(B)_1$),
    edge("-|>"),
    node((2.4, 0), $+$, radius: 8.5pt),
    edge("-|>", $dot(overline(x))_1$),
    node((3.6, 0), $integral$),
    edge((3.6, 0), (5.8, 0), "-|>", $overline(x)_1$, label-pos: 0.28),
    node((5.8, 0), [], stroke: none),

    // A11 反馈
    edge((4.95, 0), (4.95, -1.05), (3.6, -1.05), "-|>"),
    node((3.6, -1.05), $overline(A)_(11)$),
    edge((3.6, -1.05), (2.4, -1.05), (2.4, 0), "-|>"),

    // 耦合通道 A12 (x2 -> x1) 与 A21 (x1 -> x2)
    edge((5.45, 3.1), (5.45, 1.05), (3.6, 1.05), "-|>"),
    node((3.6, 1.05), $overline(A)_(12)$),
    edge((3.6, 1.05), (2.4, 1.05), (2.4, 0), "-|>"),

    edge((4.95, 0), (4.95, 2.05), (3.6, 2.05), "-|>", snap-to: (none, auto)),
    node((3.6, 2.05), $overline(A)_(21)$),
    edge((3.6, 2.05), (2.4, 2.05), (2.4, 3.1), "-|>"),

    // 下支路：可直接测量状态 x_2 = y (l 维)
    node((1.3, 3.1), $overline(B)_2$),
    edge("-|>"),
    node((2.4, 3.1), $+$, radius: 8.5pt),
    edge("-|>", $dot(overline(x))_2$),
    node((3.6, 3.1), $integral$),
    edge((3.6, 3.1), (7.0, 3.1), "-|>", $overline(x)_2 = y$, label-pos: 0.78),
    node((7.0, 3.1), [], stroke: none),

    // A22 反馈
    edge((4.95, 3.1), (4.95, 4.15), (3.6, 4.15), "-|>"),
    node((3.6, 4.15), $overline(A)_(22)$),
    edge((3.6, 4.15), (2.4, 4.15), (2.4, 3.1), "-|>"),

    // 待重构子系统虚线框
    node(
      enclose: ((1.3, -1.05), (5.15, 0.3)),
      stroke: (paint: rgb("#dc2626"), dash: "dashed", thickness: 0.9pt),
      inset: 10pt,
      corner-radius: 4pt,
      fill: rgb("#fee2e2").transparentize(85%),
      layer: -1,
    ),
    node(
      (6.45, -0.55),
      text(size: 10.5pt, fill: rgb("#b91c1c"))[待重构子系统\ （$n - l$ 维）],
      stroke: none,
    ),
    node(
      (6.45, 3.95),
      text(size: 10.5pt, fill: rgb("#047857"))[可直接测量部分\ （$l$ 维）],
      stroke: none,
    ),
  ),
)

=== 求解一般步骤（坐标变换分解法）

+ *分块化简*：若原系统不满足 $C = mat(0, I_l)$，先选非奇异阵 $T$（使 $C T = mat(0, I_l)$）将系统化为 @降维分块方程，读出子块 $overline(A)_(11), overline(A)_(12), overline(A)_(21), overline(A)_(22), overline(B)_1, overline(B)_2$；
+ *配置 $(n - l)$ 维子系统极点求 $overline(G)$*：将 $(overline(A)_(11), overline(A)_(21))$ 视作 $(n - l)$ 维可观对，按全维观测器设计方法求增益阵 $overline(G) in RR^((n - l) times l)$，使
  $
    det[s I_(n - l) - (overline(A)_(11) - overline(G) overline(A)_(21))] = alpha^*_r (s)
  $
+ *写出无微分项的降维观测器方程与状态重构式*：引入辅助状态 $z = hat(overline(x))_1 - overline(G) y$，直接代入模板得：
  $
    cases(
      dot(z) = (overline(A)_(11) - overline(G) overline(A)_(21)) z
      + (overline(B)_1 - overline(G) overline(B)_2) u,
      quad quad + [(overline(A)_(11) - overline(G) overline(A)_(21)) overline(G) + overline(A)_(12) - overline(G) overline(A)_(22)] y,
      hat(overline(x))_1 = z + overline(G) y,
      hat(overline(x)) = vec(hat(overline(x))_1, y) = vec(I_(n - l), 0) z + vec(overline(G), I_l) y,
    )
  $ <降维观测器模板>
+ *反变换回原状态（若作过变换 $T$）*：$hat(x) = T hat(overline(x))$。

=== 基础典型例题

==== 例 3（二阶系统设计一维降维观测器）

对全维观测器例 2 中的二阶系统

$
  cases(
    dot(x) = mat(-5, -1; 6, 0) x + vec(0, 2) u,
    y = mat(0, 1) x,
  )
$

试设计 1 维降维状态观测器，将其极点配置在 $mu = -10$ 处。

解：

+ *分块读取参数*：输出矩阵 $C = mat(0, 1)$ 已是标准分块形式（无需变换，$T = I$，$x_2 = y$ 直接可测，仅需估计 $x_1$），得
  $
    A_(11) = -5, quad A_(12) = -1, quad A_(21) = 6, quad A_(22) = 0, quad
    B_1 = 0, quad B_2 = 2
  $
+ *配置降维观测器极点求 $overline(G)$*：
  令 $A_(11) - overline(G) A_(21) = -5 - 6 overline(G) = -10$，解得 $overline(G) = 5 / 6$。
+ *代入模板 @降维观测器模板 计算各系数*：
  $
    (A_(11) - overline(G) A_(21)) overline(G) + A_(12) - overline(G) A_(22)
    = (-10)(5 / 6) + (-1) - 0 = -28 / 3 \
    B_1 - overline(G) B_2 = 0 - (5 / 6) dot 2 = -5 / 3
  $
+ *写出降维状态观测器方程*：
  $
    cases(
      dot(z) = -10 z - 28 / 3 y - 5 / 3 u,
      hat(x)_1 = z + 5 / 6 y,
      hat(x) = vec(hat(x)_1, y) = vec(1, 0) z + vec(5 / 6, 1) y,
    )
  $

=== 推导原理与另一直接设计定理

*消除微分项 $dot(y)$ 与误差收敛推导*：由 @降维分块方程 拆出关于 $overline(x)_1$ 的等效子系统（视 $overline(y) = dot(y) - overline(A)_(22) y - overline(B)_2 u = overline(A)_(21) overline(x)_1$ 为虚拟输出），若原系统完全可观则 $(overline(A)_(11), overline(A)_(21))$ 亦完全可观，构造其观测器：

$
  dot(hat(overline(x)))_1 = (overline(A)_(11) - overline(G) overline(A)_(21)) hat(overline(x))_1
  + (overline(B)_1 - overline(G) overline(B)_2) u
  + (overline(A)_(12) - overline(G) overline(A)_(22)) y
  + overline(G) dot(y)
$

为避免对含噪输出 $y$ 求导，将 $overline(G) dot(y)$ 移至左端并令 $z = hat(overline(x))_1 - overline(G) y$（即 $dot(z) = dot(hat(overline(x)))_1 - overline(G) dot(y)$），代入整理即得无微分项的 @降维观测器模板。其估计误差 $tilde(overline(x))_1 = overline(x)_1 - hat(overline(x))_1$ 满足

$
  dot(tilde(overline(x)))_1 = (overline(A)_(11) - overline(G) overline(A)_(21)) tilde(overline(x))_1
$

故只需配置 $overline(A)_(11) - overline(G) overline(A)_(21)$ 的 $n - l$ 个极点即可任意控制收敛速度。

/ 定理 4（最小维观测器的直接矩阵方程判据）: 若以 $u(t), y(t)$ 为输入构造 $(n - l)$ 维线性系统
  $
    cases(
      dot(z) = D z + G y + H u,
      hat(x) = K_1 y + K_2 z,
    )
  $
  则其为原系统 @观测对象 最小维状态观测器的*充要条件*是：\ (1) 存在矩阵 $L in RR^((n - l) times n)$ 使 $mat(C; L)$ 可逆，且满足 Sylvester 型方程与输入条件：
  $
    mat(D, G; K_2, K_1) mat(L; C) = mat(L A; I), quad H = L B
  $
  (2) 矩阵 $D$ 的全部特征值实部均为负（此时 $z(t)$ 渐近跟踪 $L x(t)$）。

#figure(
  caption: [三类状态观测器特性对比],
  table(
    columns: (auto, auto, 1.1fr, 1fr),
    [观测器类型], [维数], [误差动态与收敛条件], [工程特点],
    [开环观测器],
    [$n$],
    [$dot(tilde(x)) = A tilde(x)$，要求 $A$ 渐近稳定且初值一致],
    [未利用输出 $y$，无抗扰能力，无实用价值],

    [全维渐近观测器],
    [$n$],
    [$dot(tilde(x)) = (A - G C) tilde(x)$，$(C, A)$ 可观可任配极点],
    [结构规范、设计直接，但需 $n$ 个积分器且重复估计可测状态],

    [降维状态观测器],
    [$n - l$],
    [$dot(tilde(overline(x)))_1 = (overline(A)_(11) - overline(G) overline(A)_(21)) tilde(overline(x))_1$],
    [维数最小、硬件成本低，通过 $z = hat(overline(x))_1 - overline(G) y$ 避免对 $y$ 求导],
  ),
)

#pagebreak()
= 带有状态观测器的状态反馈系统

当真实状态 $x$ 不可直接测量时，用状态观测器的估计值 $hat(x)$ 代替真实状态构成反馈控制律：

$
  u = -K hat(x) + r
$ <估值状态反馈>

将其联立代入被控对象 $dot(x) = A x + B u, y = C x$ 与全维状态观测器 $dot(hat(x)) = (A - G C) hat(x) + B u + G y$，即组成 $2 n$ 维复合闭环系统：

$
  cases(
    vec(dot(x), dot(hat(x))) = mat(
      A, -B K;
      G C, A - G C - B K
    ) vec(x, hat(x)) + vec(B, B) r,
    y = mat(C, 0) vec(x, hat(x)),
  )
$ <复合闭环方程>

#figure(
  caption: [带有状态观测器的状态反馈复合闭环系统结构图],
  diagram(
    node-stroke: 1pt,
    spacing: (24pt, 22pt),
    // 节点
    node((0, 0), $r$, stroke: none),
    node((1, 0), $+$, radius: 8.5pt, name: <sum>),
    node(
      (4.5, 0),
      [被控对象 $Sigma_0$\ $(A, B, C)$],
      inset: 8pt,
      corner-radius: 3pt,
      name: <plant>,
    ),
    node((8.0, 0), [], stroke: none),
    node(
      (4.5, 1.85),
      [状态观测器 $hat(Sigma)$\ $(A - G C, B, G)$],
      inset: 8pt,
      corner-radius: 3pt,
      fill: rgb("#dbeafe").transparentize(70%),
      name: <obs>,
    ),
    node((2.6, 3.35), $K$, name: <k>),

    // 连线
    edge((0, 0), <sum>, "-|>", $+$, label-pos: 0.75, label-side: left),
    edge(<sum>, <plant>, "-|>", $u$, label-pos: 0.32),
    edge(<plant>, (8.0, 0), "-|>", $y$, label-pos: 0.72),
    edge((2.0, 0), (2.0, 1.85), <obs>, "-|>"),
    edge((7.0, 0), (7.0, 1.85), <obs>, "-|>"),
    edge(<obs>, (4.5, 3.35), <k>, "-|>", $hat(x)$, label-pos: 0.35),
    edge(<k>, (1, 3.35)),
    edge((1, 3.35), <sum>, "-|>", $-$, label-pos: 0.85, label-side: right),
  ),
)

== 求解一般步骤（基于分离原理的综合设计）

+ *检验前提条件*：分别验证系统 $(A, B)$ *完全可控*且 $(A, C)$ *完全可观*；
+ *独立设计状态反馈阵 $K$*：按第 1 节方法，求 $K$ 使 $det(s I - A + B K) = 0$ 的根位于期望的 $n$ 个闭环反馈极点；
+ *独立设计观测器增益阵 $G$*：按第 2 节方法，求 $G$ 使 $det(s I - A + G C) = 0$ 的根位于期望的 $n$ 个观测器极点（通常比反馈闭环极点快 $2 tilde 5$ 倍）；
+ *组合写出复合闭环系统*：将求得的 $K, G$ 代入 @复合闭环方程（及控制律 $u = -K hat(x) + r$）即完成整个动态补偿器设计。

== 基础典型例题

==== 例 1（带全维观测器的状态反馈综合设计）

已知线性定常系统

$
  cases(
    dot(x) = mat(-5, -1; 6, 0) x + vec(0, 2) u,
    y = mat(0, 1) x,
  )
$

试设计带全维状态观测器的状态反馈闭环系统，使状态反馈闭环极点配置在 $-5 plus.minus j 5$ 处，状态观测器极点配置在 $-10 plus.minus j 10$ 处。

解：

+ *检验可控性与可观性*：
  $
    "rank" Psi_c = "rank" mat(0, -2; 2, 0) = 2, quad
    "rank" Psi_o = "rank" mat(0, 1; 6, 0) = 2
  $
  系统完全可控且完全可观，满足分离设计条件。

+ *独立设计状态反馈矩阵 $K$*：
  期望状态反馈特征多项式为 $a^* (s) = (s + 5 - j 5)(s + 5 + j 5) = s^2 + 10 s + 50$。设 $K = mat(k_1, k_2)$，则
  $
    det(s I - A + B K) & = mat(s + 5, 1; -6 + 2 k_1, s + 2 k_2, delim: "|") \
                       & = s^2 + (5 + 2 k_2) s + (10 k_2 + 6 - 2 k_1)
  $
  比较系数得：
  $
    cases(
      5 + 2 k_2 = 10,
      10 k_2 + 6 - 2 k_1 = 50,
    ) ==> cases(
      k_1 = -19 / 2,
      k_2 = 5 / 2,
    ) ==> K = mat(-19 / 2, 5 / 2)
  $

+ *独立设计全维状态观测器增益 $G$*：
  由第 2 节例 2 已求得 $G = vec(31 / 3, 15)$，满足 $det(s I - A + G C) = s^2 + 20 s + 200$。

+ *组合写出 4 维复合闭环系统方程*：
  控制律为 $u = r - K hat(x) = r + 19 / 2 hat(x)_1 - 5 / 2 hat(x)_2$。计算
  $
    A - G C - B K = mat(-5, -34 / 3; 6, -15) - mat(0, 0; -19, 5) = mat(-5, -34 / 3; 25, -20)
  $
  代入 @复合闭环方程 得复合闭环系统：
  $
    cases(
      vec(dot(x), dot(hat(x))) = mat(
        -5, -1, 0, 0;
        6, 0, 19, -5;
        0, 31 / 3, -5, -34 / 3;
        0, 15, 25, -20
      ) vec(x, hat(x)) + vec(0, 2, 0, 2) r,
      y = mat(0, 1, 0, 0) vec(x, hat(x)),
    )
  $
  其 4 个闭环极点恰好为 $\{-5 plus.minus j 5, -10 plus.minus j 10\}$。

== 核心定理与闭环基本特性推导

对复合系统 @复合闭环方程 引入状态估计误差 $tilde(x) = x - hat(x)$，作非奇异线性变换（注意到 $P^(-1) = P$）：

$
  vec(x, tilde(x)) = P vec(x, hat(x)) = mat(I, 0; I, -I) vec(x, hat(x))
$ <分离变换>

将 $hat(x) = x - tilde(x)$ 代入复合方程，得到*分块上三角*标准形式：

$
  cases(
    vec(dot(x), dot(tilde(x))) = mat(
      A - B K, B K;
      0, A - G C
    ) vec(x, tilde(x)) + vec(B, 0) r,
    y = mat(C, 0) vec(x, tilde(x)),
  )
$ <误差坐标复合方程>

由 @误差坐标复合方程 直接导出复合闭环系统的两大核心定理与等效性结论：

/ 定理 5（分离原理 / 闭环极点可分离性）: 若线性定常系统完全可控且完全可观，采用状态观测器估值构成状态反馈闭环系统时，复合系统的特征多项式为
  $
    Delta(s) & = mat(
                 s I - A + B K, -B K;
                 0, s I - A + G C,
                 delim: "|"
               ) \
             & = det(s I - A + B K) dot det(s I - A + G C)
  $
  即复合系统的 $2 n$ 个闭环极点由直接状态反馈极点（$A - B K$ 的特征值）与状态观测器极点（$A - G C$ 的特征值）共同组成，*状态反馈矩阵 $K$ 与观测器增益阵 $G$ 的设计相互独立、互不干扰*。

/ 定理 6（闭环传递函数阵不变性）: 带有状态观测器的状态反馈闭环系统，从参考输入 $r$ 到输出 $y$ 的闭环传递函数阵与直接采用真实状态反馈 $u = -K x + r$ 时*完全相同*。

*证明*：利用分块上三角矩阵求逆公式 $mat(R, S; 0, T)^(-1) = mat(R^(-1), -R^(-1) S T^(-1); 0, T^(-1))$，由 @误差坐标复合方程 可得：

$
  G_(K G)(s) & = mat(C, 0) mat(
                 s I - A + B K, -B K;
                 0, s I - A + G C
               )^(-1) vec(B, 0) \
             & = C (s I - A + B K)^(-1) B = G_K (s)
$

（本质原因：在 @误差坐标复合方程 中输入矩阵为 $vec(B, 0)$，误差子系统 $tilde(x)$ 处于*不可控子空间*，故观测器的 $n$ 个极点在输入–输出传递函数中被零极点对消。）

=== 观测器反馈与直接状态反馈的等效性辨析

展开 @误差坐标复合方程 可得 $dot(x) = (A - B K) x + B K tilde(x) + B r, dot(tilde(x)) = (A - G C) tilde(x)$。

#figure(
  caption: [带观测器状态反馈与直接状态反馈系统的异同对比],
  table(
    columns: (auto, 1fr, 1fr),
    [比较维度],
    [直接状态反馈 $u = -K x + r$],
    [带观测器状态反馈 $u = -K hat(x) + r$],

    [系统维数], [$n$ 维], [$2 n$ 维（降维观测器时为 $2 n - l$ 维）],
    [零初始误差下的响应与传递函数阵],
    [$G_K (s) = C (s I - A + B K)^(-1) B$],
    [与直接反馈*完全相同*（$G_(K G)(s) = G_K (s)$）],

    [非零初始误差 $tilde(x)(0) != 0$ 时的暂态],
    [无估计误差扰动项],
    [存在耦合项 $B K tilde(x)(t)$，暂态过程有差异],

    [稳态（$t -> infinity$）等效性],
    [$dot(x) = (A - B K) x + B r$],
    [当 $A - G C$ 稳定时 $tilde(x) -> 0$，*稳态完全等价*；增大观测器极点负实部可加速趋近],
  ),
)

#pagebreak()
= 系统解耦问题

在多输入多输出（MIMO）系统中，若每个输出仅受对应的一个输入控制、每个输入也仅控制对应的一个输出（各通道互不干扰），则称为*解耦系统*。

从数学上看，解耦就是使系统闭环传递函数阵变为*非奇异对角阵*：

$
  G(s) = Y(s) / R(s) & = mat(
                         G_(11)(s), 0, ..., 0;
                         0, G_(22)(s), ..., 0;
                         dots.v, dots.v, dots.down, dots.v;
                         0, 0, ..., G_(m m)(s)
                       ) \
                     & = "diag"[G_(11)(s), G_(22)(s), ..., G_(m m)(s)]
$ <解耦对角阵>

*解耦的基本条件*：输入维数等于输出维数（方阵系统），且不超过状态维数，即 $r = m <= n$。

== 串联补偿器解耦

在原被控对象 $G_0 (s) = C (s I - A)^(-1) B$ 前串联补偿器 $G_c (s)$，外加单位输出负反馈构成闭环系统，结构如下图所示。

#figure(
  caption: [单位输出反馈串联补偿器解耦系统结构图],
  diagram(
    node-stroke: 1pt,
    spacing: (24pt, 20pt),
    // 节点
    node((0, 0), $R(s)$, stroke: none),
    node((1.1, 0), $+$, radius: 8.5pt, name: <sum>),
    node((3.2, 0), $G_c (s)$, inset: 7pt, name: <gc>),
    node((5.5, 0), $G_0 (s)$, inset: 7pt, name: <g0>),
    node((8.4, 0), [], stroke: none),

    // 连线
    edge((0, 0), <sum>, "-|>", $+$, label-pos: 0.75, label-side: left),
    edge(<sum>, <gc>, "-|>", $E(s)$, label-pos: 0.36),
    edge(<gc>, <g0>, "-|>", $U(s)$),
    edge(<g0>, (8.4, 0), "-|>", $Y(s)$, label-pos: 0.74),

    // 单位负反馈
    edge((7.4, 0), (7.4, 1.45), (1.1, 1.45)),
    edge((1.1, 1.45), <sum>, "-|>", $-$, label-pos: 0.78, label-side: right),

    // G_p(s) 虚线框
    node(
      enclose: (<gc>, <g0>),
      stroke: (paint: rgb("#2563eb"), dash: "dashed", thickness: 0.85pt),
      inset: 10pt,
      corner-radius: 4pt,
      fill: rgb("#dbeafe").transparentize(88%),
      layer: -1,
    ),
    node(
      (4.35, -1.15),
      text(size: 11pt, fill: rgb("#1d4ed8"))[$G_p (s) = G_0 (s) G_c (s)$],
      stroke: none,
    ),
  ),
)

=== 求解一般步骤

+ *写出被控对象传递函数阵 $G_0 (s)$*：由状态方程 $G_0 (s) = C (s I - A)^(-1) B$ 或系统框图求得 $m times m$ 传递函数阵 $G_0 (s)$，检验 $det G_0 (s) equiv.not 0$（可逆）；
+ *明确期望对角闭环传递函数阵 $G_H (s)$*：确认 $G_H (s) = "diag"[G_(H 1)(s), ..., G_(H m)(s)]$ 且 $G_H (s) != I$；
+ *分别计算逆矩阵*：求被控对象逆阵 $G_0 (s)^(-1)$ 与对角阵 $G_H (s) [I - G_H (s)]^(-1)$；
+ *代入公式求串联补偿器 $G_c (s)$*：
  $
    G_c (s) = G_0 (s)^(-1) G_H (s) [I - G_H (s)]^(-1)
  $ <串联补偿器公式>

=== 基础典型例题

==== 例 1（双输入双输出系统串联补偿器解耦）

双输入双输出耦合被控对象框图如下图所示，试设计串联补偿器 $G_c (s)$，使采用单位输出负反馈的闭环系统传递函数阵实现解耦，且期望闭环传递函数阵为

$
  G_H (s) = mat(display(1 / (s + 1)), 0; 0, display(1 / (5 s + 1)))
$

#figure(
  caption: [双输入双输出耦合被控对象框图],
  diagram(
    node-stroke: 1pt,
    spacing: (26pt, 22pt),
    // 节点
    node((0, 0), $U_1 (s)$, stroke: none),
    node((2.3, 0), $display(1 / (2 s + 1))$, inset: 6pt, name: <g11>),
    node((5.8, 0), [], stroke: none),
    node((2.3, 1.05), $1$, inset: 5pt, name: <g21>),
    node((0, 2.1), $U_2 (s)$, stroke: none),
    node((2.3, 2.1), $display(1 / (s + 1))$, inset: 6pt, name: <g22>),
    node((3.85, 2.1), $+$, radius: 8.5pt, name: <sum2>),
    node((5.8, 2.1), [], stroke: none),

    // 通道 1
    edge((0, 0), <g11>, "-|>"),
    edge(<g11>, (5.8, 0), "-|>", $Y_1 (s)$, label-pos: 0.78),

    // 耦合支路 U1 -> Y2
    edge((0.95, 0), (0.95, 1.05), <g21>, "-|>"),
    edge(<g21>, (3.85, 1.05)),
    edge((3.85, 1.05), <sum2>, "-|>", $+$, label-pos: 0.65, label-side: left),

    // 通道 2
    edge((0, 2.1), <g22>, "-|>"),
    edge(<g22>, <sum2>, "-|>"),
    edge(<sum2>, (5.8, 2.1), "-|>", $Y_2 (s)$, label-pos: 0.65),
  ),
)

解：

+ *写出被控对象传递函数阵 $G_0 (s)$*：
  由框图直接得 $Y_1 (s) = 1 / (2 s + 1) U_1 (s)$，$Y_2 (s) = U_1 (s) + 1 / (s + 1) U_2 (s)$，即
  $
    G_0 (s) = mat(display(1 / (2 s + 1)), 0; 1, display(1 / (s + 1)))
  $

+ *计算 $G_0 (s)^(-1)$*：
  $
    G_0 (s)^(-1) & = (2 s + 1)(s + 1) mat(display(1 / (s + 1)), 0; -1, display(1 / (2 s + 1))) \
    & = mat(2 s + 1, 0; -(2 s + 1)(s + 1), s + 1)
  $

+ *计算 $G_H (s) [I - G_H (s)]^(-1)$*：
  $
    G_H (s) [I - G_H (s)]^(-1)
    & = mat(display(1 / (s + 1)), 0; 0, display(1 / (5 s + 1)))
    mat(display(s / (s + 1)), 0; 0, display((5 s) / (5 s + 1)))^(-1) \
    & = mat(display(1 / (s + 1)), 0; 0, display(1 / (5 s + 1)))
    mat(display((s + 1) / s), 0; 0, display((5 s + 1) / (5 s)))
    = mat(display(1 / s), 0; 0, display(1 / (5 s)))
  $

+ *计算串联补偿器传递函数阵 $G_c (s)$*：
  $
    G_c (s) & = G_0 (s)^(-1) G_H (s) [I - G_H (s)]^(-1) \
            & = mat(2 s + 1, 0; -(2 s + 1)(s + 1), s + 1)
              mat(display(1 / s), 0; 0, display(1 / (5 s))) \
            & = mat(
                display((2 s + 1) / s), 0;
                display((-(2 s + 1)(s + 1)) / s), display((s + 1) / (5 s))
              )
  $
  即补偿器各元素为 $G_(c 11) = (2 s + 1) / s, G_(c 12) = 0, G_(c 21) = (-(2 s + 1)(s + 1)) / s, G_(c 22) = (s + 1) / (5 s)$。

=== 推导原理与设计约束

记前向通道传递函数阵为 $G_p (s) = G_0 (s) G_c (s)$。对单位输出负反馈系统，有

$
  G_H (s) = [I + G_p (s)]^(-1) G_p (s)
  & ==> [I + G_0 (s) G_c (s)] G_H (s) = G_0 (s) G_c (s) \
  & ==> G_0 (s) G_c (s) [I - G_H (s)] = G_H (s) \
  & ==> G_c (s) = G_0 (s)^(-1) G_H (s) [I - G_H (s)]^(-1)
$

#note-me.note[
  - *$G_H (s) != I$*：否则 $I - G_H (s)$ 奇异不可逆，物理上表示不能让输出无动态地直接等于输入；
  - *开环同步对角化*：当 $G_H (s)$ 为对角阵时，$[I - G_H (s)]^(-1)$ 与前向开环阵 $G_p (s) = G_0 (s) G_c (s) = G_H (s) [I - G_H (s)]^(-1)$ 亦为对角阵；
  - *物理可实现性提醒*：直接求逆 $G_0 (s)^(-1)$ 可能导致 $G_c (s)$ 出现分子阶次高于分母阶次的纯微分项（如本例 $G_(c 21)$）或不稳定零极点对消，实际工程需合理提高 $G_H (s)$ 的相对阶次。
]

== 状态反馈解耦

除频域串联补偿外，还可利用状态反馈阵 $F$ 与输入变换矩阵 $K$ 构造控制律 $u = K R - F x$，将原系统 $Sigma_0 (A, B, C)$ 化为闭环系统：

$
  Sigma_K : cases(
    dot(x) = (A - B F) x + B K R,
    y = C x,
  )
$ <状态反馈解耦方程>

通过适当选择 $F$ 和 $K$，使闭环传递函数阵 $G_(K F)(s) = C (s I - A + B F)^(-1) B K$ 为非奇异对角阵，实现*状态反馈解耦*（且可兼顾部分闭环极点配置）。

#figure(
  caption: [状态反馈解耦系统结构图],
  diagram(
    node-stroke: 1pt,
    spacing: (24pt, 20pt),
    node((0, 0), $R$, stroke: none),
    edge("-|>"),
    node((1.1, 0), $K$),
    edge("-|>", $+$, label-pos: 0.72, label-side: left),
    node((2.1, 0), $+$, radius: 8.5pt),
    edge("-|>", $u$),
    node((3.1, 0), $B$),
    edge("-|>"),
    node((4.1, 0), $+$, radius: 8.5pt),
    edge("-|>", $dot(x)$),
    node((5.1, 0), $integral$),
    edge((5.1, 0), (6.9, 0), "-|>", $x$, label-pos: 0.4),
    node((6.9, 0), $C$),
    edge("-|>"),
    node((7.9, 0), $y$, stroke: none),

    // 内部 A
    edge((6.0, 0), (6.0, 1.15), (5.1, 1.15), "-|>"),
    node((5.1, 1.15), $A$),
    edge((5.1, 1.15), (4.1, 1.15), (4.1, 0), "-|>"),

    // 状态反馈 F
    edge((6.3, 0), (6.3, 2.2), (4.3, 2.2), "-|>"),
    node((4.3, 2.2), $F$),
    edge((4.3, 2.2), (2.1, 2.2)),
    edge((2.1, 2.2), (2.1, 0), "-|>", $-$, label-pos: 0.82, label-side: right),
  ),
)

#figure(
  caption: [串联补偿器解耦与状态反馈解耦对比],
  table(
    columns: (auto, 1fr, 1fr),
    [比较维度], [串联补偿器解耦], [状态反馈解耦],
    [控制结构],
    [频域前向补偿器 $G_c (s)$ + 单位输出负反馈],
    [时域输入变换阵 $K$ + 状态反馈阵 $F$（$u = K R - F x$）],

    [核心关系],
    [$G_c (s) = G_0 (s)^(-1) G_H (s) [I - G_H (s)]^(-1)$],
    [$G_(K F)(s) = C (s I - A + B F)^(-1) B K$ 对角化],

    [主要特点],
    [计算直观、仅需输出测量；易引入微分项与零极点对消问题],
    [不增加系统阶次、可同时配置极点；需要状态可测或配观测器],
  ),
)
