#import "@preview/fletcher:0.6.0" as fletcher: diagram, edge, node
#import "@preview/note-me:0.6.0"

#import "../template.typ": note
#show: note.with()

= 线性系统的可控性和可观性

Kalman 于 1960 年提出可控性与可观性，是现代控制理论的基石：
- *可控性*：反映外界输入 $u(t)$ 对内部状态 $x(t)$ 或输出 $y(t)$ 的支配能力（控制问题）；
- *可观性*：反映外部输出 $y(t)$（结合已知输入 $u(t)$）对内部初始状态 $x(t_0)$ 的重构能力（估计问题）。

== 连续系统的状态可控性

=== 基本定义

考虑线性连续系统 $dot(x)(t) = A(t) x(t) + B(t) u(t)$（$x in RR^n, u in RR^m$）：

/ 状态可控性: 对状态空间中的初始状态 $x(t_0)$，若存在无约束的容许控制（幅值不受限、各分量平方可积）$u(t)$，能在有限时间 $t in [t_0, t_f]$ 内使其转移到零状态 $x(t_f) = 0$，则称 $x(t_0)$ 在 $t_0$ 时刻是*可控的*；若所有状态均可控，则称系统*状态完全可控*。
/ 状态可达性: 若存在无约束容许控制 $u(t)$，能在有限时间内将零初始状态 $x(t_0) = 0$ 转移到状态空间中任意指定终端状态 $x(t_1)$，则称系统*状态可达*。

#note-me.note[
  - 对*连续线性定常系统*，状态可控性与状态可达性*等价*，且可控性与初始时刻 $t_0$ 的选取无关，只要求有限时间转移，不限制中间状态轨迹。
  - 状态可控与否同时取决于输入矩阵 $B$（直接作用）和系统矩阵 $A$（状态间间接耦合）。
]

=== 求解一般步骤（判定状态可控性）

给定线性定常系统 $dot(x) = A x + B u$（$A in RR^(n times n), B in RR^(n times m)$），按矩阵结构选用以下三种判据之一即可：

+ *Kalman 秩判据（最通用）*：
  构造可控性判别矩阵
  $
    Psi_c = mat(B, A B, A^2 B, ..., A^(n - 1) B) in RR^(n times n m)
  $ <可控性矩阵>
  检验 $"rank" Psi_c = n$ 是否成立：
  - 单输入系统（$m = 1$）：$Psi_c$ 为 $n times n$ 方阵，直接检验 $det Psi_c != 0$ 即可；
  - 多输入系统（$m > 1$）：可直接对 $Psi_c$ 做初等行变换，或检验方阵 $Psi_c Psi_c^T$ 是否满秩（$"rank"(Psi_c Psi_c^T) = "rank" Psi_c = n$）。

+ *PBH 秩判据（适合 $A$ 为对角阵、三角阵或特征值易求时）*：
  求 $A$ 的全部互异特征值 $lambda_i$，逐一检验水平拼接矩阵
  $
    "rank" mat(lambda_i I - A, B) = n, quad forall lambda_i in sigma(A)
  $ <PBH可控判据>
  只要存在某个特征值使秩小于 $n$，系统就不完全可控，无需再算其余特征值。

+ *规范型判据（适合 $A$ 已为对角形或约旦标准形时）*：
  - *对角规范型*（$A = "diag"(lambda_1, ..., lambda_n)$ 特征值互异）：$B$ 中*不含全零行* $<=>$ 完全可控；
  - *约旦规范型*：对每个约旦块 $J_k(lambda_i)$，其*最后一行*对应的 $B$ 行向量均非零（若同一特征值有多个约旦块，这些最后一行组成的行组须*线性无关*）$<=>$ 完全可控。

=== 基础典型例题

==== 例 1（单输入系统 Kalman 秩判据）

判断下面系统是否状态完全可控：

$
  vec(dot(x)_1, dot(x)_2, dot(x)_3) = mat(
    -1, -2, -2;
    0, -1, 1;
    1, 0, -1
  ) vec(x_1, x_2, x_3) + vec(2, 0, 1) u
$

解：依次计算 $b, A b, A^2 b$：

$
  b = vec(2, 0, 1), quad
  A b = mat(-1, -2, -2; 0, -1, 1; 1, 0, -1) vec(2, 0, 1) = vec(-4, 1, 1), \
  A^2 b = mat(-1, -2, -2; 0, -1, 1; 1, 0, -1) vec(-4, 1, 1) = vec(0, 0, -5)
$

构造可控性矩阵并求秩：

$
  Psi_c = mat(b, A b, A^2 b) = mat(
    2, -4, 0;
    0, 1, 0;
    1, 1, -5
  ) \
  ==> det Psi_c = -10 != 0 => "rank" Psi_c = 3 = n
$

故系统状态完全可控。

==== 例 2（多输入系统秩判据）

判断下面多输入系统是否可控：

$
  dot(x) = mat(
    1, 2, 1;
    0, 1, 0;
    1, 0, 3
  ) x + mat(
    1, 0;
    0, 1;
    0, 0
  ) vec(u_1, u_2)
$

解：计算 $A B$ 与 $A^2 B$：

$
  A B = mat(
    1, 2;
    0, 1;
    1, 0
  ), quad
  A^2 B = mat(
    1, 2, 1;
    0, 1, 0;
    1, 0, 3
  ) mat(
    1, 2;
    0, 1;
    1, 0
  ) = mat(
    2, 4;
    0, 1;
    4, 2
  )
$

构造可控性矩阵 $Psi_c$：

$
  Psi_c = mat(B, A B, A^2 B) = mat(
    1, 0, 1, 2, 2, 4;
    0, 1, 0, 1, 0, 1;
    0, 0, 1, 0, 4, 2
  )
$

前 3 列构成上三角可逆阵（或算 $det(Psi_c Psi_c^T) = det mat(26, 6, 17; 6, 3, 2; 17, 2, 21) != 0$），故 $"rank" Psi_c = 3$，系统完全可控。

==== 例 3（PBH 秩判据）

用 PBH 判据判断如下系统的可控性：

$
  A = mat(
    -7, 0, 0;
    0, -5, 0;
    0, 0, -1
  ), quad B = vec(2, 0, 9)
$

解：$A$ 的特征值为 $-7, -5, -1$。取 $lambda = -5$，构造水平拼接矩阵：

$
  mat(-5 I - A, B) = mat(
    2, 0, 0, 2;
    0, 0, 0, 0;
    0, 0, -4, 9
  )
$

第二行全为零，故 $"rank" mat(-5 I - A, B) = 2 < 3$，系统*不完全可控*，无需再检验其余特征值（对应状态 $dot(x)_2 = -5 x_2$ 不受输入影响）。

==== 例 4（约旦规范型判据）

判断如下约旦标准形系统的可控性：

$
  dot(x) = mat(
    -1, 0, 0, 0, 0, 0, 0;
    0, -2, 0, 0, 0, 0, 0;
    0, 0, -3, 1, 0, 0, 0;
    0, 0, 0, -3, 1, 0, 0;
    0, 0, 0, 0, -3, 0, 0;
    0, 0, 0, 0, 0, -5, 1;
    0, 0, 0, 0, 0, 0, -5
  ) x + mat(
    0, 0;
    1, 0;
    2, 3;
    3, 0;
    0, 0;
    0, 0;
    0, 1
  ) vec(u_1, u_2)
$

解：系统矩阵由四个约旦块 $J_1(-1), J_1(-2), J_3(-3), J_2(-5)$ 组成。观察各约旦块最后一行（第 1, 2, 5, 7 行）对应的 $B$ 行向量：第 1 行 $[0, 0]$ 和第 5 行 $[0, 0]$ 均为零行，不满足约旦规范型可控性判据，故系统*不完全可控*。

=== 核心定理与判据原理

/ 定理 1(连续线性定常系统状态可控性五大等价判据): 对线性定常系统 $dot(x) = A x + B u$（$x in RR^n, u in RR^m$），下列条件互为充要条件：
  + *格拉姆（Gram）矩阵判据*：存在时刻 $t_1 > 0$，使可控 Gram 矩阵
    $
      W_c [0, t_1] = integral_0^(t_1) upright(e)^(-A t) B B^T upright(e)^(-A^T t) dif t
    $ <可控Gram矩阵>
    非奇异；
  + *函数矩阵行无关判据*：$upright(e)^(-A t) B$ 的 $n$ 个行在 $[0, infinity)$ 上线性无关；
  + *Kalman 秩判据*：$"rank" Psi_c = "rank" mat(B, A B, ..., A^(n - 1) B) = n$；
  + *PBH 秩判据*：对任意 $lambda in CC$（等价地，对 $A$ 的每一个特征值 $lambda_i$），$"rank" mat(lambda_i I - A, B) = n$；
  + *规范型判据*：将系统化为约旦标准形 $dot(tilde(x)) = J tilde(x) + tilde(B) u$ 后，对特征值 $lambda_i$（代数重数 $sigma_i$，几何重数 $alpha_i$）：
    - 若 $sigma_i = 1$（或特征值互异的对角阵），对应的输入行 $tilde(B)_i != 0$；
    - 若 $sigma_i > 1, alpha_i = 1$（单约旦块），对应约旦块*最后一行* $tilde(b)_("last") != 0$；
    - 若 $alpha_i > 1$（多约旦块），$lambda_i$ 所属各约旦块*最后一行*对应的输入矩阵行组成的行组*线性无关*。

==== 判据推导原理简述

- *Gram 矩阵判据充分性*：若 $W_c [0, t_1]$ 非奇异，对任一初态 $x_0 != 0$ 构造控制律 $u(t) = -(upright(e)^(-A t) B)^T W_c^(-1) [0, t_1] x_0$，代入状态响应公式即得
  $
    x(t_1) & = upright(e)^(A t_1) x_0 - upright(e)^(A t_1) [integral_0^(t_1) upright(e)^(-A t) B B^T upright(e)^(-A^T t) dif t] W_c^(-1) [0, t_1] x_0 = 0
  $
- *Kalman 秩判据原理*：若 $"rank" Psi_c < n$，存在非零左向量 $alpha$ 使 $alpha^T A^k B = 0$（$k = 0, ..., n - 1$）；由 Cayley-Hamilton 定理，$A^n, A^(n + 1), ...$ 均可表示为 $I, A, ..., A^(n - 1)$ 的线性组合，故 $alpha^T upright(e)^(-A t) B equiv 0$，从而 $alpha^T W_c [0, t_1] alpha = 0$（$W_c$ 奇异）。反之若 $W_c$ 奇异，必有 $alpha^T upright(e)^(-A t) B equiv 0$，在 $t = 0$ 处求导 $0$ 到 $n - 1$ 次即得 $alpha^T Psi_c = 0$。
- *PBH 判据原理*：若某个特征值 $lambda_i$ 使 $"rank" mat(lambda_i I - A, B) < n$，则存在非零向量 $alpha$ 使 $alpha^T (lambda_i I - A) = 0$ 且 $alpha^T B = 0$，即 $alpha^T A = lambda_i alpha^T$。递推得 $alpha^T A^k B = lambda_i^k alpha^T B = 0$，即 $alpha^T Psi_c = 0$，系统不完全可控。

=== 其他变式：输出可控性

对于完整系统 $dot(x) = A x + B u, quad y = C x + D u$（$y in RR^l$，$C in RR^(l times n), D in RR^(l times m)$），若存在无约束容许控制能在有限时间内使任意初输出 $y(t_0)$ 转移到任意终输出 $y(t_1)$，则称系统*输出完全可控*。

/ 定理 2(输出可控性秩判据): 线性定常系统输出完全可控的充要条件是输出可控矩阵
  $
    Psi_(y c) = mat(C B, C A B, C A^2 B, ..., C A^(n - 1) B, D) in RR^(l times (n + 1) m)
  $ <输出可控矩阵>
  满行秩，即 $"rank" Psi_(y c) = l$。

#figure(
  caption: [状态可控性、状态可达性与输出可控性对比],
  table(
    columns: (auto, auto, auto, auto),
    [性质], [转移目标], [判别矩阵与满秩条件], [相互关系（连续定常）],
    [状态可控性],
    [任一 $x(t_0) -> 0$],
    [$Psi_c = mat(B, A B, ..., A^(n - 1) B)$, 秩 $= n$],
    [与状态可达性*等价*],

    [状态可达性],
    [$0 ->$ 任一 $x(t_1)$],
    [同 $Psi_c$, 秩 $= n$],
    [与状态可控性*等价*],

    [输出可控性],
    [任一 $y(t_0) ->$ 任一 $y(t_1)$],
    [$Psi_(y c) = mat(C B, C A B, ..., C A^(n - 1) B, D)$, 秩 $= l$],
    [与状态可控性*无必然联系*],
  ),
)

==== 例 5（状态不完全可控但输出完全可控）

判断下列系统的状态可控性与输出可控性：

$
  dot(x) = mat(
    0, -3, 0, 0;
    1, -4, 0, 0;
    0, 0, 0, -1;
    0, 0, 1, -2
  ) x + mat(
    3, 2;
    1, 2;
    1, 1;
    1, 1
  ) u, quad
  y = mat(
    0, 1, 0, 0;
    0, 0, 0, 1
  ) x
$

解：
+ *状态可控性*：依次计算得
  $
    A B = mat(-3, -6; -1, -6; -1, -1; -1, -1), quad
    A^2 B = mat(3, 18; 1, 18; 1, 1; 1, 1), quad
    A^3 B = mat(-3, -54; -1, -54; -1, -1; -1, -1)
  $
  因 $Psi_c$ 的第 3 行与第 4 行完全相同，故 $"rank" Psi_c = 3 < 4$，系统*状态不完全可控*。
+ *输出可控性*（$l = 2, D = 0$）：
  $
    C B = mat(1, 2; 1, 1), quad
    C A B = mat(-1, -6; -1, -1)
  $
  仅前两列 $C B$ 行列式已为 $-1 != 0$，故 $"rank" Psi_(y c) = "rank" mat(C B, C A B, C A^2 B, C A^3 B, D) = 2 = l$，系统*输出完全可控*。

== 连续系统的状态可观性

=== 基本定义与化简原理

若对任意已知输入 $u(t)$，存在有限观测时间 $t_f > t_0$，使得根据 $[t_0, t_f]$ 上的输出 $y(t)$ 能唯一确定初始状态 $x(t_0)$，则称系统*状态完全可观*（简称*可观*）。

由输出响应公式：

$
  y(t) = C(t) Phi(t - t_0) x(t_0) + C(t) integral_(t_0)^t Phi(t - tau) B u(tau) dif tau + D(t) u(t)
$

因 $u(t)$ 与 $y(t)$ 均已知，令 $overline(y)(t) = y(t) - C(t) integral_(t_0)^t Phi(t - tau) B u(tau) dif tau - D(t) u(t)$，得 $overline(y)(t) = C(t) Phi(t - t_0) x(t_0)$。因此，*输入 $u(t)$ 不改变系统的可观性*，分析定常系统可观性时只需考虑齐次系统：

$
  cases(
    dot(x)(t) = A x(t),
    y(t) = C x(t)
  )
$

=== 求解一般步骤（判定状态可观性）

给定 $(A, C)$（$A in RR^(n times n), C in RR^(l times n)$），按以下方法之一判定：

+ *Kalman 秩判据（最通用）*：
  构造可观性判别矩阵
  $
    Psi_o = mat(C; C A; C A^2; dots.v; C A^(n - 1)) = mat(C^T, A^T C^T, ..., (A^(n - 1))^T C^T)^T in RR^(n l times n)
  $ <可观性矩阵>
  检验 $"rank" Psi_o = n$（单输出时 $Psi_o$ 为 $n times n$ 方阵，检验 $det Psi_o != 0$）。

+ *PBH 秩判据*：
  对 $A$ 的每一个互异特征值 $lambda_i$，检验竖直拼接矩阵（$(n + l) times n$）是否满列秩：
  $
    "rank" mat(lambda_i I - A; C) = n, quad forall lambda_i in sigma(A)
  $ <PBH可观判据>

+ *规范型判据*：
  - *对角规范型*：$C$ 中*不含全零列* $<=>$ 完全可观；
  - *约旦规范型*：每个约旦块*第一列*对应的 $C$ 列向量非零（同一特征值有多个约旦块时，这些第一列组成的列组*线性无关*）$<=>$ 完全可观。

=== 基础典型例题

==== 例 6（多输出系统可观性）

判别如下系统的可观性：

$
  dot(x) = mat(2, -1; 1, -3) x + vec(-1, 1) u, quad
  y = mat(1, 0; -1, 0) x
$

解：计算 $C A = mat(2, -1; -2, 1)$，构造可观性矩阵：

$
  Psi_o = mat(C; C A) = mat(
    1, 0;
    -1, 0;
    2, -1;
    -2, 1
  ) => "rank" Psi_o = 2 = n
$

故系统状态完全可观。

==== 例 7（单输出不可观系统）

判别如下系统的可观性：

$
  dot(x) = mat(
    0, 1, 0;
    0, 0, 1;
    -6, -11, -6
  ) x + vec(0, 0, 1) u, quad
  y = mat(4, 5, 1) x
$

解：计算 $C A = mat(-6, -7, -1)$，$C A^2 = mat(6, 5, -1)$，得

$
  Psi_o = mat(
    4, 5, 1;
    -6, -7, -1;
    6, 5, -1
  )
$

注意到第 1 行 $+$ 第 3 行 $= mat(10, 10, 0)$，第 1 行 $+$ 第 2 行 $= mat(-2, -2, 0)$，两者线性相关，故 $det Psi_o = 0$ 且 $"rank" Psi_o = 2 < 3$，系统*不完全可观*。

==== 例 8（约旦规范型可观性判据）

判断如下约旦标准形系统的可观性：

$
  dot(x) = mat(
    -1, 0, 0, 0, 0, 0, 0, 0;
    0, 1, 0, 0, 0, 0, 0, 0;
    0, 0, 2, 0, 0, 0, 0, 0;
    0, 0, 0, -2, 1, 0, 0, 0;
    0, 0, 0, 0, -2, 0, 0, 0;
    0, 0, 0, 0, 0, -3, 1, 0;
    0, 0, 0, 0, 0, 0, -3, 1;
    0, 0, 0, 0, 0, 0, 0, -3
  ) x, quad
  y = mat(
    1, 0, 0, 0, 0, 0, 0, 1;
    4, 0, 1, 0, 0, 0, 0, 1;
    0, 0, 0, 1, 0, 0, 0, 1
  ) x
$

解：系统矩阵由 $J_1(-1), J_1(1), J_1(2), J_2(-2), J_3(-3)$ 组成。各约旦块首列对应 $C$ 的第 $1, 2, 3, 4, 6$ 列，其中第 2 列（对应 $J_1(1)$）和第 6 列（对应 $J_3(-3)$）均为零列，故系统*不完全可观*。

=== 可控性与可观性判据对比汇总

/ 定理 3(连续线性定常系统可观性五大等价判据): 对 $(A, C)$，存在 $t_1 > 0$ 使可观 Gram 矩阵 $W_o [0, t_1] = integral_0^(t_1) upright(e)^(A^T t) C^T C upright(e)^(A t) dif t$ 非奇异 $<=>$ $C upright(e)^(A t)$ 的 $n$ 列线性无关 $<=>$ $"rank" Psi_o = n$ $<=>$ $forall lambda_i in sigma(A), "rank" mat(lambda_i I - A; C) = n$ $<=>$ 约旦标准形各约旦块*首列*对应的输出列向量非零且同特征值下线性无关。

#figure(
  caption: [线性定常系统可控性与可观性五大判据对照表],
  table(
    columns: (auto, 210pt, 210pt),
    [判据名称], [可控性条件 $(A, B)$], [可观性条件 $(A, C)$],
    [Gram 矩阵],
    [$W_c [0, t_1] = integral_0^(t_1) upright(e)^(-A t) B B^T upright(e)^(-A^T t) dif t$ 非奇异],
    [$W_o [0, t_1] = integral_0^(t_1) upright(e)^(A^T t) C^T C upright(e)^(A t) dif t$ 非奇异],

    [函数线性无关],
    [$upright(e)^(-A t) B$ 的 $n$ 个行在 $[0, infinity)$ 线性无关],
    [$C upright(e)^(A t)$ 的 $n$ 个列在 $[0, infinity)$ 线性无关],

    [Kalman 秩判据],
    [$"rank" mat(B, A B, ..., A^(n - 1) B) = n$],
    [$"rank" mat(C; C A; dots.v; C A^(n - 1)) = n$],

    [PBH 秩判据],
    [$"rank" mat(lambda_i I - A, B) = n, quad forall lambda_i in sigma(A)$],
    [$"rank" mat(lambda_i I - A; C) = n, quad forall lambda_i in sigma(A)$],

    [规范型判据\ （约旦标准形）],
    [各约旦块*末行*对应 $B$ 行向量非零；重特征值多块时该末行组线性无关],
    [各约旦块*首列*对应 $C$ 列向量非零；重特征值多块时该首列组线性无关],
  ),
)

== 对偶关系、可镇定性与可检测性

=== 线性系统的对偶关系与对偶原理

设有两个互为*对偶*的线性定常系统：

$
  Sigma_1 : cases(
    dot(x) = A x + B u,
    y = C x
  ), quad
  Sigma_2 : cases(
    dot(psi) = -A^T psi + C^T eta,
    phi = B^T psi
  )
$ <对偶系统>

其中 $Sigma_1$ 输入 $m$ 维、输出 $l$ 维；$Sigma_2$ 输入 $l$ 维、输出 $m$ 维，两者系数阵分别为 $(A, B, C)$ 与 $(-A^T, C^T, B^T)$，信号流向正好相反。

#figure(
  caption: [对偶系统 $Sigma_1$ 与 $Sigma_2$ 的状态结构对比（信号流反向）],
  diagram(
    node-stroke: 1pt,
    spacing: (22pt, 20pt),
    // Sigma 1
    node((-1.2, 0), $Sigma_1 :$, stroke: none),
    node((0, 0), $u$, stroke: none),
    edge("-|>"),
    node((1, 0), $B$),
    edge("-|>"),
    node((2, 0), $+$, radius: 9pt),
    edge("-|>", $dot(x)$),
    node((3, 0), $integral$),
    edge("rr", "-|>", $x$, label-pos: 0.35),
    node((5, 0), $C$),
    edge("-|>"),
    node((6, 0), $y$, stroke: none),
    edge((4, 0), (4, 1.15), (3, 1.15), "-|>"),
    node((3, 1.15), $A$),
    edge((3, 1.15), (2, 1.15), (2, 0), "-|>"),

    // Sigma 2
    node((-1.2, 2.7), $Sigma_2 :$, stroke: none),
    node((0, 2.7), $phi$, stroke: none),
    node((1, 2.7), $B^T$),
    edge((1, 2.7), (0, 2.7), "-|>"),
    node((3, 2.7), $integral$),
    edge((3, 2.7), (1, 2.7), "-|>", $psi$, label-pos: 0.55),
    node((4, 2.7), $+$, radius: 9pt),
    edge((4, 2.7), (3, 2.7), "-|>", $dot(psi)$, label-pos: 0.45),
    node((5, 2.7), $C^T$),
    edge((5, 2.7), (4, 2.7), "-|>"),
    node((6, 2.7), $eta$, stroke: none),
    edge((6, 2.7), (5, 2.7), "-|>"),
    edge((2, 2.7), (2, 3.85), (3, 3.85), "-|>"),
    node((3, 3.85), $-A^T$),
    edge((3, 3.85), (4, 3.85), (4, 2.7), "-|>"),
  ),
)

/ 定理 4(对偶原理): 设 $Sigma_1$ 和 $Sigma_2$ 互为对偶系统，则 $Sigma_1$ 完全可控 $<=> Sigma_2$ 完全可观；$Sigma_1$ 完全可观 $<=> Sigma_2$ 完全可控。（注：将 $Sigma_2$ 写成 $(A^T, C^T, B^T)$ 在可控/可观性上同样等价。）

证明：$Sigma_2$ 的可观性矩阵为

$
  Psi_o^* = mat(B^T; B^T (-A^T); dots.v; B^T (-A^T)^(n - 1)) = mat(B, -A B, A^2 B, ..., (-1)^(n - 1) A^(n - 1) B)^T
$

显然 $"rank" Psi_o^* = "rank" Psi_c$，同理 $Sigma_2$ 的可控性矩阵与 $Sigma_1$ 的可观性矩阵同秩，得证。

==== 例 9（利用对偶原理判别可观性）

判别如下系统是否可观：

$
  dot(x) = mat(0, 0, 1; 1, 0, 0; 0, 1, 0) x + vec(1, 0, 0) u, quad
  y = mat(0, 0, 1) x
$

解：构造对偶系统 $Sigma_2$：

$
  dot(psi) = -mat(0, 1, 0; 0, 0, 1; 1, 0, 0) psi + vec(0, 0, 1) eta, quad
  phi = mat(1, 0, 0) psi
$

对偶系统可控性矩阵为 $Psi_(c 2) = mat(0, 0, 1; 0, -1, 0; 1, 0, 0)$，显然 $"rank" Psi_(c 2) = 3$，故对偶系统完全可控；由对偶原理，原系统完全可观。

=== 可镇定性与可检测性

/ 可镇定性: 当系统的*所有不稳定模态（或不稳定状态）均属于可控子空间*（即不可控部分渐近稳定）时，称系统是*可镇定的*。
/ 可检测性: 当系统的*所有不稳定模态（或不稳定状态）均属于可观子空间*（即不可观部分渐近稳定）时，称系统是*可检测的*。

== 线性离散系统的可控性与可观性

考虑线性定常离散系统：

$
  cases(
    x(k + 1) = G x(k) + H u(k),
    y(k) = C x(k)
  )
$ <离散系统>

- *状态可控性*：对任一初态 $x(k)$，存在有限步控制序列 ${u(k), ..., u(N - 1)}$ 使 $x(N) = 0$；
- *状态可达性*：从 $x(k) = 0$ 出发，能在有限步到达状态空间任意指定点 $x(N)$。

#note-me.note[
  对离散时间系统，可控性与可达性等价的充要条件是系统矩阵 $G$ *非奇异*（若离散系统由连续系统采样离散化得到，因 $G = upright(e)^(A T)$ 恒非奇异，故两者必定等价）。
]

/ 定理 5(离散系统可控性与可观性秩判据):
  - 离散定常系统状态完全可控（当 $G$ 非奇异时等价于可达）的充要条件是：
    $
      "rank" Psi_c = "rank" mat(H, G H, G^2 H, ..., G^(n - 1) H) = n
    $
  - 离散定常系统状态完全可观的充要条件是：
    $
      "rank" Psi_o = "rank" mat(C; C G; C G^2; dots.v; C G^(n - 1)) = n
    $

==== 例 10（离散系统可控性）

分析下面线性定常离散系统的可控性：

$
  x(k + 1) = mat(1, 2, 1; 1, 0, 2; 0, 1, 0) x(k) + mat(1, 0; 0, 0; 0, 1) u(k)
$

解：计算可控性矩阵 $Psi_c = mat(H, G H, G^2 H) = mat(1, 0, 1, 1, 3, 5; 0, 0, 1, 2, 1, 1; 0, 1, 0, 0, 1, 2)$。前 3 列构成的行列式非零，故 $"rank" Psi_c = 3 = n$，系统完全可控。

==== 例 11（离散系统可观性）

分析下面线性定常离散系统的可观性：

$
  x(k + 1) = mat(1, 0, -1; 0, -2, 1; 3, 0, 2) x(k) + vec(2, -1, 1) u(k), quad
  y(k) = mat(0, 0, 1; 1, 0, 0) x(k)
$

解：计算可观性矩阵：

$
  Psi_o = mat(C; C G; C G^2) = mat(
    0, 0, 1;
    1, 0, 0;
    3, 0, 2;
    1, 0, -1;
    9, 0, 1;
    -2, 0, -3
  )
$

第 2 列全为零，故 $"rank" Psi_o = 2 < 3$，系统*不完全可观*。

#pagebreak()
= 可控标准形和可观标准形

由于状态变量选取不唯一，对同一系统作非奇异线性变换 $x = T overline(x)$ 不改变其可控性与可观性，可将完全可控（或完全可观）的 SISO 系统化为伴随阵形式的标准形，极大简化传递函数读取、极点配置与观测器设计。

== 求解一般步骤

将 $n$ 维单输入/单输出线性定常系统 $dot(x) = A x + b u, quad y = c x$ 化为标准形的通用流程：

+ *判定前提条件*：
  - 化为*可控标准形*：检验 $"rank" Psi_c = n$（系统必须完全可控）；
  - 化为*可观标准形*：检验 $"rank" Psi_o = n$（系统必须完全可观）。
+ *求特征多项式系数*（II 型可控形与 I 型可观形甚至仅用于写 $overline(A)$）：
  $
    alpha(s) = det(s I - A) = s^n + alpha_(n - 1) s^(n - 1) + ... + alpha_1 s + alpha_0
  $ <特征多项式>
+ *构造变换阵 $T$（或 $T^(-1)$）并计算 $(overline(A), overline(b), overline(c))$*：
  按目标标准形类型套用下表公式（若题目要求新状态变量，需再求 $overline(x) = T^(-1) x$）。

== 四类标准形汇总对比

#{
  set math.equation(numbering: none)
  figure(
    caption: [SISO 线性定常系统四类可控/可观标准形汇总],
    table(
      columns: (auto, 145pt, 125pt, 105pt),
      [标准形类型\ （对偶关系）],
      [变换阵 $x = T overline(x)$],
      [系统阵 $overline(A) = T^(-1) A T$],
      [$overline(b) = T^(-1) b$ 与 $overline(c) = c T$],

      [*可控标准 I 型*\ （对偶可观 II 型）],
      [$
        T_(c 1) = mat(A^(n - 1) b, ..., b) \
        times mat(1, 0, ..., 0; alpha_(n - 1), 1, ..., 0; dots.v, dots.down, dots.down, dots.v; alpha_1, alpha_2, ..., 1)
      $],
      [$mat(0, 1, ..., 0; dots.v, dots.v, dots.down, dots.v; 0, 0, ..., 1; -alpha_0, -alpha_1, ..., -alpha_(n - 1))$],
      [$overline(b) = mat(0, ..., 0, 1)^T$ \ $overline(c) = c T_(c 1) = mat(beta_0, ..., beta_(n - 1))$],

      [*可控标准 II 型*\ （对偶可观 I 型）],
      [$
        T_(c 2) = Psi_c \
        = mat(b, A b, ..., A^(n - 1) b)
      $],
      [$mat(0, ..., 0, -alpha_0; 1, ..., 0, -alpha_1; dots.v, dots.down, dots.v, dots.v; 0, ..., 1, -alpha_(n - 1))$],
      [$overline(b) = mat(1, 0, ..., 0)^T$ \ $overline(c) = c T_(c 2) = mat(c b, ..., c A^(n - 1) b)$],

      [*可观标准 I 型*\ （对偶可控 II 型）],
      [$
        T_(o 1)^(-1) = Psi_o = mat(c; c A; dots.v; c A^(n - 1))
      $],
      [$mat(0, 1, ..., 0; dots.v, dots.v, dots.down, dots.v; 0, 0, ..., 1; -alpha_0, -alpha_1, ..., -alpha_(n - 1))$],
      [$overline(b) = T_(o 1)^(-1) b$ \ $overline(c) = mat(1, 0, ..., 0)$],

      [*可观标准 II 型*\ （对偶可控 I 型）],
      [$
        T_(o 2)^(-1) = mat(1, alpha_(n - 1), ..., alpha_1; 0, 1, ..., alpha_2; dots.v, dots.v, dots.down, dots.v; 0, 0, ..., 1) \
        times mat(c A^(n - 1); dots.v; c A; c)
      $],
      [$mat(0, ..., 0, -alpha_0; 1, ..., 0, -alpha_1; dots.v, dots.down, dots.v, dots.v; 0, ..., 1, -alpha_(n - 1))$],
      [$overline(b) = T_(o 2)^(-1) b$ \ $overline(c) = mat(0, ..., 0, 1)$],
    ),
  )
}

#note-me.important[
  由*可控标准 I 型* $(overline(A), overline(b), overline(c))$ 可直接写出系统传递函数，无需矩阵求逆：
  $
    W(s) = overline(c)(s I - overline(A))^(-1) overline(b) = frac(beta_(n - 1) s^(n - 1) + beta_(n - 2) s^(n - 2) + ... + beta_1 s + beta_0, s^n + alpha_(n - 1) s^(n - 1) + ... + alpha_1 s + alpha_0)
  $
  其中分母系数是 $overline(A)$ 末行元素的负值，分子系数即为 $overline(c)$ 的各元素（按升幂排列 $beta_0, ..., beta_(n - 1)$）。
]

== 基础典型例题

==== 例 1（二阶系统化为可控 I 型、可控 II 型与可观 II 型）

已知线性定常系统：

$
  A = mat(1, -1; 0, -1), quad b = vec(1, 1), quad c = mat(1, 0)
$

试分别将其化为：(1) 可控标准 I 型；(2) 可控标准 II 型；(3) 可观标准 II 型。

解：先检验可控性与可观性，并求特征多项式：

$
  Psi_c = mat(b, A b) = mat(1, 0; 1, -1), quad "rank" Psi_c = 2 \
  Psi_o = mat(c; c A) = mat(1, 0; 1, -1), quad "rank" Psi_o = 2 \
  det(s I - A) = mat(s - 1, 1; 0, s + 1, delim: "|") = s^2 - 1 => alpha_0 = -1, alpha_1 = 0
$

+ *可控标准 I 型*：
  $
    T_(c 1) = mat(A b, b) mat(1, 0; alpha_1, 1) = mat(0, 1; -1, 1) mat(1, 0; 0, 1) = mat(0, 1; -1, 1), quad
    overline(c) = c T_(c 1) = mat(0, 1)
  $
  故可控标准 I 型为：
  $
    dot(overline(x)) = mat(0, 1; 1, 0) overline(x) + vec(0, 1) u, quad y = mat(0, 1) overline(x)
  $
  （直接读出传递函数 $W(s) = frac(s, s^2 - 1)$。）

+ *可控标准 II 型*：
  取 $T_(c 2) = Psi_c = mat(1, 0; 1, -1)$，则 $overline(c) = c T_(c 2) = mat(1, 0)$，故可控标准 II 型为：
  $
    dot(overline(x)) = mat(0, 1; 1, 0) overline(x) + vec(1, 0) u, quad y = mat(1, 0) overline(x)
  $

+ *可观标准 II 型*：
  $
    T_(o 2)^(-1) = mat(1, alpha_1; 0, 1) mat(c A; c) = mat(1, 0; 0, 1) mat(1, -1; 1, 0) = mat(1, -1; 1, 0)
  $
  计算 $overline(b) = T_(o 2)^(-1) b = mat(1, -1; 1, 0) vec(1, 1) = vec(0, 1)$，故可观标准 II 型为：
  $
    dot(overline(x)) = mat(0, 1; 1, 0) overline(x) + vec(0, 1) u, quad y = mat(0, 1) overline(x)
  $

==== 例 2（三阶系统化为可控标准 I 型并求新状态向量）

给定完全可控的线性定常系统：

$
  dot(x) = mat(1, 0, 2; 2, 1, 1; 1, 0, -2) x + vec(1, 2, 1) u, quad
  y = mat(0, 1, 1) x
$

求其可控标准 I 型及新状态向量 $overline(x)$。

解：
+ *求特征多项式*：
  $
    det(s I - A) & = mat(s - 1, 0, -2; -2, s - 1, -1; -1, 0, s + 2, delim: "|") = s^3 - 5 s + 4 \
    & ==> alpha_2 = 0, quad alpha_1 = -5, quad alpha_0 = 4
  $
+ *计算变换阵 $T_(c 1)$ 与 $overline(c)$*：
  由 $b = vec(1, 2, 1), A b = vec(3, 5, -1), A^2 b = vec(1, 10, 5)$，得
  $
    T_(c 1) & = mat(A^2 b, A b, b) mat(1, 0, 0; alpha_2, 1, 0; alpha_1, alpha_2, 1) \
    & = mat(1, 3, 1; 10, 5, 2; 5, -1, 1) mat(1, 0, 0; 0, 1, 0; -5, 0, 1) = mat(-4, 3, 1; 0, 5, 2; 0, -1, 1)
  $
  $overline(c) = c T_(c 1) = mat(0, 1, 1) mat(-4, 3, 1; 0, 5, 2; 0, -1, 1) = mat(0, 4, 3)$。
  于是可控标准 I 型为：
  $
    dot(overline(x)) = mat(0, 1, 0; 0, 0, 1; -4, 5, 0) overline(x) + vec(0, 0, 1) u, quad
    y = mat(0, 4, 3) overline(x)
  $
+ *求新状态向量*：求逆得 $T_(c 1)^(-1) = mat(-1/4, 1/7, -1/28; 0, 1/7, -2/7; 0, 1/7, 5/7)$，故
  $
    overline(x) = T_(c 1)^(-1) x = vec(-1/4 x_1 + 1/7 x_2 - 1/28 x_3, 1/7 x_2 - 2/7 x_3, 1/7 x_2 + 5/7 x_3)
  $

==== 例 3（三阶系统化为可控标准 I 型）

将下面系统化为可控标准 I 型：

$
  dot(x) = mat(1, 2, 0; 3, -1, 1; 0, 2, 0) x + vec(2, 1, 1) u, quad
  y = mat(0, 0, 1) x
$

解：
+ *检验可控性*：$Psi_c = mat(b, A b, A^2 b) = mat(2, 4, 16; 1, 6, 8; 1, 2, 12)$，易算得 $"rank" Psi_c = 3$，系统完全可控。
+ *求特征多项式*：
  $
    det(s I - A) & = mat(s - 1, -2, 0; -3, s + 1, -1; 0, -2, s, delim: "|") = s^3 - 9 s + 2 \
    & ==> alpha_2 = 0, quad alpha_1 = -9, quad alpha_0 = 2
  $
+ *求变换阵与标准形*：
  $
    T_(c 1) = mat(16, 4, 2; 8, 6, 1; 12, 2, 1) mat(1, 0, 0; 0, 1, 0; -9, 0, 1) = mat(-2, 4, 2; -1, 6, 1; 3, 2, 1), quad
    overline(c) = c T_(c 1) = mat(3, 2, 1)
  $
  故可控标准 I 型为：
  $
    dot(overline(x)) = mat(0, 1, 0; 0, 0, 1; -2, 9, 0) overline(x) + vec(0, 0, 1) u, quad
    y = mat(3, 2, 1) overline(x)
  $

== 核心定理与步骤原理

=== 可控标准形的 Cayley-Hamilton 推导原理

- *可控标准 I 型推导*：记 $T_(c 1) = mat(e_1, e_2, ..., e_n)$。由列定义可得递推关系：
  $
    e_n & = b, quad e_(n - 1) = A b + alpha_(n - 1) b = A e_n + alpha_(n - 1) e_n, \
    dots.c, quad e_2 & = A e_3 + alpha_2 e_n
  $
  而对首列 $e_1 = A^(n - 1) b + alpha_(n - 1) A^(n - 2) b + ... + alpha_1 b$ 左乘 $A$，结合 Cayley-Hamilton 定理 $alpha(A) = A^n + alpha_(n - 1) A^(n - 1) + ... + alpha_0 I = 0$ 得：
  $
    A e_1 = (A^n + alpha_(n - 1) A^(n - 1) + ... + alpha_1 A + alpha_0 I) b - alpha_0 b = -alpha_0 e_n
  $
  汇总得 $A T_(c 1) = mat(-alpha_0 e_n, e_1 - alpha_1 e_n, ..., e_(n - 1) - alpha_(n - 1) e_n) = T_(c 1) overline(A)$，且 $b = e_n = T_(c 1) mat(0, ..., 0, 1)^T$，即证。

- *可控标准 II 型推导*：设 $T_(c 2) = mat(e_1, ..., e_n) = mat(b, A b, ..., A^(n - 1) b)$，则 $A e_1 = e_2, ..., A e_(n - 1) = e_n$；再由 $alpha(A) = 0$ 得 $A e_n = A^n b = -alpha_0 e_1 - alpha_1 e_2 - ... - alpha_(n - 1) e_n$，立得 $A T_(c 2) = T_(c 2) overline(A)$。

- *可观标准形推导*：将系统 $(A, c)$ 取对偶 $(A^T, c^T)$ 化为可控标准 II 型 / I 型后转置，即分别得到可观标准 I 型 / II 型。

=== 多输入系统的可控标准形说明

对于 $n$ 维 $m$ 输入完全可控系统 $(A, B)$，可控矩阵 $Psi_c$ 中线性无关的 $n$ 个列向量选法*不唯一*，因此多输入可控标准形不唯一（常见的有 *Wonham 标准形*、*Luenberger 标准形*等）。

#pagebreak()
= 线性系统的结构分解

当系统不完全可控或不完全可观时，通过非奇异状态变换 $x = R overline(x)$ 可将状态空间显式分解为不同可控/可观属性的子空间，从而揭示状态空间描述与外部传递函数描述之间的本质差异（也是最小实现理论的基础）。

== 前置定理：线性变换的不变性

/ 定理 1(可控性与可观性的线性变换不变性): 对 $(A, B, C)$ 作任意非奇异线性变换 $overline(x) = P x$，得到 $overline(A) = P A P^(-1), overline(B) = P B, overline(C) = C P^(-1)$，则有
  $
    "rank" overline(Psi)_c = "rank" Psi_c, quad "rank" overline(Psi)_o = "rank" Psi_o
  $
  即非奇异线性变换不改变系统的可控性与可观性。

证明：$overline(Psi)_c = mat(P B, P A B, ..., P A^(n - 1) B) = P Psi_c$。因 $P$ 非奇异，左乘可逆阵不改变矩阵秩，故 $"rank" overline(Psi)_c = "rank" Psi_c$；同理 $overline(Psi)_o = Psi_o P^(-1)$ 亦保持秩不变。

== 按可控性分解

=== 求解一般步骤

设线性定常系统不完全可控，且 $"rank" Psi_c = n_1 < n$：

+ 计算可控性判别矩阵 $Psi_c = mat(B, A B, ..., A^(n - 1) B)$，求出其秩 $n_1$；
+ 从 $Psi_c$ 中选取 $n_1$ 个线性无关的列向量作为 $R_c$ 的前 $n_1$ 列，再补充 $n - n_1$ 个列向量使 $R_c = mat(R_1, ..., R_(n_1), R_(n_1 + 1), ..., R_n)$ 非奇异；
+ 作非奇异变换 $x = R_c hat(x)$，计算分解后的矩阵：
  $
    hat(A) = R_c^(-1) A R_c = mat(hat(A)_(11), hat(A)_(12); 0, hat(A)_(22)), \
    hat(B) = R_c^(-1) B = vec(hat(B)_1, 0), quad hat(C) = C R_c = mat(hat(C)_1, hat(C)_2)
  $ <可控性分解>
  其中 $Sigma_c (hat(A)_(11), hat(B)_1, hat(C)_1)$ 为 $n_1$ 维*完全可控部分*，$Sigma_(overline(c)) (hat(A)_(22), 0, hat(C)_2)$ 为 $n - n_1$ 维*不可控部分*。

#figure(
  caption: [按可控性分解结构示意图],
  diagram(
    node-stroke: 1pt,
    spacing: (24pt, 20pt),
    node((0, 0), $u$, stroke: none),
    edge("-|>"),
    node((1, 0), $hat(B)_1$),
    edge("-|>"),
    node((2, 0), $+$, radius: 9pt),
    edge("-|>", $dot(hat(x))_1$),
    node((3, 0), $integral$),
    edge("rr", "-|>", $hat(x)_1$, label-pos: 0.35),
    node((5, 0), $hat(C)_1$),
    edge((5, 0), (6, 0), (6, 1.25), "-|>"),
    node((6, 1.25), $+$, radius: 9pt),
    edge("-|>", $y$),
    node((7, 1.25), [], stroke: none),
    // A11 反馈
    edge((4, 0), (4, -1.1), (3, -1.1), "-|>"),
    node((3, -1.1), $hat(A)_(11)$),
    edge((3, -1.1), (2, -1.1), (2, 0), "-|>"),
    // A12 耦合
    node((3, 1.25), $hat(A)_(12)$),
    edge((3, 1.25), (2, 1.25), (2, 0), "-|>"),
    // 不可控子系统 x2
    node((2, 2.5), $+$, radius: 9pt),
    edge("-|>", $dot(hat(x))_2$),
    node((3, 2.5), $integral$),
    edge("rr", "-|>", $hat(x)_2$, label-pos: 0.35),
    node((5, 2.5), $hat(C)_2$),
    edge((5, 2.5), (6, 2.5), (6, 1.25), "-|>"),
    // A22 反馈
    edge((4, 2.5), (4, 3.6), (3, 3.6), "-|>"),
    node((3, 3.6), $hat(A)_(22)$),
    edge((3, 3.6), (2, 3.6), (2, 2.5), "-|>"),
    // x2 分支引向 A12
    edge((4, 2.5), (4, 1.25), (3, 1.25), "-|>"),
  ),
)

#note-me.note[
  可控性分解的核心特性：
  + 不可控状态 $hat(x)_2$ 既不受 $u$ 的直接控制，也不受 $hat(x)_1$ 耦合影响；
  + 特征多项式分解为 $det(s I - A) = det(s I - hat(A)_(11)) det(s I - hat(A)_(22))$，分别为*可控振型*与*不可控振型*（输入或状态反馈无法改变不可控振型）；
  + 原系统与可控子系统具有*完全相同的传递函数阵*：
    $
      C (s I - A)^(-1) B & = mat(hat(C)_1, hat(C)_2) mat((s I - hat(A)_(11))^(-1), *; 0, (s I - hat(A)_(22))^(-1)) vec(hat(B)_1, 0) \
      & = hat(C)_1 (s I - hat(A)_(11))^(-1) hat(B)_1
    $
]

=== 典型例题

==== 例 1（二阶系统按可控性分解）

将下面系统按可控性进行结构分解：

$
  dot(x) = mat(-2, 1; 1, -2) x + vec(1, 1) u, quad y = mat(0, 1) x
$

解：$"rank" Psi_c = "rank" mat(1, -1; 1, -1) = 1 < 2$。取 $R_1 = vec(1, 1)$，补充线性无关列 $R_2 = vec(0, 1)$：

$
  R_c = mat(1, 0; 1, 1), quad R_c^(-1) = mat(1, 0; -1, 1)
$

计算得：

$
  hat(A) = R_c^(-1) A R_c = mat(-1, 1; 0, -3), quad
  hat(B) = R_c^(-1) B = vec(1, 0), quad
  hat(C) = C R_c = mat(1, 1)
$

故分解后方程为：

$
  vec(dot(hat(x))_1, dot(hat(x))_2) = mat(-1, 1; 0, -3) vec(hat(x)_1, hat(x)_2) + vec(1, 0) u, quad
  y = mat(1, 1) vec(hat(x)_1, hat(x)_2)
$

==== 例 2（三阶系统按可控性分解）

判别下列系统的可控性，若不完全可控则按可控性分解：

$
  dot(x) = mat(0, 0, -1; 1, 0, -3; 0, 1, -3) x + vec(1, 1, 0) u, quad
  y = mat(0, 1, -2) x
$

解：$Psi_c = mat(b, A b, A^2 b) = mat(1, 0, -1; 1, 1, -3; 0, 1, -2)$，可见第 3 列 $=$ 第 1 列 $times (-1) +$ 第 2 列 $times (-1)$，故 $"rank" Psi_c = 2 < 3$。取前 2 列再补 $R_3 = vec(0, 0, 1)$ 构成可逆阵：

$
  R_c = mat(1, 0, 0; 1, 1, 0; 0, 1, 1) => R_c^(-1) = mat(1, 0, 0; -1, 1, 0; 1, -1, 1)
$

计算变换后方程：

$
  hat(A) = R_c^(-1) A R_c = mat(0, -1, -1; 1, -2, -2; 0, 0, -1), \
  hat(b) = R_c^(-1) b = vec(1, 0, 0), quad hat(C) = C R_c = mat(1, -1, -2)
$

== 按可观性分解

=== 求解一般步骤

设线性定常系统不完全可观，且 $"rank" Psi_o = n_2 < n$：

+ 计算可观性判别矩阵 $Psi_o = mat(C^T, A^T C^T, ..., (A^(n - 1))^T C^T)^T$，求出其秩 $n_2$；
+ 从 $Psi_o$ 中选取 $n_2$ 个线性无关的*行向量*作为 $R_o^(-1)$ 的前 $n_2$ 行，再补充 $n - n_2$ 个行向量使 $R_o^(-1)$ 非奇异，求逆得 $R_o$；
+ 作非奇异变换 $x = R_o tilde(x)$（即 $tilde(x) = R_o^(-1) x$），计算分解后的矩阵：
  $
    tilde(A) = R_o^(-1) A R_o = mat(tilde(A)_(11), 0; tilde(A)_(21), tilde(A)_(22)), \
    tilde(B) = R_o^(-1) B = vec(tilde(B)_1, tilde(B)_2), quad tilde(C) = C R_o = mat(tilde(C)_1, 0)
  $ <可观性分解>
  其中 $Sigma_o (tilde(A)_(11), tilde(B)_1, tilde(C)_1)$ 为 $n_2$ 维*完全可观部分*，$Sigma_(overline(o)) (tilde(A)_(22), tilde(B)_2, 0)$ 为 $n - n_2$ 维*不可观部分*。

#figure(
  caption: [按可观性分解结构示意图],
  diagram(
    node-stroke: 1pt,
    spacing: (24pt, 20pt),
    node((0, 1.25), $u$, stroke: none),
    edge((0, 1.25), (0.5, 1.25), (0.5, 0), (1, 0), "-|>"),
    edge((0, 1.25), (0.5, 1.25), (0.5, 2.5), (1, 2.5), "-|>"),
    // 可观子系统 x1
    node((1, 0), $tilde(B)_1$),
    edge("-|>"),
    node((2, 0), $+$, radius: 9pt),
    edge("-|>", $dot(tilde(x))_1$),
    node((3, 0), $integral$),
    edge("rr", "-|>", $tilde(x)_1$, label-pos: 0.35),
    node((5, 0), $tilde(C)_1$),
    edge("-|>"),
    node((6, 0), $y$, stroke: none),
    // A11 反馈
    edge((4, 0), (4, -1.1), (3, -1.1), "-|>"),
    node((3, -1.1), $tilde(A)_(11)$),
    edge((3, -1.1), (2, -1.1), (2, 0), "-|>"),
    // A21 耦合
    edge((4, 0), (4, 1.25), (3, 1.25), "-|>"),
    node((3, 1.25), $tilde(A)_(21)$),
    edge((3, 1.25), (2, 1.25), (2, 2.5), "-|>"),
    // 不可观子系统 x2
    node((1, 2.5), $tilde(B)_2$),
    edge("-|>"),
    node((2, 2.5), $+$, radius: 9pt),
    edge("-|>", $dot(tilde(x))_2$),
    node((3, 2.5), $integral$),
    edge((3, 2.5), (4.7, 2.5), "-|>", $tilde(x)_2$),
    node((4.7, 2.5), [], stroke: none),
    // A22 反馈
    edge((4, 2.5), (4, 3.6), (3, 3.6), "-|>"),
    node((3, 3.6), $tilde(A)_(22)$),
    edge((3, 3.6), (2, 3.6), (2, 2.5), "-|>"),
  ),
)

=== 典型例题

==== 例 3（三阶系统按可观性分解）

对下面系统按可观性进行结构分解：

$
  dot(x) = mat(0, 1, 0; 0, 0, 1; -2, -4, -3) x + vec(0, 0, 1) u, quad
  y = mat(1, 1, 0) x
$

解：$Psi_o = mat(C; C A; C A^2) = mat(1, 1, 0; 0, 1, 1; -2, -4, -2)$，秩为 $2 < 3$。取前 2 行并补充 $mat(0, 0, 1)$ 构成 $R_o^(-1)$：

$
  R_o^(-1) = mat(1, 1, 0; 0, 1, 1; 0, 0, 1) => R_o = mat(1, -1, 1; 0, 1, -1; 0, 0, 1)
$

计算得：

$
  tilde(A) = R_o^(-1) A R_o = mat(0, 1, 0; -2, -2, 0; -2, -2, -1), \
  tilde(B) = R_o^(-1) B = vec(0, 1, 1), quad tilde(C) = C R_o = mat(1, 0, 0)
$

==== 例 4（例 2 系统按可观性分解）

判别下面系统的可观性，若不完全可观则按可观性分解：

$
  dot(x) = mat(0, 0, -1; 1, 0, -3; 0, 1, -3) x + vec(1, 1, 0) u, quad
  y = mat(0, 1, -2) x
$

解：$Psi_o = mat(C; C A; C A^2) = mat(0, 1, -2; 1, -2, 3; -2, 3, -4)$，$"rank" Psi_o = 2 < 3$。取前 2 行并补充行向量 $mat(0, 0, 1)$：

$
  R_o^(-1) = mat(0, 1, -2; 1, -2, 3; 0, 0, 1) => R_o = mat(2, 1, 1; 1, 0, 2; 0, 0, 1)
$

于是分解结果为：

$
  dot(tilde(x)) = mat(0, 1, 0; -1, -2, 0; 1, 0, -1) tilde(x) + vec(1, -1, 0) u, quad
  y = mat(1, 0, 0) tilde(x)
$

== 按可控性和可观性分解（Kalman 分解）

=== 求解一般步骤（两步逐步分解法）

若系统既不完全可控也不完全可观，通过以下两步即可化为四分块结构：

+ *第一步（先按可控性分解）*：构造 $R_c$ 将原系统分解为可控子系统 $Sigma_c (overline(A)_1, overline(B)_1, overline(C)_1)$（维数 $n_1$）与不可控子系统 $Sigma_(overline(c)) (overline(A)_4, 0, overline(C)_2)$（维数 $n - n_1$）；
+ *第二步（再分别按可观性分解）*：
  - 若 $Sigma_c$ 不完全可观（可观矩阵秩为 $r_1 < n_1$），构造 $R_(o 1)^(-1) in RR^(n_1 times n_1)$ 将 $Sigma_c$ 分解为*可控可观* $Sigma_1 (A_(11), B_1, C_1)$ 与*可控不可观* $Sigma_2 (A_(22), B_2, 0)$；
  - 若 $Sigma_(overline(c))$ 不完全可观（可观矩阵秩为 $r_2 < n - n_1$），构造 $R_(o 2)^(-1) in RR^((n - n_1) times (n - n_1))$ 将 $Sigma_(overline(c))$ 分解为*不可控可观* $Sigma_3 (A_(33), 0, C_3)$ 与*不可控不可观* $Sigma_4 (A_(44), 0, 0)$；
  （综合变换矩阵为 $R = R_c "diag"(R_(o 1), R_(o 2))$。）

=== Kalman 四分块标准结构

/ 定理 2(Kalman 结构分解定理): 任意线性定常系统均可经非奇异线性变换 $x = R overline(x)$ 化为如下标准分解形式：
  $
    vec(dot(x)_(c o), dot(x)_(c overline(o)), dot(x)_(overline(c) o), dot(x)_(overline(c) overline(o))) = mat(
      A_(11), 0, A_(13), 0;
      A_(21), A_(22), A_(23), A_(24);
      0, 0, A_(33), 0;
      0, 0, A_(43), A_(44)
    ) vec(x_(c o), x_(c overline(o)), x_(overline(c) o), x_(overline(c) overline(o))) + vec(B_1, B_2, 0, 0) u \
    y = mat(C_1, 0, C_3, 0) vec(x_(c o), x_(c overline(o)), x_(overline(c) o), x_(overline(c) overline(o)))
  $ <Kalman结构分解>

#figure(
  caption: [Kalman 四分块结构分解示意图（输入到输出仅通过 $Sigma_1$ 单向通道）],
  diagram(
    node-stroke: 1pt,
    spacing: (26pt, 22pt),
    // 输入 u
    node((-0.9, 1.0), $u$, stroke: none),
    edge((-0.9, 1.0), (-0.2, 1.0), (-0.2, 0), (0.5, 0), "-|>"),
    edge((-0.9, 1.0), (-0.2, 1.0), (-0.2, 2.0), (0.5, 2.0), "-|>"),

    // Sigma 1 (co)
    node((0.5, 0), $B_1$),
    edge("-|>"),
    node((1.5, 0), $+$, radius: 8pt, name: <sum1>),
    edge("-|>"),
    node((3.0, 0), $Sigma_1 (A_(11), B_1, C_1)$, name: <s1>),
    edge((3.0, 0), (5.3, 0), "-|>", $x_(c o)$, label-pos: 0.45),
    node((5.3, 0), $C_1$),
    edge((5.3, 0), (6.3, 0), (6.3, 2.0), "-|>"),

    // Sigma 2 (c obar)
    node((0.5, 2.0), $B_2$),
    edge("-|>"),
    node((1.5, 2.0), $+$, radius: 8pt, name: <sum2>),
    edge("-|>"),
    node((3.0, 2.0), $Sigma_2 (A_(22), B_2, 0)$, name: <s2>),

    // 输出求和
    node((6.3, 2.0), $+$, radius: 9pt),
    edge("-|>", $y$),
    node((7.1, 2.0), [], stroke: none),

    // Sigma 3 (cbar o)
    node((3.0, 4.0), $Sigma_3 (A_(33), 0, C_3)$, name: <s3>),
    edge((3.0, 4.0), (5.3, 4.0), "-|>", $x_(overline(c) o)$, label-pos: 0.45),
    node((5.3, 4.0), $C_3$),
    edge((5.3, 4.0), (6.3, 4.0), (6.3, 2.0), "-|>"),

    // Sigma 4 (cbar obar)
    node((3.0, 6.0), $Sigma_4 (A_(44), 0, 0)$, name: <s4>),

    // 5 条单向耦合通道
    node((3.0, 1.0), $A_(21)$, name: <a21>),
    edge((4.4, 0), (4.4, 1.0), <a21>, "-|>"),
    edge(<a21>, (1.5, 1.0), <sum2>, "-|>"),

    node((4.7, 2.0), $A_(13)$, name: <a13>),
    edge((4.7, 4.0), <a13>, "-|>"),
    edge(<a13>, (4.7, 0.55), (1.5, 0.55), <sum1>, "-|>"),

    node((3.0, 3.0), $A_(23)$, name: <a23>),
    edge((4.2, 4.0), (4.2, 3.0), <a23>, "-|>"),
    edge(<a23>, (1.65, 3.0), (1.65, 2.35), <sum2>, "-|>"),

    node((1.1, 4.0), $A_(24)$, name: <a24>),
    edge(<s4>, (1.1, 6.0), <a24>, "-|>"),
    edge(<a24>, (1.1, 2.35), (1.38, 2.35), <sum2>, "-|>"),

    node((3.0, 5.0), $A_(43)$, name: <a43>),
    edge(<s3>, <a43>, "-|>"),
    edge(<a43>, <s4>, "-|>"),
  ),
)

#note-me.important[
  由结构图可见，输入 $u$ 到输出 $y$ 仅存在唯一通道 $u -> B_1 -> Sigma_1 -> C_1 -> y$，因此系统传递函数阵仅反映*可控且可观子系统 $Sigma_1$* 的动态特性：
  $
    W(s) = C (s I - A)^(-1) B = C_1 (s I - A_(11))^(-1) B_1
  $
  传递函数阵是系统的不完全描述；对应同一传递函数阵的所有实现中，维数最小的即是完全可控且完全可观的*最小实现*。
]

#figure(
  caption: [线性系统三类结构分解对比汇总],
  table(
    columns: (auto, 118pt, 130pt, 130pt),
    [分解类型], [变换阵构造方法], [分块零元素位置], [传递函数保持],
    [按可控性分解],
    [$R_c$ 前 $n_1$ 列取自 $Psi_c$ 无关列],
    [$hat(A)_(21) = 0, hat(B)_2 = 0$],
    [由可控部分 $(hat(A)_(11), hat(B)_1, hat(C)_1)$ 决定],

    [按可观性分解],
    [$R_o^(-1)$ 前 $n_2$ 行取自 $Psi_o$ 无关行],
    [$tilde(A)_(12) = 0, tilde(C)_2 = 0$],
    [由可观部分 $(tilde(A)_(11), tilde(B)_1, tilde(C)_1)$ 决定],

    [Kalman 分解],
    [先 $R_c$ 再分别 $R_(o 1), R_(o 2)$],
    [仅 $u -> Sigma_1 -> y$ 贯通],
    [仅由*可控可观*部分 $(A_(11), B_1, C_1)$ 决定],
  ),
)

=== 典型例题

==== 例 5（三阶系统的 Kalman 结构分解）

已知 SISO 线性定常系统：

$
  dot(x) = mat(0, 0, -1; 1, 0, -3; 0, 1, -3) x + vec(1, 1, 0) u, quad
  y = mat(0, 1, -2) x
$

试将其按可控性和可观性进行结构分解。

解：
+ *第一步（可控性分解）*：在例 2 中已求得 $R_c = mat(1, 0, 0; 1, 1, 0; 0, 1, 1)$，分解结果为：
  $
    vec(dot(x)_c, dot(x)_(overline(c))) = mat(0, -1, -1; 1, -2, -2; 0, 0, -1) vec(x_c, x_(overline(c))) + vec(1, 0, 0) u, quad
    y = mat(1, -1, -2) vec(x_c, x_(overline(c)))
  $
  其中不可控子空间 $x_(overline(c))$ 为 1 维且输出系数 $-2 != 0$（已可观），无需再分。

+ *第二步（对可控子系统 $Sigma_c$ 按可观性分解）*：
  考察 $Sigma_c$（$overline(A)_1 = mat(0, -1; 1, -2), overline(C)_1 = mat(1, -1)$），其可观性矩阵为 $mat(1, -1; -1, 1)$，秩为 $1 < 2$。构造非奇异阵：
  $
    R_(o 1)^(-1) = mat(1, -1; 0, 1) => R_(o 1) = mat(1, 1; 0, 1)
  $
  对 $Sigma_c$ 实施变换（同时变换耦合项与输入输出）：
  $
    R_(o 1)^(-1) mat(0, -1; 1, -2) R_(o 1) = mat(-1, 0; 1, -1), quad
    R_(o 1)^(-1) vec(-1, -2) = vec(1, -2), \
    R_(o 1)^(-1) vec(1, 0) = vec(1, 0), quad
    mat(1, -1) R_(o 1) = mat(1, 0)
  $

+ *综合分解结果*：
  $
    vec(dot(x)_(c o), dot(x)_(c overline(o)), dot(x)_(overline(c) o)) = mat(
      -1, 0, 1;
      1, -1, -2;
      0, 0, -1
    ) vec(x_(c o), x_(c overline(o)), x_(overline(c) o)) + vec(1, 0, 0) u, quad
    y = mat(1, 0, -2) vec(x_(c o), x_(c overline(o)), x_(overline(c) o))
  $
  由此可见原系统最小实现仅为一阶系统 $dot(x)_(c o) = -x_(c o) + u, quad y = x_(c o)$，传递函数为 $W(s) = frac(1, s + 1)$。
