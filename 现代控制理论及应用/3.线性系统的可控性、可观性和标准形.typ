#import "../template.typ": note
#show: note.with()

= 线性连续系统的可控性和可观性

== 可控性定义

指外界输入 $u(t)$ 对系统状态变量 $x(t)$ 或输出变量 $y(t)$ 的支配能力，它回答了 $u(t)$ 能否使 $x(t)$ 和 $y(t)$ 作任意转移的问题

=== 系统的状态可达性

初始状态为状态空间原点，即零态，终端状态为状态空间任意非零有限点

=== 状态可控性判别方法

+ 存在时刻 $t_1>0$，使如下定义的格拉姆（Gram)矩阵非奇异

  $
    W_c[0,t_1]=integral^(t_1)_0 upright(e)^(-A t) B B^T upright(e)^(-A^T t) dif t
  $

+ 函数矩阵 $upright(e)^(- A t) B$ 的 $n$ 个行在 $[0, infinity]$ 上线性无关

+ 可控矩阵 $Psi_c$ 的秩为 $n$

  $
    Psi_c = mat(B, A B, A^2 B, ..., A^(n-1) B)
  $

=== 输出可控性判别方法

$
  cases(
    dot(x)(t) = A x(t) + B u(t),
    y(t) = C x(t) + D u(t)
  )
$

其中，$C$ 和 $D$ 分别为 $l times n$ 和 $l times m$ 矩阵，$y$ 为 $l$ 维列矢量

该系统输出可控的充要条件是输出可控矩阵

$
  Psi_(y c) = mat(C B, C A B, C A^2 B, ..., C A^(n-1) B, D)
$

的秩为 $l$

== 可观性定义

系统可观性指由系统的输出 $y(t)$ 确定状态变量 $x(t)$ 的能力，它回答了状态变量能否由输出反映出来

由状态方程求解公式

$
  x(t) = Phi(t-t_0) x(t_0) + integral^t_(t_0) Phi(t-tau) B u(tau) dif tau
$

可以得到输出响应的表达式为

$
  y(t) = C(t) Phi(t-t_0) x(t_0) + C(t) integral^t_(t_0) Phi(t-tau) B u(tau) dif tau + D(t) u(t)
$

在研究可观测性问题时,输出y和输入u都假定为是已知的,需要确定的是初始状态 $x(t_0)$

因此，若定义

$
  overline(y)(t) = y(t) - C(t) integral^t_(t_0) Phi(t-tau) B u(tau) dif tau - D(t) u(t)
$

则

$
  overline(y)(t) = C(t) Phi(t-t_0) x(t_0)
$

可观性问题是一个由已知 $overline(y)(t), C(t), Phi(t-t_0)$ 来确定 $x(t_0)$的问题。由于 $overline(y)(t),x(t_0)$ 的任意性，所以，这又等价于研究 $u=0$ 时由 $y(t)$ 来估计状态 $x(t_0)$ 的能力，即与控制作用没有直接关系。所以分析可观性问题时，只需考虑齐次状态方程和输出方程

$
  cases(
    dot(x)(t) = A x(t),
    y(t) = C x(t)
  ) \
  x(t_0)=x_0
$

=== 可观性判据

+ 存在时刻 $t_1>0$，使如下定义的格拉姆（Gram)矩阵非奇异

  $
    W_o[0,t_1]=integral^(t_1)_0 upright(e)^(A t) C^T C upright(e)^(A t) dif t
  $

+ 函数矩阵 $C upright(e)^(A t)$ 的 $n$ 个行在 $[0, infinity]$ 上线性无关

+ 可控矩阵 $Psi_o$ 的秩为 $n$

  $
    Psi_o = mat(C^T, A^T C^T, (A^2)^T C^T, ..., (A^(n-1))^T C^T)^T
  $

== 可控性和可观性的对偶关系

当两个线性系统

$
  Sigma_1 & := cases(
              dot(x) = A x + B u,
              y = C x
            ) \
  Sigma_2 & := cases(
              dot(psi) = -A^T psi + C^T eta,
              phi = B^T psi
            )
$

则 $Sigma_1$ 的可控性等价于 $Sigma_2$ 的可观测性；$Sigma_1$ 的可观测性等价于 $Sigma_2$ 的可控性

== 线性离散系统的可控性和可观性

考虑线性离散系统

$
  x(k+1) = G x(K) + H u(k)
$

如果对状态空间中的任意初始状态 $x(k)$，存在控制序列 $u(k),u(k+1), …, u(N-1)$，使系统从第 $k$ 步 $x(k)$ 开始，在 $N$ 步时到达 $x(N)=0$，则系统在时刻 $k$ 是可控的。如果对任意时刻 $k$，系统的所有状态都是可控的，则称系统的状态是完全可控的

=== 状态可控性判据

线性定常离散系统状态完全可控的充要条件是

$
  "rank" Psi_c = "rank" mat(H, G H, G^2 H, ..., G^(n-1) H) = n
$

=== 状态可观性及判据

线性定常离散系统状态完全可观的充要条件是

$
  "rank" Psi_o = "rank" mat(C^T, G^T C^T, (G^2)^T C^T, ..., (G^(n-1))^T C^T)^T = n
$

#pagebreak()
= 可控标准形和可观标准形

#pagebreak()
= 线性系统的结构分解


#pagebreak()

$
  dot(x) & = mat(
             1, 2, 0;
             3, -1, 1;
             0, 2, 0
           ) x + mat(
             2;
             1;
             1
           ) u \
       y & = mat(0, 0, 1) x
$

+ 判断可控性：

  $
    Psi_c = mat(b, A b, A^2 b)
    = mat(
      2, 4, 16;
      1, 6, 8 ;
      1, 2, 12
    ) \
    "rank" Psi_c=3
  $

+ 计算特征多项式：

  $
    det(s I - A) = mat(
      s-1, -2, 0;
      -3, s+1, -1;
      0, -2, s,
      delim: "|"
    ) = s^3-9s+2
  $

+ 计算变换矩阵

  $
    T_(c 1) & = mat(A^2 b, A b, b) mat(
                1, 0, 0;
                a_2, 1, 0;
                a_1, a_2, 1
              ) \
            & = mat(
                16, 4, 2;
                8, 6, 1;
                12, 2, 1
              ) mat(
                1, 0, 0;
                0, 1, 0;
                -9, 0, 1
              ) \
            & = mat(
                -2, 4, 2;
                -1, 6, 1;
                3, 2, 1
              )
  $

+ 计算 $overline(C)$

  $
    overline(C) = C T_(c 1) = mat(3, 2, 1)
  $

+ 可控标志形

  $
    overline(dot(x)) = mat(
      0, 1, 0;
      0, 0, 1;
      -2, 9, 0
    ) overline(x) + mat(0; 0; 1) u
  $

#pagebreak()

$
  dot(x) & = mat(
             1, 1, 1;
             0, 1, 0;
             1, 1, 1
           ) x + mat(
             0, 1;
             1, 0;
             0, 1
           ) u \
       y & = mat(1, 0, 1) x
$

+ 判断可控性：

  $
    Psi_c = mat(b, A b, A^2 b) = mat(
      0, 1, 1, 2, 3, 4;
      1, 0, 1, 0, 1, 0;
      0, 1, 1, 2, 3, 4
    ) \
    "rank" Psi_c=2
  $

+ 计算特征多项式
