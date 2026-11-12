#import "../template.typ": note
#show: note.with()

= 第一题

$
  cases(
    dot(x)_1=-x_2+u "," x_1(0)=x_1^0,
    dot(x)_2=-u "," x_2(0)=x_2^0,
  ) \
  underline(u) <= u <= overline(u)\
  J = integral^T_0 2x_1+u dif t
$

解：

$
  H & = 2x_1+u + lambda_1 (-x_2+u) - lambda_2 u \
    & = 2x_1-lambda_1 x_2 + (1+lambda_1-lambda_2) u
$ <H>

$
  cases(
    dot(lambda)_1 = -2,
    dot(lambda)_2 = lambda_1
  )
$

由于 $lambda(t_T)=0$，解微分方程得

$
  cases(
    lambda_1 = -2 t + 2 T,
    lambda_2 = -(t-T)^2
  )
$

代入@H 得

$
  H = 2x_1-lambda_1 x_2 + (1-t+T)^2 u
$

因为 $(1-t+T)^2>=0$，取 $u^*=underline(u)$，后求解步骤略

#pagebreak()
= 第二题

$
  cases(
    dot(x)_1(t) = x_2(t) + 1/4 "," x_1(0)=-1/4,
    dot(x)_2(t) = u(t) "," x_2(0)=-1/4
  ) \
  |u(t)| <= 1/2 \
  J = integral_0^(t_f) u^2(t) dif t \
  x_1(t_f)=x_2(t_f)=0 "," t_f "自由"
$

解：本题不存在有限终端时间的最优解；性能指标的下确界为 $0$，但不能取到。

== 构造可行控制并求下确界

+ 将末端状态条件化为积分约束。由状态方程得
  $
    x_2(t) & = -1/4 + integral_0^t u(s) dif s, \
    x_1(t) & = -1/4 + integral_0^t (t-s)u(s) dif s.
  $
  因此，末端状态位于原点等价于
  $
    cases(
      integral_0^(t_f) u(t) dif t = 1/4,
      integral_0^(t_f) (t_f-t)u(t) dif t = 1/4.
    )
  $

+ 构造一次函数控制 $u(t)=a+b t$。代入上述约束得
  $
    cases(
      a t_f + (b t_f^2)/2 = 1/4,
      (a t_f^2)/2 + (b t_f^3)/6 = 1/4.
    )
  $
  解得
  $
    a=(3-t_f)/(2t_f^2), quad b=(3(t_f-2))/(2t_f^3).
  $
  所以，对每个给定的 $t_f$，取
  $
    u_(t_f)(t) = (3-t_f)/(2t_f^2) + (3(t_f-2))/(2t_f^3) t.
  $

+ 验证控制幅值约束。上述控制是一次函数，只需检查端点：
  $
    u_(t_f)(0)=(3-t_f)/(2t_f^2), quad
    u_(t_f)(t_f)=(2t_f-3)/(2t_f^2).
  $
  当 $t_f >= 2$ 时，两端点均位于 $[-1/2,1/2]$，故全程满足 $|u_(t_f)(t)| <= 1/2$。因此可令 $t_f$ 任意增大，仍保持控制可行。

+ 计算这族可行控制的性能指标：
  $
    J(t_f) & = integral_0^(t_f) (a+b t)^2 dif t \
           & = a^2 t_f + a b t_f^2 + (b^2 t_f^3)/3 \
           & = (t_f^2-3t_f+3)/(4t_f^3).
  $
  由于任意可行控制均有 $J >= 0$，且
  $
    lim_(t_f -> infinity) J(t_f)=0,
  $
  故
  $
    inf J=0.
  $

+ 证明下确界不能取到。若某个有限终端时间的可行控制使 $J=0$，则 $u(t)=0$ 几乎处处。此时
  $
    x_2(t) equiv -1/4, quad
    dot(x)_1(t)=x_2(t)+1/4=0,
  $
  从而 $x_1(t) equiv -1/4$，不能满足末端状态位于原点的条件，矛盾。

因此，本题只有趋近下确界的可行控制序列，没有达到下确界的最优控制。不能将 $t_f=infinity$ 写成一个可行的最优终端时间。

== 可行控制例：固定取 $t_f=2$

上述构造给出
$
  u(t)=1/8, quad
  x_2(t)=-1/4+t/8, quad
  x_1(t)=-1/4+t^2/16.
$
此时 $x_1(2)=x_2(2)=0$，且
$
  J=integral_0^2 (1/8)^2 dif t=1/32.
$
这只是自由终端时间问题的一个可行方案；增大终端时间可使性能指标继续趋近于 $0$。

== 极小值原理与末端条件

Hamilton 函数为
$
  H=u^2+lambda_1(x_2+1/4)+lambda_2 u.
$
协态方程为
$
  cases(
    dot(lambda)_1=-frac(partial H, partial x_1)=0,
    dot(lambda)_2=-frac(partial H, partial x_2)=-lambda_1.
  )
$
因此
$
  lambda_1=c_1, quad lambda_2=-c_1 t+c_2.
$
由 $H$ 对控制量取最小值得
$
  u^*(t)=cases(
    -1/2, & lambda_2(t)>1,
    -lambda_2(t)/2, & |lambda_2(t)|<=1,
    1/2, & lambda_2(t)<-1.
  )
$

本题末端状态固定，不能令 $lambda(t_f)=0$；末端时间自由、末端代价为零且终点不显含时间，故正常型必要条件中应采用
$
  H(t_f)=0.
$

上述条件只是最优解存在时的必要条件，不能代替最优解存在性的判断。本题由前面的可行控制构造与反证，已证明最优解不存在。

#pagebreak()
= 第三题

解：

$
  H=1+lambda_1x_2+lambda_2 u
$

$
  cases(
    lambda_1=c_1,
    lambda_2=c_2-c_1t
  )
$

$
  u^*=cases(
    -1"," & lambda_2(t)>0,
    1"," & lambda_2(t)<0
  )
$
