#import "../template.typ": note
#show: note.with()

= 函数极限

== 等价无穷小

=== 一阶

$
  x ~ sin x ~ tan x ~ arcsin x ~ arctan x ~ ln (x + 1) ~ e^x-1
$

$
  (1+x)^alpha - 1 ~ alpha x
$

=== 二阶

$
  1- cos x ~ 1/2 x^2
$

$
  x - ln (1 + x) ~ 1/2 x^2
$

== 洛必达法则

$
  lim_(x->c) f(x)/g(x) = lim_(x->c) ( f'(x) ) / ( g'(x) )
$

变换为分数的方式

$
     lim_(x->c) f(x)g(x) & = lim_(x->c) f(x) / (1\/g(x)) \
  lim_(x->c) (f(x)-g(x)) & = lim_(x->c) (1\/g(x)-1\/f(x))/(1\/(f(x)g(x))) \
    lim_(x->c) f(x)^g(x) & = exp(lim_(x->c) g(x)/(1\/(ln f(x)))) \
                         & = exp(lim_(x->c) (ln f(x))/(1\/g(x))) \
$

== 泰勒展开

$
  f(x) & = sum^n_(i=0) (f^((i))(x_0))/i! (x - x_0)^i + o((x-x_0)^n) "皮埃诺余项" \
  f(x) & = sum^n_(i=0) (f^((i))(x_0))/i! (x - x_0)^i + (f^((n+1))(xi))/((n+1)!) (x - x_0)^(n+1) ,xi in (x_0,x) "拉格朗日余项"
$

$
         e^x & = 1 + x + x^2/2! + x^3/3! + ... + x^n/n! + ... \
       sin x & = x - x^3/3! +x^5/5! + ... + (-1)^n x^(2n+1)/((2n+1)!) + ... \
       cos x & = 1 - x^2/2! + x^4/4! + ... + (-1)^n x^(2n)/((2n)!) + ... \
  ln (1 + x) & = x + x^2/2 + x^3/3 + ... + (-1)^n x^(n+1)/(n+1) + ... \
     1/(1-x) & = x - x^2 + x^3 + ... + x^n + ... \
     (1+x)^m & = 1 + m x + (m(m-1))/2!x^2 + ... + (m(m-1)...(m-n+1))/n!x^n + ... \
$

#pagebreak()
= 数列极限

== 夹逼定理

求极限

$
  lim_(n->infinity) (1!+2!+...+n!)/n!
$

解

$
  1!+2!+...+n! < underbrace((n-2)!+...+(n-2)!, n-2个)+(n-1)!+n! < 2(n-1)!+n! \
  1 < (1!+2!+...+n!)/n! < (2(n-1)!+n!)/n!
$

== 化定积分法

$
  integral^1_0 f(x) dif x = lim_(n->infinity) sum^n_(i=1)f(i/n)1/n
$

== Stolz 定理

=== $dot/infinity$ 型

若 ${b_n}$ 满足严格单调递增且 $lim_(n->infinity) b_n = infinity$，则有

$
  lim_(n->infinity) a_n/b_n = lim_(n->infinity) (a_(n+1)-a_n)/(b_(n+1)-b_n)
$

=== $0/0$ 型

若 ${b_n}$ 满足严格单调递减且 $lim_(n->infinity) a_n = 0, lim_(n->infinity) b_n = 0$，则有

$
  lim_(n->infinity) a_n/b_n = lim_(n->infinity) (a_(n+1)-a_n)/(b_(n+1)-b_n)
$
