#import "../template.typ": note
#show: note.with()

== 利用函数凹凸性

若在$f(x)$在$[a,b]$上有$f''(x)>0$，则对$forall x_0 in [a,b]$，有$f(x)>=f(x_0)+f'(x_0)(x-x_0)$

== 詹森不等式

若在$f(x)$在$[a,b]$上有$f''(x)>0$，则对$forall x_1,x_2,...,x_n in [a,b], lambda_1,lambda_2,...,lambda_n>=0, lambda_1+lambda_2+...lambda_n=1$，有

$
  f(lambda_1 x_1+...+lambda_n x_n)<= lambda_1 f(x_1)+...+lambda_n f(x_n)
$

== 利用泰勒公式

1. 写出比最高阶导数低一阶的函数的泰勒公式
2. 选取恰当的$x$与$x_0$
3. 根据所给最高阶导数的大小或阶对展开式进行缩放
