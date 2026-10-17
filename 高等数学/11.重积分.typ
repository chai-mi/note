#import "../template.typ": note
#show: note.with()

== 二重积分

$
  I = integral.double_D f(x,y) dif sigma = lim_(lambda->0) sum^n_(i=1) f(xi_i,eta_i) dot Delta sigma_i
$

=== 中值定理

$
  integral.double_D f(x,y) g(x,y) dif sigma = f(xi,eta) integral.double_D g(x,y) dif sigma
$

=== 计算

$x$ 型区域

$
  D={(x,y)|a<=x<=b,phi_1(x)<=y<=phi_2(x)} => \
  integral.double_D f(x,y) dif sigma = integral^b_1 dif x integral^(phi_2(x))_(phi_1(x)) f(x,y) dif y
$

==== 坐标代换

$
  integral.double_D_(x y) f(x,y) dif x dif y = integral.double_D_(u v) f(x (u,v),y (u,v)) abs(J) dif u dif v \
  J = mat(delim: "|", x_u, x_v; y_u, y_v) = (partial (x,y))/(partial (u,v))
$

==== 极坐标变换

$
  cases(
    x=rho cos theta,
    y=rho sin theta,
    dif sigma=rho dif rho dif theta
  ) => integral.double_D f(x,y) dif sigma = integral.double_D f(rho cos theta,rho sin theta) rho dif rho dif theta
$

==== 球坐标变换

$
  integral.triple_Omega f(x,y,z) = \
  integral^beta_alpha dif theta integral^(phi_2(theta))_(phi_1(theta)) dif phi integral^(r_2(theta,phi))_(r_1(theta,phi)) f(r sin phi cos theta,r sin phi sin theta,r cos phi) r^2 sin phi dif r
$

==== 轮换不变性


$
  integral.double_(D_(x y)) f(x,y) dif x dif y & = integral.double_(D_(y x)) f(y,x) dif y dif x \
                                               & = integral.double_(D_(x y)) f(y,x) dif y dif x , "if" D_(x y)=D_(y x) \
                                               & = integral.double_(D_(x y)) 1/2[f(x,y)+f(y,x)] dif x dif y
$

===== 例

$
  求 integral^1_0 dif x integral^1_0 (cos x)/(cos x + cos y) dif y
$

$
  "原式" = integral.double_D 1/2[(cos x)/(cos x + cos y)+(cos y)/(cos x + cos y)] dif x dif y
$

== 应用

=== 曲面面积

$
  S = integral.double_(D_(x y)) sqrt(1+z_x^2+z_y^2) dif sigma
$

=== 薄片质心


$
  (integral.double_D x mu (x,y) dif sigma)/(integral.double_D mu (x,y) dif sigma) = overline(x)
$

=== 薄片关于 $x$ 轴的转动惯量

$
  I_x = integral.double_D y^2 mu (x,y) dif sigma
$

=== 重心

$
  (integral.triple_Omega x mu (x,y,z) dif V)/(integral.triple_Omega mu (x,y,z) dif V) = overline(x)
$

=== 物体关于 $x$ 轴的转动惯量

$
  I_x = integral.triple_Omega (y^2+z^2) mu (x,y,z) dif V
$
