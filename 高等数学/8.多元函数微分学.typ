#import "../template.typ": note
#show: note.with()

== 邻域
点$P_0 (x_0,y_0)$的$delta$邻域：
$
  N(P_0,delta)={(x,y)|sqrt((x-x_0)^2+(y-y_0)^2)<delta}
$

点$P_0 (x_0,y_0)$的去心$delta$邻域：
$
  N(P_0,delta)={(x,y)|0<sqrt((x-x_0)^2+(y-y_0)^2)<delta}
$

== 多元函数的极限

$
  lim_((x,y)->(x_0,y_0)) f(x,y) = A
$

== 多元函数的连续性

$
  lim_((x,y)->(x_0,y_0)) f(x,y) = f(x_0,y_0)
$

=== 例题

$
  f(x,y)=cases((x y)/(x^2+y^2) "if" x^2+y^2!=0, 0 "if" x^2+y^2!=0) 在 (0,0) "是否连续？" \
  lim_(x->0,y=k x) (x y)/(x^2+y^2) = lim_(x->0,y=k x) (k x^2)/(x^2+k x^2) = 1/(1+k^2) \
  故 f(x,y) "在原点无极限，因此不连续"
$

== 偏导

$
  (partial f)/(partial x) |_((x_0,y_0)) = lim_(Delta x -> 0) (f(x_0+Delta x,y_0)-f(x_0,y_0))/(Delta x)
$

== 可微

$
  lim_((x,y)->(x_0,y_0)) (f(x,y)-f(x_0,y_0)-f_x (x_0,y_0)x-f_y (x_0,y_0)y)/sqrt(x^2+y^2) = 0
$

=== 方向导数

$
  (partial f)/(partial l) = lim_(rho -> 0^+) (f(x+rho cos theta,y+rho sin theta)-f(x,y))/rho
$

=== 梯度

$
  gradient f(x,y) = vec(f_x, f_y)
$

== 切线与法平面

=== 空间曲线

$
  L:=cases(x=x(t), y=y(t), z=z(t)) \
  "切向量: " arrow(l)=vec(x'(t), y'(t), z'(t), delim: "[") \
  "切线: " (x-x(t_0))/(x'(t_0))=(y-y(t_0))/(y'(t_0))=(z-z(t_0))/(z'(z_0)) \
  "法平面: " x'(t_0)(x-x(t_0)) + y'(t_0)(y-y(t_0)) + z'(t_0)(z-z(t_0)) = 0
$

=== 空间曲面

$
  F(x,y,z)=0\
  "法向量: " arrow(S) = vec(F_x, F_y, F_z, delim: "[") = gradient F \
  "法线方程: " (x-x_0)/(F_x (x_0,y_0,z_0))=(y-y_0)/(F_y (x_0,y_0,z_0))=(z-z_0)/(F_z (x_0,y_0,z_0)) \
  "切平面: " F_x (x_0,y_0,z_0)(x-x_0)+F_y (x_0,y_0,z_0)(y-y_0)+F_z (x_0,y_0,z_0)(z-z_0)=0
$

== 驻点

$
  gradient f = 0
$

=== 黑塞行列式

$
  H = mat(delim: "|", f_(x x), f_(x y); f_(y x), f_(y y)) \
  cases(H>0 "是极点, " f_(x x)<0 "为极大值点", H<0 "是鞍点", H=0 "不能确定")
$

== 拉格朗日乘子法

在条件 $phi (x,y)=0$ 下，求 $z=f(x,y)$ 的极值点

设 $F(x,y,lambda)= f+lambda phi$，解方程

$
  gradient F =vec(delim: "[", F_x, F_y, F_lambda)= arrow(0)
$

即为极值点

== 泰勒公式

$
  f(x,y)& = f(x_0,y_0) \
  & + (partial f(x_0,y_0))/(partial x)(x-x_0) + (partial f(x_0,y_0))/(partial y)(y-y_0) \
  & + 1/2![(partial^2 f(x_0,y_0))/(partial x^2)(x-x_0)^2 + 2(partial^2 f(x_0,y_0))/(partial x partial y)(x-x_0)(y-y_0) + (partial^2 f(x_0,y_0))/(partial y^2)(y-y_0)^2] \
  & + R_2
$

=== 拉格朗日余项

$
  R_2 = 1/3![(partial^3 f(xi,eta))/(partial x^3)(x-x_0)^3 + 3(partial^3 f(xi,eta))/(partial x^2 partial y)(x-x_0)^2(y-y_0) \
    + 3(partial^3 f(xi,eta))/(partial x partial y^2)(x-x_0)(y-y_0)^2 + (partial^3 f(xi,eta))/(partial y^3)(y-y_0)^3]
$

=== 皮埃诺余项

$
  R_2 = o(sqrt((x-x_0)^2+(y-y_0)^2))
$
