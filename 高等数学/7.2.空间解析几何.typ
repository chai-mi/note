#import "../template.typ": note
#show: note.with()

== 向量

=== 叉积/外积

$
  arrow(a) times arrow(b) = mat(delim: "|", i, j, k; a_1, a_2, a_3; b_1, b_2, b_3)
$

=== 混合积

$
  [arrow(a),arrow(b),arrow(c)] = (arrow(a) times arrow(b)) dot arrow(c)
$

== 平面

=== 向量式

$
  (x_0,y_0,z_0) + c_1 arrow(r_1) + c_2 arrow(r_2)
$

=== 点法式

$
  A(x-x_0)+B(y-y_0)+C(z-z_0) = 0
$

=== 一般式

$
  A x+B y+C z+D = 0
$

=== 截距式

$
  x/a+y/b+z/c=1
$

=== 平面交角

$
  设 cases(A_1 x+B_1 y+C_1 z+D_1=0, A_2 x+B_2 y+C_2 z+D_2=0) \
  "则法向量为" arrow(n_1)={A_1,B_1,C_1}, arrow(n_2)={A_2,B_2,C_2} \
  "交角的余弦" cos theta = abs(cos (arrow(n_1),arrow(n_2))) = abs(A_1A_2+B_1B_2+C_1C_2)/(sqrt(A_1^2+B_1^2+C_1^2)sqrt(A_2^2+B_2^2+C_1^2))
$

=== 点到平面的距离

$
  P_0 (x_0,y_0,z_0) in.not A x+B y+C z+D=0 \
  d= abs(A x_0+B y_0+C z_0+D)/sqrt(A^2+B^2+C^2)
$

== 直线

=== 向量式

$
  arrow(r)=arrow(r_0)+t arrow(l)
$

=== 参数式

$
  cases(x=x_0+t l_1, y=y_0+t l_2, z=z_0+t l_3)
$

=== 点向式

$
  (x_x_0)/l_1=(y_y_0)/l_2=(z-z_0)/l_3
$

=== 两点式

$
  (x_x_0)/(x_2-x_1)=(y_y_0)/(y_2-y_1)=(z-z_0)/(z_2-z_1)
$

=== 一般式

$
  cases(A_1 x+B_1 y+C_1 z+D_1=0, A_2 x+B_2 y+C_2 z+D_2=0)
$

== 曲面

$
  F(x,y,z)=0
$

