#!/usr/bin/env python3
"""Deterministic symbolic and exact-moment audit of Proposition 3."""

from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime, timezone
from math import log, sqrt
from pathlib import Path

import matplotlib

matplotlib.use("Agg")

import matplotlib.pyplot as plt
import numpy as np
import sympy as sp


OUTPUT_DIR = Path(__file__).resolve().parent / "extra" / "figures"


def uniform_moment(lower: float, upper: float, order: int) -> float:
    if not lower < upper:
        raise ValueError("Uniform lower bound must be below upper bound.")
    if order < 0:
        raise ValueError("Use a dedicated inverse-moment formula.")
    return (upper ** (order + 1) - lower ** (order + 1)) / (
        (order + 1) * (upper - lower)
    )


def uniform_inverse_moment_1(lower: float, upper: float) -> float:
    return log(upper / lower) / (upper - lower)


def uniform_inverse_moment_2(lower: float, upper: float) -> float:
    return (1.0 / lower - 1.0 / upper) / (upper - lower)


@dataclass(frozen=True)
class Counterexample:
    alpha_bounds: tuple[float, float] = (0.75, 0.85)
    gamma0_bounds: tuple[float, float] = (0.48, 0.52)
    gamma_bounds: tuple[float, float] = (0.36, 0.44)
    skill_bounds: tuple[float, float] = (0.8, 1.0)
    discount: float = 0.8
    improvement_value: float = 5.0

    @property
    def expected_alpha2(self) -> float:
        return uniform_moment(*self.alpha_bounds, 2)

    @property
    def expected_alpha4(self) -> float:
        return uniform_moment(*self.alpha_bounds, 4)

    @property
    def expected_skill(self) -> float:
        return uniform_moment(*self.skill_bounds, 1)

    @property
    def expected_skill2(self) -> float:
        return uniform_moment(*self.skill_bounds, 2)

    @property
    def expected_inverse_skill(self) -> float:
        return uniform_inverse_moment_1(*self.skill_bounds)

    @property
    def expected_inverse_skill2(self) -> float:
        return uniform_inverse_moment_2(*self.skill_bounds)

    @property
    def expected_gamma_multiplier(self) -> float:
        gamma_low, gamma_high = self.gamma_bounds
        expected_gamma0 = uniform_moment(*self.gamma0_bounds, 1)
        expected_inverse = log(
            (1.0 - self.discount * gamma_low)
            / (1.0 - self.discount * gamma_high)
        ) / (self.discount * (gamma_high - gamma_low))
        return expected_gamma0 * expected_inverse

    @property
    def expected_gamma_multiplier2(self) -> float:
        gamma_low, gamma_high = self.gamma_bounds
        expected_gamma02 = uniform_moment(*self.gamma0_bounds, 2)
        expected_inverse2 = (
            1.0 / (1.0 - self.discount * gamma_high)
            - 1.0 / (1.0 - self.discount * gamma_low)
        ) / (self.discount * (gamma_high - gamma_low))
        return expected_gamma02 * expected_inverse2

    @property
    def variance_gamma_multiplier(self) -> float:
        return self.expected_gamma_multiplier2 - self.expected_gamma_multiplier**2

    @property
    def variance_gamma_over_skill(self) -> float:
        return (
            self.expected_gamma_multiplier2 * self.expected_inverse_skill2
            - (self.expected_gamma_multiplier * self.expected_inverse_skill) ** 2
        )

    @property
    def condition_30_lhs(self) -> float:
        return self.expected_gamma_multiplier2 / self.expected_gamma_multiplier**2

    @property
    def condition_30_rhs(self) -> float:
        return self.expected_skill * self.expected_inverse_skill

    @property
    def slope_intercept(self) -> float:
        return (
            self.improvement_value**2
            * self.expected_alpha2
            / 2.0
            * (
                self.expected_gamma_multiplier2
                - self.expected_gamma_multiplier**2
                * self.expected_skill
                * self.expected_inverse_skill
            )
        )

    @property
    def theta_star(self) -> float:
        return -self.slope_intercept / (2.0 * self.variance_gamma_over_skill)

    @property
    def smallest_interior_boundary(self) -> float:
        alpha_low = self.alpha_bounds[0]
        skill_low = self.skill_bounds[0]
        return alpha_low**2 * self.improvement_value**2 * skill_low**2 / 4.0

    def variance_slope(self, theta: float | np.ndarray) -> float | np.ndarray:
        return self.slope_intercept + 2.0 * theta * self.variance_gamma_over_skill

    def total_value_variance(self, theta: float | np.ndarray) -> float | np.ndarray:
        k = self.improvement_value**2 / 4.0
        expected_m = (
            k * self.expected_alpha2 * self.expected_skill
            + theta * self.expected_inverse_skill
        )
        expected_m2 = (
            k**2 * self.expected_alpha4 * self.expected_skill2
            + 2.0 * k * theta * self.expected_alpha2
            + theta**2 * self.expected_inverse_skill2
        )
        variance_m = expected_m2 - expected_m**2
        return (
            self.expected_gamma_multiplier2 * variance_m
            + self.variance_gamma_multiplier * expected_m**2
        )

    def individual_gain_variance(
        self, theta: float | np.ndarray
    ) -> float | np.ndarray:
        return theta**2 * self.variance_gamma_over_skill


def verify_symbolic_algebra() -> None:
    effort, skill, theta = sp.symbols("e s theta", positive=True)
    alpha, delta = sp.symbols("alpha Delta", positive=True)
    objective = alpha * delta * sp.sqrt(skill * effort + theta) - effort
    effort_star = alpha**2 * delta**2 * skill / 4 - theta / skill

    foc_at_solution = sp.simplify(sp.diff(objective, effort).subs(effort, effort_star))
    value_at_solution = sp.simplify(objective.subs(effort, effort_star))
    expected_value = alpha**2 * delta**2 * skill / 4 + theta / skill
    assert foc_at_solution == 0
    assert sp.simplify(value_at_solution - expected_value) == 0

    e_gamma, e_gamma2 = sp.symbols("E_Gamma E_Gamma2", positive=True)
    e_alpha2, mean_skill = sp.symbols("E_alpha2 mu_s", positive=True)
    e_inv_skill, e_inv_skill2 = sp.symbols("E_inv_s E_inv_s2", positive=True)
    variance_constant = sp.symbols("A", nonnegative=True)
    k = delta**2 / 4
    b = 2 * k * e_alpha2 * (1 - mean_skill * e_inv_skill)
    c = e_inv_skill2 - e_inv_skill**2
    expected_m = k * e_alpha2 * mean_skill + theta * e_inv_skill
    variance_m = variance_constant + b * theta + c * theta**2
    variance_v = e_gamma2 * variance_m + (e_gamma2 - e_gamma**2) * expected_m**2
    a0 = (
        delta**2
        * e_alpha2
        / 2
        * (e_gamma2 - e_gamma**2 * mean_skill * e_inv_skill)
    )
    variance_gamma_over_skill = (
        e_gamma2 * e_inv_skill2 - e_gamma**2 * e_inv_skill**2
    )
    target_slope = a0 + 2 * theta * variance_gamma_over_skill
    assert sp.simplify(sp.diff(variance_v, theta) - target_slope) == 0
    theta_star = sp.solve(sp.Eq(target_slope, 0), theta)[0]
    assert sp.simplify(theta_star + a0 / (2 * variance_gamma_over_skill)) == 0


def verify_counterexample(case: Counterexample) -> None:
    for bounds in (
        case.alpha_bounds,
        case.gamma0_bounds,
        case.gamma_bounds,
        case.skill_bounds,
    ):
        mean = sum(bounds) / 2.0
        standard_deviation = (bounds[1] - bounds[0]) / sqrt(12.0)
        assert bounds[0] > 0
        assert mean > 3.0 * standard_deviation

    assert case.condition_30_lhs < case.condition_30_rhs
    assert np.isclose(case.theta_star, 1.7007140766809163, atol=1e-12)
    assert np.isclose(case.variance_slope(1.0), -0.005133679530232584, atol=1e-12)
    assert case.variance_slope(0.0) < 0
    assert case.variance_slope(1.0) < 0
    assert case.variance_slope(2.0) > 0
    assert case.variance_gamma_over_skill > 0
    assert 1.0 < case.theta_star < case.smallest_interior_boundary

    theta_grid = np.linspace(0.0, 2.2, 401)
    total_variance = case.total_value_variance(theta_grid)
    benefit_variance = case.individual_gain_variance(theta_grid)
    minimum_index = int(np.argmin(total_variance))
    assert abs(theta_grid[minimum_index] - case.theta_star) < 0.01
    assert np.all(np.diff(benefit_variance) >= 0)


def make_figure(case: Counterexample) -> None:
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    theta = np.linspace(0.0, 2.2, 500)
    total_variance = case.total_value_variance(theta)
    benefit_variance = case.individual_gain_variance(theta)

    plt.rcParams.update(
        {
            "font.family": "DejaVu Sans",
            "font.size": 9,
            "axes.titlesize": 10,
            "axes.labelsize": 9,
            "xtick.labelsize": 8,
            "ytick.labelsize": 8,
            "axes.spines.top": False,
            "axes.spines.right": False,
        }
    )

    fig, axes = plt.subplots(1, 2, figsize=(7.2, 3.0), constrained_layout=True)
    navy, red, muted = "#0C2852", "#982A34", "#5F6368"

    axes[0].plot(theta, total_variance, color=navy, linewidth=2.4)
    axes[0].axvline(case.theta_star, color=red, linestyle="--", linewidth=1.4)
    axes[0].axvline(1.0, color=muted, linestyle=":", linewidth=1.2)
    axes[0].scatter([1.0], [case.total_value_variance(1.0)], color=red, s=25, zorder=3)
    axes[0].annotate(
        r"slope at $\theta=1<0$",
        xy=(1.0, case.total_value_variance(1.0)),
        xytext=(0.10, 0.17),
        textcoords="axes fraction",
        arrowprops={"arrowstyle": "->", "color": red, "lw": 1.0},
        color=red,
        fontsize=8,
    )
    axes[0].text(
        case.theta_star + 0.04,
        float(np.min(total_variance)) + 0.001,
        r"$\theta^*=1.701$",
        color=red,
        fontsize=8,
    )
    axes[0].set_title("Total continuation value")
    axes[0].set_xlabel(r"Tool quality $\theta$")
    axes[0].set_ylabel(r"Cross-sectional $\mathrm{Var}[V(\theta)]$")
    axes[0].grid(alpha=0.18, linewidth=0.6)

    axes[1].plot(theta, benefit_variance, color=red, linewidth=2.4)
    axes[1].set_title("Individual adoption gain")
    axes[1].set_xlabel(r"Tool quality $\theta$")
    axes[1].set_ylabel(r"$\mathrm{Var}[V(\theta)-V(0)]$")
    axes[1].text(
        0.08,
        0.86,
        r"$\theta^2\,\mathrm{Var}(\Gamma/s)$",
        transform=axes[1].transAxes,
        color=red,
        fontsize=9,
    )
    axes[1].grid(alpha=0.18, linewidth=0.6)

    fig.savefig(
        OUTPUT_DIR / "variance-comparison.pdf",
        bbox_inches="tight",
        metadata={
            "Creator": "sim.py",
            "Producer": "Matplotlib",
            "CreationDate": datetime(2026, 8, 24, tzinfo=timezone.utc),
            "ModDate": datetime(2026, 8, 24, tzinfo=timezone.utc),
        },
    )
    fig.savefig(OUTPUT_DIR / "variance-comparison.png", dpi=300, bbox_inches="tight")
    plt.close(fig)


def print_results(case: Counterexample) -> None:
    print("Symbolic identities: verified")
    print(f"Condition (30): {case.condition_30_lhs:.7f} < {case.condition_30_rhs:.7f}")
    print(f"Slope at theta=0: {case.variance_slope(0.0):.7f}")
    print(f"Slope at theta=1: {case.variance_slope(1.0):.7f}")
    print(f"Turning point: {case.theta_star:.7f}")
    print(f"Smallest interior boundary: {case.smallest_interior_boundary:.7f}")
    print("Individual-gain variance: monotone increasing on theta > 0")
    print(f"Figures: {OUTPUT_DIR / 'variance-comparison.pdf'}")
    print(f"         {OUTPUT_DIR / 'variance-comparison.png'}")


def main() -> None:
    case = Counterexample()
    verify_symbolic_algebra()
    verify_counterexample(case)
    make_figure(case)
    print_results(case)


if __name__ == "__main__":
    main()
