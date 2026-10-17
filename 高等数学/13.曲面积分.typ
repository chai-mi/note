#import "../template.typ": note
#show: note.with()

== 第一型曲面积分

$
  integral.double_Sigma f(x,y,z) dif S & = integral.double_(D_(x y)) f(x,y,z(x,y)) sqrt(1+z_x^2+z_y^2) dif x dif y \
                                       & = integral.double_(D_(u v)) f(x(u,v),y(u,v),z(u,v)) sqrt(E G-F^2) dif u dif v \
   "其中" cases(
     E = x'_u^2+y'_u^2+z'_u^2,
     G = x'_v^2+y'_v^2+z'_v^2,
     F = x'_u x'_v+y'_u y'_v+z'_u z'_v
   )
$

== 第二型曲面积分

$
  integral.double_Sigma arrow(f)(x,y,z) dot dif arrow(S) & = integral.double_Sigma vec(P, Q, R) dot vec(cos alpha, cos beta, cos gamma) dif S \
  & = integral.double_Sigma P dif y dif z + Q dif z dif x + R dif x dif y
$

其中

$
  dif arrow(S) = arrow(n^0) dif S = vec(cos alpha dif S, cos beta dif S, cos gamma dif S) = vec(dif y dif z, dif x dif z, dif x dif y)
$

$
  integral.double_Sigma R(x,y,z) dif x dif y = plus.minus integral.double_D_(x y) R(x,y,z(x,y)) dif x dif y "上正下负"
$

=== 哈密顿向量微分算子

$
  gradient = partial/(partial x) arrow(i) + partial/(partial y) arrow(j) + partial/(partial z) arrow(k)
$

=== 梯度

$
  "grad" arrow(f) = gradient arrow(f) = (partial P)/(partial x) arrow(i) + (partial Q)/(partial y) arrow(j) + (partial R)/(partial z) arrow(k)
$

=== 散度

$
  "div" arrow(f) = gradient dot arrow(f)
$

=== 旋度

$
  "curl" arrow(f) = "rot" arrow(f) = gradient times arrow(f)
$

=== 高斯公式

$
  integral.surf_Sigma arrow(f) dot dif arrow(S) = integral.triple_Phi gradient dot arrow(f) dif V
$

=== 斯托克斯公式

$
  integral.cont.ccw_(partial Sigma) arrow(f) dot dif arrow(s) & = integral.double_Sigma gradient times arrow(f) dif arrow(S) \
  & = integral.double_Sigma mat(delim: "|", dif y dif z, dif z dif x, dif x dif y; partial/(partial x), partial/(partial y), partial/(partial z); P, Q, R)
$

$partial Sigma$ 和 $arrow(S)$ 服从右手定则
