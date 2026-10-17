#import "../template.typ": note
#show: note.with()

=== 等比级数

$
  sum a q^n=cases(
    1/(1-q) "if" abs(q)<1,
    "发散 if" abs(q) >=1
  )
$

=== p 级数

$
  sum 1/(n^p) = cases(
    "发散 if" p<=1,
    "收敛 if" p>1
  )
$

=== $sum 1/(n (ln n)^p)$ 级数

$
  sum 1/(n (ln n)^p) = cases(
    "发散 if" p<=1,
    "收敛 if" p>1
  )
$

=== 极限比较判别法

$
  "两个正项级数" sum u_n, sum v_n \
  有 lim_(n->infinity) (u_n)/(v_n) = l \
  l!=0 "则有" sum u_n 与 sum v_n "同收敛" \
  l=0 且 sum v_n "收敛, 则" sum u_n "收敛" \
  l=+infinity 且 sum v_n "发散, 则" sum u_n "发散"
$

=== 比较判别法

$
  lim_(n->infinity) abs(a_(n+1)/(a_n))<1 => sum a_n "收敛"
$

=== 根式判别法

$
  lim_(n->infinity) abs(a_n)^(1/n)<1 => sum a_n "收敛"
$

=== 莱布尼茨定理

$
  "设交错级数" sum (-1)^n abs(u_n), 且 cases(abs(u_(n+1))<abs(u_n), lim_(n->infinity) u_n =0) \
  则 sum (-1)^n abs(u_n) "收敛", 且 S_n <abs(u_1), r_n < abs(u_(n+1))
$

== 幂级数

$
  sum^infinity_(n=0) c_n (x-x_0)^n
$

称 $x_0$ 为基点

=== 幂级数的收敛域

$
  R = 1/(lim_(n->infinity)abs((c_n+1)/(c_n))) = 1/(lim_(n->infinity)root(n, c_n)) \
  "并判断端点处的收敛性"
$

=== 阿贝尔定理

$
  若 sum^infinity_(n=0) c_n x^n 在 x' "收敛", "则在" (-abs(x'),abs(x')) "收敛" \
  若 sum^infinity_(n=0) c_n x^n 在 x' "发散", "则在" (-infinity,-abs(x')) union (abs(x'), +infinity) "发散"
$
