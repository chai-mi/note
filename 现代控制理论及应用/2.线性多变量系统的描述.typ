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

#pagebreak()
= 状态空间描述与传递矩阵之间的转换

对于*线性定常系统*，描述其运动规律的数学模型有三种常用形式

+ 传递函数
+ 输入输出微分方程
+ 状态方程

== 由系统的状态方程求传递函数

$
  cases(
    dot(x)(t) = A x(t) + b u(t),
    y(t) = C x(t) + d u(t)
  )
$

设 $x(t)$ 的初值为 $0$，进行拉氏变换,得到

$
  cases(
    (s I -A)X(s) = b u(s),
    y(s) = C X(s) + d u(s)
  )
$

消去 $X(s)$,得到系统的传递函数为

$
  g_(y u)(s) & = C[s I-A]^(-1)b+d \
             & = C "adj"[s I-A]/("det"[s I-A])b+d
$

== 系统传递函数阵的不变性

引入等价变换 $z(t)=P x(t)$ (矩阵 $P$ 可逆），则系统状态空间方程*传递函数阵保持不变*

$
  cases(
    dot(z)(t) = P A P^(-1) x(t) + P B u(t),
    y(t) = C P^(-1) x(t) + D u(t)
  )
$

$
  overline(G)(s) & = overline(C)(s I-overline(A))^(-1) overline(B) + overline(D) \
                 & = C P^(-1) (s I - P A P^(-1))^(-1) P B+D \
                 & = C (s I-A)^(-1) B + D \
                 & = G(s)
$

== 系统的实现问题

由描述系统输入输出动态关系的微分方程或传递函数，建立系统的状态空间表达式，这样的问题称为*实现问题*

设系统传递函数为

$
  y^((n)) + a_(n-1) y^((n-1)) + dots.c + a_0 y = b_m u^((m)) + dots.c + b_0
$ <传递函数>

=== 方法一

选取状态变量 $x_1$ 满足

$
  x_1^((n)) + a_(n-1) x_1^((n-1)) + ... + a_1 dot(x)_1 + a_0 x_1 = u
$

再选取其他状态变量

$
  cases(
    x_2 = dot(x)_1,
    x_3 = dot(x)_2,
    dots.v,
    x_n = dot(x)_(n-1)
  )
$

故

$
  x_(m+1)^((n)) + a_(n-1) x_(m+1)^((n-1)) + ... + a_(m+1) dot(x)_(m+1) + a_0 x_(m+1) = u^((m))
$

代入@传递函数 得

$
  & y^((n)) + a_(n-1) y^((n-1)) + dots.c + a_0 y \
  & = b_m (x_(m+1)^((n)) + a_(n-1) x_(m+1)^((n-1)) + ... + a_(m+1) dot(x)_(m+1) + a_0 x_(m+1)) \
  & + b_(m-1) (x_(m)^((n)) + a_(n-1) x_(m)^((n-1)) + ... + a_(m) dot(x)_(m+1) + a_0 x_(m)) \
  & + b_0 (x_1^((n)) + a_(n-1) x_1^((n-1)) + ... + a_1 dot(x)_1 + a_0 x_1)
$

则有

$
  y = b_0 x_1 + dots.c + b_(m-1) x_m + b_m x_(m+1)
$

$
  A & = mat(
        0, 1, 0, dots.c, 0;
        0, 0, 1, dots.down, dots.v;
        dots.v, dots.down, dots.down, dots.down, 0;
        0, dots.c, 0, 0, 1;
        -a_0, -a_1, dots.c, dots.c, -a_(n-1)
      ) \
  b & = vec(0, 0, dots.v, 0, 1) \
  c & = mat(b_0, b_1, dots.c, b_m, underbrace(0 dots.c 0, n-(m+1))) \
  d & = 0
$

当 $m=n$ 时, $A$ 和 $b$ 的表达式与上面相同, $c$ 和 $d$ 分别为

$
  c & = mat((b_0-b_n a_0), (b_1-b_n a_1), dots.c, (b_(n-1)-b_n a_(n-1))) \
  d & = b_n
$

=== 方法二

选取状态变量

$
  cases(
    x_1 = y - beta_0 u,
    x_2 = dot(x)_1 - beta_1 u = dot(y) - beta_0 dot(u) - beta_1 u,
    dots.v,
    x_n = dot(x)_(n-1) - beta_(n-1) u = y^((n-1)) - beta_0 u^((n-1)) - dots.c - beta_(n-1) u,
  )
$

$
  cases(
    beta_0 = b_n,
    beta_1 = b_(n-1) - a_(n-1) beta_0,
    dots.v,
    beta_n = b_0 - a_(n-1) beta_(n-1) - dots.c - a_0 beta_0
  ) \
  dot(x)_n = - a_(n-1) x_n - dots.c - a_1 x_2 - a_0 x_1
$

$
  dot(X) = mat(
    0, 1, 0, dots.c, 0;
    0, 0, 1, dots.down, dots.v;
    dots.v, dots.down, dots.down, dots.down, 0;
    0, dots.c, 0, 0, 1;
    -a_0, -a_1, dots.c, dots.c, -a_(n-1)
  ) X + vec(beta_1, dots.v, dots.v, dots.v, beta_n) u \
  y = x_1 + beta_0 u
$

= 线性离散系统的描述

离散系统在初始条件 ${y(0), y(1), ... , y(n-1)}$ 下 , 可以用下列定常差分方程表示其输入-输出关系

$
  & y(k+n) + a_(n-1) y(k+n-1) + ... + a_0 y(k) \
  & = b_n u(k+n) + ... + b_0 u(k)
$ <定常差分方程>


在零初始条件下, 对@定常差分方程 取Z变换, 得到

$
  & z^n Y(z) + ... + a_0 Y(z) \
  & = b_n z^n U(z) + ... + b_0 U(z)
$

$
  cases(
    x(k+1) = G x(k) + H u(k),
    y(k) = C x(k) + D u(k)
  )
$

$
  Y(z)/U(z) = C (z I-G)^(-1)H + D
$
