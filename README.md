<p align="center">
  <img src="assets/header.svg" alt="The Economics of Bicycles for the Mind" width="100%">
</p>

<p align="center">
  <a href="https://www.nber.org/papers/w34034"><img alt="NBER paper" src="https://img.shields.io/badge/Paper-NBER%20WP%2034034-0C2852?style=for-the-badge"></a>
  <a href="https://doi.org/10.3386/w34034"><img alt="DOI" src="https://img.shields.io/badge/DOI-10.3386%2Fw34034-982A34?style=for-the-badge"></a>
  <a href="presentation.pdf"><img alt="Short deck" src="https://img.shields.io/badge/3--Frame%20Deck-PDF-982A34?style=for-the-badge&logo=adobeacrobatreader&logoColor=white"></a>
  <a href="extra/presentation-long.pdf"><img alt="Extended deck" src="https://img.shields.io/badge/26--Frame%20Deck-PDF-0C2852?style=for-the-badge&logo=adobeacrobatreader&logoColor=white"></a>
</p>

<p align="center">
  <a href="presentation.tex"><img alt="Beamer source" src="https://img.shields.io/badge/Source-Beamer-008080?style=flat-square&logo=latex&logoColor=white"></a>
  <a href="sim.py"><img alt="SymPy audit" src="https://img.shields.io/badge/Audit-SymPy-3B5526?style=flat-square&logo=sympy&logoColor=white"></a>
  <a href="LICENSE"><img alt="MIT License" src="https://img.shields.io/badge/License-MIT-4B5563?style=flat-square"></a>
</p>

<p align="center">
  <img alt="LaTeX" src="https://img.shields.io/badge/LaTeX-008080?style=flat-square&logo=latex&logoColor=white">
  <img alt="Beamer" src="https://img.shields.io/badge/Beamer-0C2852?style=flat-square">
  <img alt="Python" src="https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=python&logoColor=white">
  <img alt="SymPy" src="https://img.shields.io/badge/SymPy-3B5526?style=flat-square&logo=sympy&logoColor=white">
  <img alt="GitHub" src="https://img.shields.io/badge/GitHub-181717?style=flat-square&logo=github&logoColor=white">
</p>

This repository studies Ajay Agrawal, Joshua Gans, and Avi Goldfarb's *The
Economics of Bicycles for the Mind* (2025), an **unrefereed NBER working paper**
about computers and AI as cognitive tools. It is not an arXiv paper.

## What question does the paper answer?

**When a cognitive tool makes implementation easier, how do effort,
productivity, the returns to different human abilities, and inequality change?**

The single mechanism is that the tool **substitutes for human implementation
effort at the margin**, while judgment determines how much value the agent can
obtain from it:

- Implementation skill $s$ makes effort more effective.
- Payoff judgment $\alpha$ determines whether successful implementation creates value.
- Opportunity judgment $\gamma(t)$ determines whether another improvement opportunity is found.

## The agent's problem

Conditional on an opportunity in period $t$, the agent chooses effort $e_{t}$:

$$
e_{t}^{*}(\theta)\in\arg\max_{e_{t}\geq 0}
\{p(se_{t};\theta)\alpha\Delta-c(e_{t};\theta)\}.
$$

Here $\theta$ is tool quality and $\Delta>0$ is the value of an improvement.
The success probability $p\in[0,1]$ is increasing and weakly concave in
skill-augmented effort; cost $c$ is increasing and weakly convex. A cognitive
tool raises $p$ and/or lowers $c$, while lowering the marginal success-to-cost
ratio. At an interior optimum,

$$
p'(se_{t}^{*};\theta)s\alpha\Delta=c'(e_{t}^{*};\theta).
$$

## Propositions 1 and 2

**Proposition 1.** Moving from no tool to the tool lowers optimal effort in
every period, makes effort time-invariant, and raises expected task value:

$$
e_{t}^{*}(1)<e_{t}^{*}(0),\qquad
e_{t}^{*}(\theta)=e^{*}(\theta),\qquad V_{0}(1)>V_{0}(0).
$$

**Proposition 2.** If $\Gamma$ denotes the discounted opportunity multiplier,
the adoption gain is

$$
V_{0}(1)-V_{0}(0)=\Gamma[M(e^{*}(1);1)-M(e^{*}(0);0)]>0.
$$

Opportunity judgment scales the gain. Payoff judgment complements adoption
only when realized success is weakly higher with the tool. The paper argues
that implementation skill reduces adoption value under tool-skill
substitutability; [`extensions.md`](extensions.md) records two caveats to the
general statement.

## Proposition 3: the conditional U-shape

The inequality result specializes the model to
$p(se;\theta)=\sqrt{se+\theta}$, $c(e)=e$, and
$\Gamma=\gamma_{0}/(1-\delta\gamma)$. It treats $\theta\geq 0$ as continuous and
assumes $\delta\gamma<1$. The heterogeneous variables
$\alpha,\gamma_{0},\gamma,s$ are mutually independent, have positive support,
and satisfy the paper's moment restriction $\mu_{i}>3\sigma_{i}$.

Within the range in which every worker has positive interior effort,

$$
V(\theta)=\Gamma(\alpha^{2}\Delta^{2}s/4+\theta/s),
\qquad \theta<\alpha^{2}\Delta^{2}s^{2}/4.
$$

The U-shape is in the **cross-sectional variance of continuation value
$V(\theta)$**, interpreted as wages, **with respect to tool quality $\theta$**.
It requires

$$
E[\Gamma^{2}]/E[\Gamma]^{2}<\mu_{s}E[1/s].
$$

It also requires positive cross-sectional variance in $\Gamma/s$.

Under these conditions the variance slope is linear, initially negative, and
crosses zero once at $\theta^{*}>0$. The paper's stronger displayed claim that
the slope is already positive at $\theta=1$ additionally requires
$\theta^{*}<1$.

The variance of the **individual adoption benefit** is a different object. For
worker $i$, the gain is $D_{i}(\theta)=V_{i}(\theta)-V_{i}(0)=\theta\Gamma_{i}/s_{i}$.
Its cross-sectional variance is $\theta^{2}$ times the variance of $\Gamma/s$,
so it increases monotonically for $\theta>0$ whenever $\Gamma/s$ is heterogeneous.

*Intuition:* inverse skill bias initially compresses wage dispersion because
the tool boost is $\theta/s$, but heterogeneous opportunity judgment can
eventually amplify those gains enough to widen dispersion again.

## Repository structure

```text
.
├── assets/                     # README banner and shared Beamer theme
├── extra/
│   ├── figures/                # Reproducible variance comparison
│   ├── presentation-long.tex   # 26-frame technical deck
│   └── presentation-long.pdf
├── hand/README.md              # Where to add the handwritten audit photo
├── paper/
│   ├── README.md               # Citation and official links
│   └── THE ECONOMICS OF BICYCLES FOR THE MIND.pdf
│                               # Source paper included in the repository
├── presentation.tex            # Three-frame oral-exam deck
├── presentation.pdf
├── extensions.md               # Algebra, slips, counterexample, limiting cases
├── prompts.md                  # Shared-chat link and this task transcript
├── sim.py                      # Deterministic SymPy and exact-moment checks
└── requirements.txt
```

The required handwritten derivation must be the student's own work; see
[`hand/README.md`](hand/README.md) before adding the photograph.

## Reproduce the audit

```bash
python3 -m pip install -r requirements.txt
python3 sim.py
lualatex presentation.tex
cd extra && lualatex presentation-long.tex
```

## Citation

> Agrawal, A. K., Gans, J. S., & Goldfarb, A. (2025). *The Economics of
> Bicycles for the Mind*. NBER Working Paper No. 34034.
> <https://doi.org/10.3386/w34034>
