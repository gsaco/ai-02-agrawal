# Repository 2 - Agrawal, Gans & Goldfarb (2025)

*The Economics of Bicycles for the Mind* -
[NBER Working Paper 34034](https://www.nber.org/papers/w34034)

> **Main takeaway.** A cognitive tool raises the value created per opportunity while
> reducing implementation effort. It substitutes for implementation skill, amplifies
> opportunity judgment, and complements payoff judgment only when its direct benefit is
> not undone by the user's endogenous effort reduction. With heterogeneous workers, this
> can create an initially equalizing but eventually inequality-increasing force.

---

## What question does the paper answer?

How do computers and AI change a worker's effort, output, and the returns to different
human abilities? The paper separates three abilities that are often bundled together as
"skill":

- **Implementation skill** $s$: turning effort into a successful improvement.
- **Opportunity judgment** $\gamma(t)$: noticing another opportunity to improve the task.
- **Payoff judgment** $\alpha$: recognizing and extracting value from a successful
  implementation.

This decomposition is used to study productivity, adoption, and wage inequality. The
sections below prioritize Propositions 1-3 and make the variance algebra explicit.

## The agent's problem

Time is discrete. Conditional on identifying an opportunity in period $t$, the agent chooses
effort $e_t\geq0$. Effort costs $c(e_t;\theta)$ and succeeds with probability
$p(se_t;\theta)$, where $\theta\geq0$ measures tool quality. A successful implementation
creates value $\Delta>0$, realized with probability $\alpha$:

$$
e_t^{*}(\theta)\in\arg\max_{e_t\geq0}M(e_t;\theta),
\qquad
M(e_t;\theta)=\alpha\Delta p(se_t;\theta)-c(e_t;\theta).
$$

For an interior optimum, with $p_x$ denoting the derivative in the first argument,

$$
p_x(se_t^{*}(\theta);\theta)s\alpha\Delta
=c_e(e_t^{*}(\theta);\theta).
$$

Let

$$
\Gamma
=\sum_{t=0}^{\infty}
\left(\prod_{i=0}^{t}\gamma(i)\right)\delta^t,
\qquad 0<\Gamma<\infty.
$$

Because the per-opportunity problem is time-invariant,

$$
V_0(\theta)=\Gamma M(e^{*}(\theta);\theta).
$$

If $\gamma(0)=\gamma_0$ and $\gamma(t)=\gamma$ for $t>0$, this becomes
$\Gamma=\gamma_0/(1-\delta\gamma)$.

### What counts as a cognitive tool?

For every $e$ and $\theta'>\theta$, a tool satisfies

$$
p(se;\theta')\geq p(se;\theta),
\qquad
c(e;\theta')\leq c(e;\theta),
$$

and, for $e>0$, it lowers the marginal-benefit/marginal-cost ratio:

$$
\frac{p_x(se;\theta')}{c_e(e;\theta')}
<
\frac{p_x(se;\theta)}{c_e(e;\theta)}.
$$

## Proposition 1 - more value with less effort

Moving from $\theta=0$ to $\theta=1$ yields

$$
e_t^{*}(1)<e_t^{*}(0),
\qquad
e_t^{*}(\theta)=e^{*}(\theta)\ \text{for every }t,
\qquad
V_0(1)>V_0(0).
$$

The paper assumes $s\in(0,1]$, $\alpha,\delta\in[0,1]$, $\Delta>0$,
$p(se;\theta)\in[0,1]$, $p_x\geq0$ with $p$ weakly concave in $se$, and
$c_e\geq0$ with $c$ weakly convex in $e$. The strict result also requires the
regularity used in the proof:

1. $s\alpha\Delta>0$, $0<\Gamma<\infty$, and the maximizer exists and is uniquely
   selected.
2. The compared optima are interior, or satisfy equivalent strict Kuhn-Tucker conditions;
   $c_e>0$ where the ratio is used; and $p_x/c_e$ is strictly decreasing in effort over
   the relevant range.
3. At the old optimum, at least one direct tool effect is strict:

$$
p(se^{*}(0);1)>p(se^{*}(0);0)
\quad\text{or}\quad
c(e^{*}(0);1)<c(e^{*}(0);0).
$$

The intuition is a revealed-preference argument: the new tool raises the optimized
per-opportunity payoff, while its lower marginal return to human effort moves the optimum
to a lower effort level.

## Proposition 2 - what drives the value of adoption?

Define the adoption gain

$$
G=V_0(1)-V_0(0)
=\Gamma\left[M(e^{*}(1);1)-M(e^{*}(0);0)\right]>0.
$$

### 1. Opportunity judgment

$\Gamma$ multiplies the entire per-opportunity gain. Better opportunity judgment therefore
raises the value of the tool whenever the bracketed gain is positive.

For a general opportunity sequence, the correct marginal weight on $\gamma(t)$ is

$$
\frac{\partial\Gamma}{\partial\gamma(t)}
=\sum_{k=t}^{\infty}\delta^k
\prod_{\substack{i=0\\i\ne t}}^{k}\gamma(i).
$$

Thus, the early-versus-late ranking depends on the entire opportunity path. In the paper's
special case $\gamma(t)=\gamma$ for $t\geq1$ and $\delta\gamma<1$, earlier opportunities
receive strictly more weight.

### 2. Payoff judgment

The envelope theorem gives

$$
\frac{\partial G}{\partial\alpha}
=\Gamma\Delta
\left[p(se^{*}(1);1)-p(se^{*}(0);0)\right].
$$

Therefore, payoff judgment complements adoption if and only if realized success is weakly
higher with the tool. Definition 1 alone does not guarantee this: the tool's direct increase
in success can be offset by the fall in optimal effort.

### 3. Implementation skill

Again by the envelope theorem,

$$
\frac{\partial G}{\partial s}
=\Gamma\alpha\Delta
\left[p_s(se^{*}(1);1)-p_s(se^{*}(0);0)\right].
$$

Here $p_s$ is the partial derivative with respect to $s$, holding effort fixed.
Hence the exact optimizer-level condition for tools and implementation skill to be
substitutes is

$$
p_s(se^{*}(1);1)<p_s(se^{*}(0);0).
$$

The paper invokes $p_{s\theta}<0$. That cross-partial compares tool qualities at a fixed
effort; because effort also changes, it needs an additional restriction ensuring the displayed
optimizer-level inequality.

## Proposition 3 - cognitive tools and wage inequality

Proposition 3 imposes

$$
p(se;\theta)=\sqrt{se+\theta},
\qquad c(e)=e,
\qquad \Gamma=\frac{\gamma_0}{1-\delta\gamma}.
$$

Workers differ independently in $\alpha$, $\gamma_0$, $\gamma$, and $s$, all with positive
support. Write their means and variances as $\mu_i$ and $\sigma_i^2$, and assume
$\mu_i>3\sigma_i$ as in the paper.

### Closed form

The first-order condition and its solution are

$$
\frac{\alpha\Delta s}{2\sqrt{se^{*}(\theta)+\theta}}=1,
\qquad
e^{*}(\theta)=\frac{\alpha^2\Delta^2s}{4}-\frac{\theta}{s}.
$$

Thus,

$$
M(\theta)=\frac{\alpha^2\Delta^2s}{4}+\frac{\theta}{s},
\qquad
V(\theta)=\Gamma
\left(\frac{\alpha^2\Delta^2s}{4}+\frac{\theta}{s}\right).
$$

The exact interiority condition at a given $\theta$ is

$$
e^{*}(\theta)>0
\quad\Longleftrightarrow\quad
\theta<\frac{\alpha^2\Delta^2s^2}{4}.
$$

This is the condition implied by the solved effort formula and must hold for every worker
and every tool quality at which the interior algebra is applied.

There is also a domain issue. At the interior optimum,
$p(se^{*}(\theta);\theta)=\alpha\Delta s/2$. If the general-model restriction
$p\in[0,1]$ is retained, this requires $\alpha\Delta s\leq2$; an interior solution at
$\theta=1$ instead requires $\alpha\Delta s>2$. Thus, the square-root specification at
that endpoint must be read as a reduced-form productivity index rather than a literal
probability, or else be capped or rescaled.

### Mean effect

Independence implies

$$
\frac{\partial\mathbb{E}[V(\theta)]}{\partial\theta}
=\mathbb{E}[\Gamma]\mathbb{E}\!\left[\frac{1}{s}\right]
=\mu_{\gamma_0}\mathbb{E}\!\left[\frac{1}{1-\delta\gamma}\right]
\mathbb{E}\!\left[\frac{1}{s}\right]>0.
$$

Tools always raise mean productivity within the interior region.

### Variance algebra

Set

$$
q=\frac{\Delta^2}{4},
\qquad
a_2=\mathbb{E}[\alpha^2]=\mu_\alpha^2+\sigma_\alpha^2,
\qquad
h_1=\mathbb{E}[s^{-1}],
\qquad
h_2=\mathbb{E}[s^{-2}].
$$

Since $M(\theta)=q\alpha^2s+\theta/s$,

$$
m(\theta):=\mathbb{E}[M(\theta)]
=qa_2\mu_s+\theta h_1,
$$

and

$$
\operatorname{Var}(M(\theta))=A+B\theta+C\theta^2,
$$

where

$$
\begin{aligned}
A&=q^2\operatorname{Var}(\alpha^2s),\\
B&=2qa_2(1-\mu_sh_1),\\
C&=h_2-h_1^2=\operatorname{Var}(s^{-1}).
\end{aligned}
$$

Jensen's inequality gives $\mu_sh_1\geq1$, so $B\leq0$: absent the heterogeneous
opportunity multiplier, the inverse-skill tool boost initially compresses dispersion.

Because $\Gamma$ is independent of $M(\theta)$,

$$
\operatorname{Var}(V(\theta))
=\mathbb{E}[\Gamma^2]\operatorname{Var}(M(\theta))
+\operatorname{Var}(\Gamma)m(\theta)^2.
$$

Differentiating and collecting terms produces the key linear derivative:

$$
\frac{\partial\operatorname{Var}(V(\theta))}{\partial\theta}
=a_0+2\theta\operatorname{Var}\!\left(\frac{\Gamma}{s}\right),
$$

with

$$
a_0
=\frac{\Delta^2a_2}{2}
\left\{
\mathbb{E}[\Gamma^2]
-\mathbb{E}[\Gamma]^2\mu_s\mathbb{E}[s^{-1}]
\right\},
$$

and

$$
\operatorname{Var}\!\left(\frac{\Gamma}{s}\right)
=\mathbb{E}[\Gamma^2]h_2-\mathbb{E}[\Gamma]^2h_1^2.
$$

The paper's threshold condition is

$$
\frac{\mathbb{E}[\Gamma^2]}{\mathbb{E}[\Gamma]^2}
<\mu_s\mathbb{E}[s^{-1}].
$$

It is equivalent to $a_0<0$, so variance initially falls. If
$\operatorname{Var}(\Gamma/s)>0$, variance is strictly convex because

$$
\frac{\partial^2\operatorname{Var}(V(\theta))}{\partial\theta^2}
=2\operatorname{Var}\!\left(\frac{\Gamma}{s}\right)>0.
$$

The unique variance-minimizing tool quality is therefore

$$
\theta^{*}
=\frac{\Delta^2(\mu_\alpha^2+\sigma_\alpha^2)}{4}
\frac{
\mathbb{E}[\Gamma]^2\mu_s\mathbb{E}[s^{-1}]
-\mathbb{E}[\Gamma^2]
}{
\operatorname{Var}(\Gamma/s)
}>0.
$$

### What is needed for the claimed U-shape?

Condition (30) establishes $\theta^{*}>0$; it does not by itself establish
$\theta^{*}<1$. Therefore, the paper's displayed claim that the variance derivative is
positive at $\theta=1$ additionally requires

$$
\theta^{*}<1
\quad\Longleftrightarrow\quad
a_0+2\operatorname{Var}(\Gamma/s)>0.
$$

The interior solution must also remain valid through the turning point (and through
$\theta=1$ if that endpoint is used). Subject to these conditions, inverse skill bias
dominates for $\theta<\theta^{*}$, while amplification through heterogeneous opportunity
judgment dominates for $\theta>\theta^{*}$.

*Economic intuition:* the tool boost is $\theta/s$, so low-implementation-skill workers gain
more at first. As tool quality rises, the heterogeneous multiplier $\Gamma$ increasingly
amplifies those gains, eventually widening the distribution of value.
