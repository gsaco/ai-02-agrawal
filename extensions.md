# Variance audit and extensions

This note checks Propositions 2 and 3 of Agrawal, Gans, and Goldfarb (2025).
The paper interprets continuation value $V(\theta)$ as wages, so its absolute
inequality object is the cross-sectional variance of $V(\theta)$.

## 1. Specialized solution and its domain

Under

$$
p(se;\theta)=\sqrt{se+\theta},\qquad c(e)=e,
$$

the per-opportunity objective and FOC are

$$
M(e;\theta)=\alpha\Delta\sqrt{se+\theta}-e,
\qquad
\frac{\alpha\Delta s}{2\sqrt{se+\theta}}=1.
$$

Hence the interior solution is

$$
e^*(\theta)=\frac{\alpha^2\Delta^2s}{4}-\frac{\theta}{s},
\qquad
M(\theta)=\frac{\alpha^2\Delta^2s}{4}+\frac{\theta}{s}.
$$

It is valid only when

$$
\theta<\frac{\alpha^2\Delta^2s^2}{4}.
$$

With $\Gamma=\gamma_0/(1-\delta\gamma)$,

$$
V(\theta)=\Gamma\left(K\alpha^2s+\frac{\theta}{s}\right),
\qquad K\equiv\frac{\Delta^2}{4}.
$$

Beyond the boundary the constrained optimum is

$$
e^*(\theta)=\max\left\{K\alpha^2s-\frac{\theta}{s},0\right\},
$$

and the corner value is $M(0;\theta)=\alpha\Delta\sqrt{\theta}$. The quadratic
variance formula must not be extrapolated through a population in which some
workers have reached that corner.

## 2. Cross-sectional variance of continuation value

Independence of $\Gamma$ from $(\alpha,s)$ gives

$$
\operatorname{Var}(V)
=\mathbb E[\Gamma^2]\operatorname{Var}(M)
+\operatorname{Var}(\Gamma)\mathbb E[M]^2.
$$

Write

$$
\mathbb E[M]=K\mathbb E[\alpha^2]\mu_s+\theta\mathbb E[1/s]
$$

and $\operatorname{Var}(M)=A+B\theta+C\theta^2$, where

$$
\begin{aligned}
A&=K^2\operatorname{Var}(\alpha^2s),\\
B&=2K\mathbb E[\alpha^2]\{1-\mu_s\mathbb E[1/s]\},\\
C&=\operatorname{Var}(1/s).
\end{aligned}
$$

Differentiating and collecting terms yields

$$
\frac{d\operatorname{Var}[V(\theta)]}{d\theta}
=a_0+2\theta\operatorname{Var}(\Gamma/s),
$$

with

$$
a_0=\frac{\Delta^2\mathbb E[\alpha^2]}{2}
\left\{\mathbb E[\Gamma^2]
-\mathbb E[\Gamma]^2\mu_s\mathbb E[1/s]\right\}.
$$

Condition (30),

$$
\frac{\mathbb E[\Gamma^2]}{\mathbb E[\Gamma]^2}
<\mu_s\mathbb E[1/s],
$$

is exactly $a_0<0$. When $\operatorname{Var}(\Gamma/s)>0$, variance is strictly
convex and has one interior minimum:

$$
\theta^*=-\frac{a_0}{2\operatorname{Var}(\Gamma/s)}>0.
$$

Thus condition (30) proves an initial decline followed by an eventual upturn
within the interior formula. It does not locate the upturn before any particular
positive value of $\theta$.

## 3. Individual benefit is a different variance

For worker $i$, the gain relative to no tool is

$$
D_i(\theta)=V_i(\theta)-V_i(0)=\theta\frac{\Gamma_i}{s_i}.
$$

Therefore

$$
\operatorname{Var}[D(\theta)]
=\theta^2\operatorname{Var}(\Gamma/s),
\qquad
\frac{d\operatorname{Var}[D(\theta)]}{d\theta}
=2\theta\operatorname{Var}(\Gamma/s)>0.
$$

This variance is monotone, not U-shaped.

## 4. Internal slips in the variance section

### Equation (32) needs another condition

Equation (32) states that condition (30) makes the variance slope negative at
$\theta=0$ and positive at $\theta=1$. The first statement follows. The second
is equivalent to

$$
a_0+2\operatorname{Var}(\Gamma/s)>0
\quad\Longleftrightarrow\quad \theta^*<1,
$$

which is an additional restriction absent from the proposition.

### The printed positivity condition is insufficient

The text before Proposition 3 assumes
$\Delta>2/(s\sqrt{\alpha})$ “so that optimal effort is positive.” But at
$\theta=1$, the solved effort formula requires

$$
\Delta>\frac{2}{\alpha s}.
$$

For $0<\alpha<1$, the printed condition is weaker and does not guarantee
positive effort.

### Probability and interiority clash at one

At an interior optimum,

$$
p(se^*;\theta)=\sqrt{se^*+\theta}=\frac{\alpha\Delta s}{2}.
$$

Positive effort at $\theta=1$ requires $\alpha\Delta s/2>1$, whereas the
general model defines $p\in[0,1]$. Thus the square-root expression cannot be
both a literal probability and an interior specification at that endpoint. It
must instead be read as an uncapped productivity index, capped/rescaled, or
solved with the corner.

## 5. Two Proposition 2 caveats

### General opportunity timing

For

$$
\Gamma=\sum_{k=0}^{\infty}\left(\prod_{i=0}^{k}\gamma(i)\right)\delta^k,
$$

the correct derivative of the entire continuation multiplier is

$$
\frac{\partial\Gamma}{\partial\gamma(t)}
=\sum_{k=t}^{\infty}\delta^k
\prod_{\substack{i=0\\i\ne t}}^{k}\gamma(i).
$$

The displayed ratio in Proposition 2 keeps only the $k=t$ term. A general
early-versus-late ranking depends on the full opportunity path. The geometric
special case can still deliver the paper's intended discounting result.

### Tool-skill substitutability at the optimizer

The envelope theorem gives

$$
\frac{\partial[V_0(1)-V_0(0)]}{\partial s}
=\Gamma\alpha\Delta
\left[p_s(se^*(1);1)-p_s(se^*(0);0)\right].
$$

The condition $p_{s\theta}<0$ compares tool qualities holding effort fixed.
Because $e^*(1)\ne e^*(0)$, it does not alone imply the optimizer-level
inequality inside the brackets; an additional restriction on the effort effect
is required.

## 6. Exact-moment counterexample

Let all variables be mutually independent and take

$$
\alpha\sim U(.75,.85),\quad \gamma_0\sim U(.48,.52),\quad
\gamma\sim U(.36,.44),\quad s\sim U(.8,1),
$$

with $\delta=.8$ and $\Delta=5$. All variables have positive support and satisfy
$\mu_i>3\sigma_i$. Exact moments give

$$
1.0012732
=\frac{\mathbb E[\Gamma^2]}{\mathbb E[\Gamma]^2}
<\mu_s\mathbb E[1/s]
=1.0041460.
$$

Nevertheless,

$$
\theta^*=1.7007141,
\qquad
\left.\frac{d\operatorname{Var}(V)}{d\theta}\right|_{\theta=1}
=-0.0051337<0.
$$

The smallest interior boundary in the population is $2.25$, so this is a
counterexample to the slope-at-one claim while remaining inside the algebra's
interior region.

## 7. Limiting cases

- If $\Gamma/s$ is homogeneous, there is no strict quadratic curvature.
- With constant $\Gamma$ but heterogeneous skill, inverse skill bias can reduce
  total-value variance initially, while benefit variance still increases.
- With constant skill and heterogeneous $\Gamma$, the inverse-skill equalizing
  channel disappears and tool quality raises variance.
- At large $\theta$, heterogeneous workers reach $e=0$ at different thresholds;
  the interior U-shape is then no longer the model's global variance result.

## Verdict

“Variance is U-shaped in the level of AI” is incomplete. The paper studies
cross-sectional variance of total continuation value with respect to tool
quality, under a heterogeneity threshold and an interior solution. Individual
benefit variance rises monotonically, and the paper's endpoint claim needs the
missing condition $\theta^*<1$.

