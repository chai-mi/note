#import "../template.typ": note
#show: note.with()

== （反）三角函数导数

$
     (tan x)' & = 1/(cos^2 x) = sec^2 x \
     (cot x)' & = -1/(sin^2 x) = csc^2 x \
  (arcsin x)' & = 1/sqrt(1-x^2) \
  (arccos x)' & = -1/sqrt(1-x^2) \
  (arctan x)' & = 1/(1+x^2) \
$

== 定积分的性质

$
  integral^b_a f(phi (x))phi'(x) dif x & = integral^b_a f(phi (x)) dif phi (x) = integral^(phi (b))_(phi (a)) f(u) dif u \
               integral^b_a f(x) dif x & = integral^beta_alpha f(phi (t))phi'(t) dif t, phi (alpha)=a,phi (beta)=b \
            integral^b_a f(x) dif g(x) & = f(x)g(x)|^b_a - integral^b_a g(x) dif f(x) \
           integral^(a+T)_a f(x) dif x & = integral^T_0 f(x) dif x, f(x+T)=f(x) \
            integral^l_(-l) f(x) dif x & = 0, f(x)=-f(-x) \
            integral^l_(-l) f(x) dif x & = 2 integral^l_0 f(x) dif x, f(x)=f(-x) \
            integral^l_(-l) f(x) dif x & = integral^l_0 f(x) + f(-x) dif x
$

== 定积分的拉格朗日中值定理

$
                        f(xi) & = 1/(b-a) integral^b_a f(x) dif x, xi in (a,b) \
  integral^b_a f(x)g(x) dif x & = f(xi) integral^b_a g(x) dif x, g(x) "在" [a,b] "不变号"
$

== 柯西-施瓦茨不等式

$
  (integral^b_a f^2(x) dif x)(integral^b_a g^2(x) dif x)>= (integral^b_a f(x)g(x) dif x)^2
$
