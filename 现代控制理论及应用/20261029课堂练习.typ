#import "../template.typ": note
#show: note.with()

= 第一题

计算泛函 $J=integral^1_0 x^2(t) dif t$ 的变分

解：

令扰动后的函数为 $x_a(t)=x(t)+a delta x(t)$，则

$
  J[x+a delta x] & = integral^1_0 (x+a delta x)^2 dif t \
                 & = J[x]+2a integral^1_0 x delta x dif t
                   +a^2 integral^1_0 (delta x)^2 dif t
$

第一变分是上式关于 $a$ 在 $a=0$ 处的导数，因此

$
  delta J = 2 integral^1_0 x(t) delta x(t) dif t.
$

#pagebreak()
= 第二题

求泛函 $J=integral^(pi/2)_0 dot(x)^2 - x^2 dif t$ 在边界条件 $x(0)=1, x(pi/2)=2$ 下的极值曲线

解：

$
  frac(partial L, partial x) - frac(dif, dif t) frac(partial L, partial dot(x)) & = 0 \
                                                       -2x- dif/(dif t) 2dot(x) & = 0 \
                                                                          x''+x & = 0 \
                                                                              x & = C_1 cos(t) + C_2 sin(t)
$

由边界条件得

$
     x(0) & = C_1 = 1 \
  x(pi/2) & = C_2 = 2.
$

因此极值曲线为

$
  x(t)=cos(t)+2sin(t).
$

#pagebreak()
= 第三题

已知泛函 $J=integral^1_0 dot(x)^2+1 dif t$ 求下列边界条件情况的极值曲线

+ $x(0)=1,x(1)=2$
+ $x(0)=1,x(1) "未定"$

解：

$
  frac(partial L, partial x) - frac(dif, dif t) frac(partial L, partial dot(x)) & = 0 \
                                                                         -2 x'' & = 0 \
                                                                              x & = k t+ b
$

+ 由 $x(0)=1$、$x(1)=2$ 得 $b=1$、$k=1$，故

  $
    x(t)=t+1.
  $

+ 由 $x(0)=1$ 得 $b=1$，故 $x(t)=k t+1$。由于终点值自由，还需满足自然边界条件。

  第一变分经分部积分得

  $
    delta J & = 2 integral^1_0 dot(x) delta dot(x) dif t \
            & = [2 dot(x) delta x]_0^1
              -2 integral^1_0 x'' delta x dif t.
  $

  起点固定，所以 $delta x(0)=0$；终点值自由，所以 $delta x(1)$ 可以任意取值。
  结合 $x''=0$，要使 $delta J=0$，必须有

  $
    2 dot(x)(1) delta x(1)=0
    quad => quad dot(x)(1)=0.
  $

  因此 $k=0$，所求极值曲线为

  $
    x(t)=1.
  $

  此时 $J=1$。由于 $dot(x)^2 >= 0$，总有 $J >= 1$，故该曲线确实取得最小值。
