#import "../template.typ": note
#show: note.with()

== 第一型曲线积分

$
  integral_L f(x,y,z) dif s = integral_L f(x(t),y(t),z(t)) sqrt([x'(t)^2]+[y'(t)^2]+[z'(t)^2]) dif t \
  dif s = sqrt((dif x)^2+(dif y)^2+(dif z)^2)
$

== 第二型曲线积分

=== 向量场

$
  arrow(f)(x,y,z)=P(x,y,z)arrow(i)+Q(x,y,z)arrow(j)+R(x,y,z)arrow(k)
$

=== 第二型曲线积分

$
  integral_L arrow(f)(x,y) dif arrow(s) & = integral_L P(x,y) dif x + Q(x,y) dif y \
  & = integral_L P(x,y) dif x + integral_L Q(x,y) dif y \
  & = integral^beta_alpha P(x(t),y(t)) x'(t) dif t + integral^beta_alpha Q(x(t),y(t)) y'(t) dif t \
  & = integral_L arrow(f)(x,y) dot arrow(e_t) dif s
$

=== GREEN 公式


设 $P(x,y),Q(x,y)$ 是平面有界闭区域 $D$ 上的 $C^1$ 函数（一阶偏导数都连续的函数称为 $C^1$ 函数），
$D$ 的边界 $partial D$ 由光滑或逐段光滑的简单闭曲线组成并约定 $partial D$ 的正方向是沿此方向前进时区域 $D$ 在其左侧，则

$
  integral.cont_L P dif x + Q dif y = integral.double_Sigma ((partial Q)/(partial x)-(partial P)/(partial y)) dif x dif y
$

===

$
  f(x_2,y_2) - f(x_1,y_1) = integral^((x_2,y_2))_((x_1,y_1)) f_x dif x + f_y dif y
$

== 傅里叶级数

若 $f(x)$ 是定义在区间上的 $-L<x<L$ 函数，一般来说，可以展开为三角级数

$
  f(x) & = a_0/2 + sum^(infinity)_(k=1) (a_k cos (k pi x)/L + b_k sin (k pi x)/L) \
       & = (f(x-0)+f(x+0))/2
$

$
  cases(
    a_k=1/L integral^L_(-L) f(x) cos (k pi x)/L dif x,
    b_k=1/L integral^L_(-L) f(x) sin (k pi x)/L dif x
  )
$
