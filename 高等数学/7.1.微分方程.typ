#import "../template.typ": note
#show: note.with()

== 一阶微分方程

$
  (dif y)/(dif x)=F(x,y)
$

=== 变量可分离

$
  f_1(x)g_1(y)dif x + f_2(x)g_2(y)dif y & = 0 \
                        (dif y)/(dif x) & = f(x)g(y)
$

=== 一阶线性方程

$
  y' + P(x)y = Q(x)
$

- 当$Q(x)=0$为一阶线性齐次方程，同时是可分离变量的
- 当$Q(x)!=0$为一阶线性非齐次方程，有

$
  y & = C e^(-integral P(x) dif x) + e^(-integral P(x) dif x) integral Q(x) e^(integral P(x) dif x) \
    & =(C+integral Q(x) e^(integral P(x) dif x))e^(-integral P(x) dif x)
$

=== 齐次型方程

$
  y' & = f(y/x) \
  y' & = g(x/y)
$
解
$
  设 mu = y/x, 有 (mu dif x + x dif mu)/(dif x)=f(mu) => (dif mu)/(f(mu)-mu) = (dif x)/x
$

=== 伯努利方程

$
  y' + P(x)y = Q(x)y^n, n!=0,1
$
解
$
         y^(-n) (dif y)/(dif x) + P(x)y^(1-n) & = Q(x) \
  1/(1-n) (dif y^(1-n))/(dif x) + P(x)y^(1-n) & = Q(x) \
                              令 mu = y^(1-n) \
                 (dif mu)/(dif x)+(1-n)P(x)mu & = (1-n)Q(x)
$

=== 可化为线性方程

$
  phi'(y) (dif y)/(dif x) + P(x)phi (y) & = Q(x) \
                        令 mu = phi (y) \
                           mu' + P(x)mu & = Q(X)
$

=== 可化为齐次型方程

$
  (dif y)/(dif x) = f((a_1 x+b_1 y+c_1)/(a_2 x+b_2 y+c_2))
$

$
  c_1=c_2=0时, (dif y)/(dif x) = f((a_1 x+b_1 y)/(a_2 x+b_2 y)) "为齐次型方程"
$

$
  a_1/a_2=b_1/b_2=lambda 时, (dif y)/(dif x) = f((lambda (a_2 x+b_2 y)+c_1)/(a_2 x+b_2 y+c_2))=g(a_2 x+b_2 y) \
  令 a_2 x+b_2 y = mu, (dif mu)/(dif x) = a_2 + b_2 g(mu)
$

$
  a_1/a_2!=b_1/b_2, "可令" x = s + h, y = t + k, "其中" \
  cases(a_1 h+b_1 k +c_1=0, a_2 h+b_2 k +c_2=0)
$

=== 全微分方程

$
  P(x,y)dif x + Q(x,y)dif y = 0 \
  "若有" dif mu (x,y) = P(x,y)dif x + Q(x,y)dif y \
  "则通解为" mu (x,y) = C
$

=== 常系数齐次线性方程的通解

#table(
  columns: (auto, auto),
  table.header[特征方程$lambda^n+p_(n-1)lambda^(n-1)+...+p_1 lambda+p_0=0$][常系数齐次线性方程$y^((n))+p_(n-1)y^((n-1))+...+p_1 y' +p_0 y=0$],
  $"单实根"lambda$, $C e^(lambda x)$,
  $"一对单复根"alpha plus.minus i beta$, $e^(alpha x)(C_1 cos beta x+C_2 sin beta x)$,
  $k"重实根"lambda$, $e^(lambda x)(C_1+C_2 x+...+C_k x^(k-1))$,
  $k"重复根"alpha plus.minus i beta$,
  $e^(alpha x)[(C_1+C_2 x+...+C_k x^(k-1))cos beta x+(D_1+D_2 x+...+D_k x^(k-1)) sin beta x]$,
)

=== 常系数非齐次方程的特解

$
  y^((n))+p_(n-1)y^((n-1))+...+p_1 y' +p_0 y = f(x) \
  "其中" f(x)=P_n (x) e^(alpha x), P_n (x) 为 n "阶多项式" \
  "则设特解为" y = x^k Q_n (x) e^(alpha x), alpha 是 k "重特征根，反代入方程求出" Q_n (x) "系数即可" \
  若 f(x)=e^(alpha x)[P_m (x) cos beta x + P_l (x) sin beta x] \
  "则设特解为" y = x^k e^(alpha x)[Q_n(x) cos beta x + R_n (x) sin beta x] \
  n = max{l,m},alpha 是 k "对复重根，反代入方程求出" Q_n (x) R_n (x) "系数即可"
$

=== 欧拉方程

$
  x^2 y'' + a x y' + b y = f(x) \
  令 x = e^t, 有 \
  y' = (dif y)/(dif t) (dif t)/(dif x) = (dif y)/(dif t) 1/x \
  y'' = dif/(dif x)((dif y)/(dif t) 1/x) = 1/x^2 (dif y)/(dif t) + 1/x (dif^2 y)/(dif t^2) (dif t)/(dif x) = -1/x^2 (dif y)/(dif t) + 1/x^2 (dif^2 y)/(dif t^2) \
  "故有"
  (dif^2 y)/(dif t^2) + (a-1)(dif y)/(dif t) + b y = f(e^t)
$

=== 二阶变系数齐次线性微分方程

$
  y'' + a_1(x) y' + a_2(x) y = 0 \
  "如果已知一个特解" y_1(x) \
  "则可设另一个特解为" y_2(x) = y_1(x)u(x) \
  "代入原方程" u(x) = integral 1/(y^2_1 (x)) e^(- integral a_1 (x)dif x) dif x
$

=== 积分方程
