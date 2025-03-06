# 公式编辑要求

> [!IMPORTANT]
> 遵循以下规则有助于你的公式正确渲染

### 行内数学公式前后空一格

`句子(注意空一格) $math$ (空一格)句子`

`句子(注意空一格) $math$, 这里使用半角的标点所以不用空`

`$math$: 这里使用半角的标点所以不用空`

### 行间数学公式前后空一行

```markdown
段落
(注意空一行)

$$
math
$$

(空一行)
段落
```

# Latex 速查

| \LaTeX                     | $\LaTeX$                     | 备注           |
| -------------------------- | ---------------------------- | -------------- |
| \cdot                      | $\cdot$                      | 点乘           |
| \times                     | $\times$                     | 叉乘           |
| \otimes                    | $\otimes$                    | 卷积           |
| \set{1,2,3}                | $\set{1,2,3}$                | 集合           |
| \mathrm{e}                 | $\mathrm{e}$                 | 自然对数用正体 |
| \mathrm{i}                 | $\mathrm{i}$                 | 虚数单位用正体 |
| f^{\prime}                 | $f^{\prime}$                 | 一撇 (导数)    |
| \mathrm{d}x                | $\mathrm{d}x$                | 微分符号用正体 |
| \partial                   | $\partial$                   | 偏导           |
| \geq or \geqslant          | $\geq$ or $\geqslant$        |                |
| \leq or \leqslant          | $\leq$ or $\leqslant$        |                |
| \approx                    | $\approx$                    |                |
| \frac{1}{3} or 1 \over 3   | $\frac{1}{3}$ or $1 \over 3$ |                |
| \overbrace{1+2+\cdots+100} | $\overbrace{1+2+\cdots+100}$ | 上括号         |
| \left(\frac{1}{3} \right)  | $\left(\frac{1}{3} \right)$  | 使括号匹配行高 |
| \left\vert x \right\vert   | $\left\vert x \right\vert$   |                |
| \sqrt[3]{x}                | $\sqrt[3]{x}$                |                |
| \sin x                     | $\sin x$                     | 使用转义表示   |
| \min x                     | $\min x$                     | 使用转义表示   |
| \log x                     | $\log x$                     | 使用转义表示   |
| \lim x                     | $\lim x$                     | 使用转义表示   |
| \because                   | $\because$                   |                |
| \therefore                 | $\therefore$                 |                |
| \angle A                   | $\angle A$                   |                |
| \parallel                  | $\parallel$                  | 平行           |
| \perp                      | $\perp$                      | 垂直           |
| \varnothing                | $\varnothing$                |                |
| \vec{a}                    | $\vec{a}$                    | 向量 (单字母)  |
| \overrightarrow{AB}        | $\overrightarrow{AB}$        | 向量 (多字母)  |
| \implies                   | $\implies$                   | 充分条件       |
| \impliedby                 | $\impliedby$                 | 必要条件       |
| \iff                       | $\iff$                       | 充要条件       |
| \hat{a}                    | $\hat{a}$                    | 参数的估计值   |
| \infty                     | $\infty$                     |                |
| \mathrm{C}_3^2             | $\mathrm{C}_3^2$             | 组合符号用正体 |
| \mathrm{A}_3^2             | $\mathrm{A}_3^2$             | 排列符号用正体 |
| \propto                    | $\propto$                    | 正比于         |

## 多行公式

### 方程组

使用 & 对齐

```markdown
f(x)=
\begin{cases}
1,& x \geq 0 \\
114514,& x < 0
\end{cases}
```

$$
f(x)=
\begin{cases}
1,& x \geq 0 \\
114514,& x < 0
\end{cases}
$$

### 矩阵

```markdown
\begin{bmatrix}
0      & \cdots & 0      \\
\vdots & \ddots & \vdots \\
0      & \cdots & 0
\end{bmatrix}
```

$$
\begin{bmatrix}
0      & \cdots & 0      \\
\vdots & \ddots & \vdots \\
0      & \cdots & 0
\end{bmatrix}
$$

### 一列整齐且居中的方程式序列

使用 & 对齐

```markdown
\begin{aligned}
f(x) & = (m+n)^2 \\
     & = m^2+2mn+n^2 \\
\end{aligned}
```

$$
\begin{aligned}
f(x) & = (m+n)^2 \\
     & = m^2+2mn+n^2 \\
\end{aligned}
$$

## 希腊字母速查

| \LaTeX        | $\LaTeX$      | \LaTeX      | $\LaTeX$    |
| ------------- | ------------- | ----------- | ----------- |
| `\alpha`      | $\alpha$      | `\nu`       | $\nu$       |
| `\beta`       | $\beta$       | `\xi`       | $\xi$       |
| `\gamma`      | $\gamma$      | `\omicron`  | $\omicron$  |
| `\delta`      | $\delta$      | `\pi`       | $\pi$       |
| `\epsilon`    | $\epsilon$    | `\varpi`    | $\varpi$    |
| `\varepsilon` | $\varepsilon$ | `\rho`      | $\rho$      |
| `\zeta`       | $\zeta$       | `\varrho`   | $\varrho$   |
| `\eta`        | $\eta$        | `\sigma`    | $\sigma$    |
| `\theta`      | $\theta$      | `\varsigma` | $\varsigma$ |
| `\vartheta`   | $\vartheta$   | `\tau`      | $\tau$      |
| `\iota`       | $\iota$       | `\upsilon`  | $\upsilon$  |
| `\kappa`      | $\kappa$      | `\phi`      | $\phi$      |
| `\lambda`     | $\lambda$     | `\varphi`   | $\varphi$   |
| `\mu`         | $\mu$         | `\chi`      | $\chi$      |
| `\Gamma`      | $\Gamma$      | `\Psi`      | $\Psi$      |
| `\Delta`      | $\Delta$      | `\Omega`    | $\Omega$    |
| `\Theta`      | $\Theta$      | `\Upsilon`  | $\Upsilon$  |
| `\Lambda`     | $\Lambda$     | `\Phi`      | $\Phi$      |
| `\Xi`         | $\Xi$         | `\Sigma`    | $\Sigma$    |
