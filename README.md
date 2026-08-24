# Repository 2 - Agrawal, Gans & Goldfarb (2025)

*The Economics of Bicycles for the Mind* ·
[NBER Working Paper 34034](https://www.nber.org/papers/w34034) · [PDF](w34034.pdf)

> **Core idea.** Computers and AI are cognitive tools: they let people produce more while
> exerting less implementation effort. Their value depends, however, on what humans still
> contribute - implementation skill, opportunity judgment, or payoff judgment.

---

## What question the paper answers

How does a cognitive tool change a worker's **effort**, **output**, and the value of different
human abilities?

The paper separates three abilities that are often bundled together as "skill":

- **Implementation skill** $s$: turning effort into a successful improvement.
- **Opportunity judgment** $\gamma(t)$: noticing another opportunity to improve the task.
- **Payoff judgment** $\alpha$: recognizing and extracting the value of a successful
  implementation.

This decomposition explains why computers and AI can raise productivity yet have different
effects on inequality, automation, and who should control work within a team.

## The agent's problem

Time is discrete. Conditional on identifying an opportunity in period $t$, the agent chooses
implementation effort $e_t\geq 0$. Effort costs $c(e_t;\theta)$ and succeeds with probability
$p(se_t;\theta)$, where $\theta$ measures tool quality. A successful implementation creates
value $\Delta>0$, which the agent realizes with probability $\alpha$:

$$
e_t^*(\theta)\in\arg\max_{e_t\geq 0}
M(e_t;\theta),\qquad
M(e_t;\theta)=p(se_t;\theta)\alpha\Delta-c(e_t;\theta).
$$

For an interior optimum,

$$
p_x(se_t^*;\theta)s\alpha\Delta=c_e(e_t^*;\theta).
$$

With discount factor $\delta$ and opportunity sequence $\{\gamma(t)\}_{t\geq0}$, the
continuation value is

$$
V_0(\theta)=\sum_{t=0}^{\infty}
\left(\prod_{i=0}^{t}\gamma(i)\right)\delta^tM(e_t^*(\theta);\theta).
$$

## The main result, with all its conditions

A higher $\theta$ is a **cognitive tool** if, for every $e$ and every $\theta'>\theta$,

$$
p(se;\theta')\geq p(se;\theta),\qquad
c(e;\theta')\leq c(e;\theta),
$$

and, for $e>0$, the marginal-benefit/marginal-cost ratio strictly falls with tool quality:

$$
\frac{p_x(se;\theta')}{c_e(e;\theta')}
<
\frac{p_x(se;\theta)}{c_e(e;\theta)}.
$$

**Proposition 1.** Moving from no tool ($\theta=0$) to the tool ($\theta=1$) lowers optimal
effort in every active period, leaves effort time-invariant, and raises expected value:

$$
e_t^*(1)<e_t^*(0),\qquad e_t^*(\theta)=e^*(\theta)\ \forall t,
\qquad V_0(1)>V_0(0).
$$

The stated primitives are $s\in(0,1]$, $\alpha\in[0,1]$, $\delta\in[0,1]$,
$\Delta>0$, and $\gamma(t)\in[0,1)$ (assumed to decline with $t$); $p\in[0,1]$ is
differentiable, non-decreasing, and weakly concave in $se$; and $c$ is differentiable,
non-decreasing, and weakly convex in $e$. For the proposition's **strict** inequalities,
the appendix also uses regularity that should be made explicit:

1. $s\alpha\Delta>0$ and the discounted opportunity weight
   $\Gamma=\sum_{t\geq0}(\prod_{i=0}^{t}\gamma(i))\delta^t$ is finite and strictly positive.
2. The maximizer exists and is uniquely selected; $c_e>0$ where the marginal ratio is
   used; the compared optima are interior (or satisfy equivalent strict Kuhn-Tucker
   conditions); and $p_x/c_e$ is strictly decreasing in effort where they are compared.
3. At the old optimum, at least one direct tool effect is strict:
   $p(se^*(0);1)>p(se^*(0);0)$ or $c(e^*(0);1)<c(e^*(0);0)$.

*Intuition in one sentence:* the tool shifts the attainable payoff upward but makes the next
unit of human effort less attractive, so the agent optimally does less while obtaining more.

One important limit: the proposition does **not** guarantee that the realized success
probability $p(se^*(\theta);\theta)$ rises, because effort falls endogenously. Consequently,
payoff judgment $\alpha$ complements tool adoption **if and only if**
$p(se^*(1);1)>p(se^*(0);0)$; opportunity judgment always scales the tool's value, while
implementation skill is a substitute when $p_{s\theta}<0$.
