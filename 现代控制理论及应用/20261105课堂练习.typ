#import "../template.typ": note
#show: note.with()

= 第一题

$
  J = integral^1_0 dot(x)(t) + 12t dot(x)(t) dif t
$

$x(0)=1, x(1)$ 自由。求泛函取到极值时的最优轨线。

解：

被积函数为 $L = (1 + 12t) dot(x)$，因此

$
  frac(partial L, partial x) = 0, quad
  frac(partial L, partial dot(x)) = 1 + 12t.
$

由欧拉方程应有

$
  frac(partial L, partial x)
  - frac(dif, dif t) frac(partial L, partial dot(x))
  = -12 = 0,
$

矛盾。因此，*按原式不存在使泛函取到极值的轨线*。

#pagebreak()
= 第二题

$
  J = integral^(pi/2)_0 2x_1 x_2+ dot(x)_1^2 + dot(x)_2^2 dif t \
  vec(x_1(0), x_2(0))=vec(0, 0), vec(x_1(pi/2), x_2(pi/2))=vec(1, -1)
$

求泛函取到极值时的最优轨线。

解：

== 建立欧拉方程

令 $L = 2x_1 x_2 + dot(x)_1^2 + dot(x)_2^2$，对 $x_1, x_2$ 分别列写欧拉方程，得

$
  cases(
    2x_2 - 2 x''_1 = 0,
    2x_1 - 2 x''_2 = 0,
  )
  => cases(
    x''_1 = x_2,
    x''_2 = x_1.
  )
$

== 解耦并代入边界条件

令 $u = x_1 + x_2, v = x_1 - x_2$，则

$
  u'' = u, quad v'' = -v.
$

对应的边界条件为

$
  u(0) = 0, quad u(pi/2) = 0, quad
  v(0) = 0, quad v(pi/2) = 2.
$

由 $u(t) = A e^t + B e^(-t)$ 及两端边界条件得 $A = B = 0$，故 $u(t) = 0$。

由 $v(t) = C cos t + D sin t$ 及边界条件得 $C = 0, D = 2$，故 $v(t) = 2 sin t$。

于是最优轨线为

$
  cases(
    x_1^*(t) = (u(t) + v(t))/2 = sin t,
    x_2^*(t) = (u(t) - v(t))/2 = -sin t,
  )
  quad 0 <= t <= pi/2.
$
