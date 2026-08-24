# Lean 4 machine-checked audit

This directory is a self-contained Lean 4 and Mathlib project. It verifies the
interior optimizer and the algebraic implications of the moment decomposition
used in the Proposition 3 audit.

## Build

Install [Elan](https://lean-lang.org/install/), then run:

```bash
cd lean
lake exe cache get
lake build --wfail
```

The project pins Lean and Mathlib to `v4.32.1`. The generated
`lake-manifest.json` locks every transitive dependency. The default `Agrawal`
target imports both proof modules, so the command above checks the complete
formal appendix.

## Notation map

| Economics notation | Lean definition or field |
|---|---|
| Per-opportunity objective | `Optimization.objective` |
| Interior effort, `e*` | `Optimization.effortStar` |
| Optimized task value, `M` | `Optimization.optimizedValue` |
| Common-interior assumptions | `Optimization.Interior` |
| `E[alpha^2]`, `E[Gamma]`, and related moments | `Variance.MomentInputs` |
| `a0` | `Variance.slopeIntercept` |
| `Var(Gamma / s)` | `Variance.curvature` |
| `theta*` | `Variance.turningPoint` |

All formal quantities are exact real numbers. The source uses ASCII names so
the declarations are easy to type while retaining the paper's notation in the
docstrings.

## What is proved

| Claim | Principal theorem |
|---|---|
| Positive interior effort | `effortStar_pos` |
| Closed-form optimized value | `objective_at_effortStar` |
| First-order condition | `foc_at_effortStar` |
| Global and unique interior optimizer | `objective_le_effortStar`, `objective_eq_effortStar_iff` |
| Variance slope `a0 + 2 theta b` | `continuationVariance_hasDerivAt` |
| Condition (30) is equivalent to `a0 < 0` | `condition30_iff_intercept_neg` |
| Positive turning point and exact completed square | `turningPoint_pos`, `variance_completeSquare` |
| Strict decline then strict increase | `variance_decreases_before_turningPoint`, `variance_increases_after_turningPoint` |
| Unique variance minimum | `turningPoint_unique_minimum` |
| Positive slope at one iff `theta* < 1` | `slope_at_one_pos_iff` |
| Adoption-benefit variance is monotone | `adoptionVariance_mono`, `adoptionVariance_strictMono` |
| Interior effort at one violates a probability cap | `interior_at_one_forces_success_gt_one` |

The variance module also contains an exact rational-coefficient witness, checked
by `norm_num`, showing that a negative initial slope and positive curvature do
not imply a positive slope at one.

## Formalization boundary

The optimizer proof begins from the paper's specialized square-root objective
and proves global optimality from a nonnegative-square identity. The variance
module begins from the paper's moment decomposition and machine-checks all
downstream algebra and comparative statics.

It does **not** construct probability spaces, formalize independence, integrate
the uniform distributions, or reproduce the plotted counterexample. Those
distribution-specific checks remain in [`../sim.py`](../sim.py). The economic
interpretation of the quadratic variance curve also remains restricted to a
common tool-quality range in which every worker has positive interior effort.
