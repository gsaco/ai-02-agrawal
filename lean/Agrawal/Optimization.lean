import Mathlib

/-!
# Interior optimization audit

This module verifies the closed-form solution of the paper's square-root
specialization.  It proves global optimality directly from a nonnegative
square, rather than treating the first-order condition as sufficient.
-/

namespace Agrawal.Optimization

noncomputable section

/-- Per-opportunity value at effort `e`. -/
def objective (alpha delta skill theta effort : ℝ) : ℝ :=
  alpha * delta * Real.sqrt (skill * effort + theta) - effort

/-- Candidate optimal effort in the common interior regime. -/
def effortStar (alpha delta skill theta : ℝ) : ℝ :=
  alpha ^ 2 * delta ^ 2 * skill / 4 - theta / skill

/-- Optimized per-opportunity value in the common interior regime. -/
def optimizedValue (alpha delta skill theta : ℝ) : ℝ :=
  alpha ^ 2 * delta ^ 2 * skill / 4 + theta / skill

/-- Assumptions under which the paper's closed-form interior solution applies. -/
def Interior (alpha delta skill theta : ℝ) : Prop :=
  0 < alpha ∧ 0 < delta ∧ 0 < skill ∧ 0 ≤ theta ∧
    theta < alpha ^ 2 * delta ^ 2 * skill ^ 2 / 4

theorem effortStar_pos {alpha delta skill theta : ℝ}
    (h : Interior alpha delta skill theta) :
    0 < effortStar alpha delta skill theta := by
  rcases h with ⟨_, _, hskill, _, htheta⟩
  rw [show effortStar alpha delta skill theta =
      (alpha ^ 2 * delta ^ 2 * skill ^ 2 / 4 - theta) / skill by
    unfold effortStar
    field_simp]
  exact div_pos (sub_pos.mpr htheta) hskill

theorem input_at_effortStar {alpha delta skill theta : ℝ}
    (hskill : skill ≠ 0) :
    skill * effortStar alpha delta skill theta + theta =
      (alpha * delta * skill / 2) ^ 2 := by
  unfold effortStar
  field_simp
  ring

theorem sqrt_input_at_effortStar {alpha delta skill theta : ℝ}
    (halpha : 0 < alpha) (hdelta : 0 < delta) (hskill : 0 < skill) :
    Real.sqrt (skill * effortStar alpha delta skill theta + theta) =
      alpha * delta * skill / 2 := by
  rw [input_at_effortStar hskill.ne', Real.sqrt_sq]
  positivity

theorem objective_at_effortStar {alpha delta skill theta : ℝ}
    (halpha : 0 < alpha) (hdelta : 0 < delta) (hskill : 0 < skill) :
    objective alpha delta skill theta
        (effortStar alpha delta skill theta) =
      optimizedValue alpha delta skill theta := by
  rw [objective, sqrt_input_at_effortStar halpha hdelta hskill]
  unfold effortStar optimizedValue
  field_simp
  ring

theorem foc_at_effortStar {alpha delta skill theta : ℝ}
    (h : Interior alpha delta skill theta) :
    HasDerivAt (objective alpha delta skill theta) 0
      (effortStar alpha delta skill theta) := by
  rcases h with ⟨halpha, hdelta, hskill, _, _⟩
  let eStar := effortStar alpha delta skill theta
  have hinner :
      HasDerivAt (fun effort : ℝ => skill * effort + theta) skill eStar := by
    exact (hasDerivAt_const_mul (x := eStar) skill).add_const theta
  have hinput : skill * eStar + theta ≠ 0 := by
    rw [show eStar = effortStar alpha delta skill theta by rfl]
    rw [input_at_effortStar hskill.ne']
    positivity
  have hsqrt := hinner.sqrt hinput
  have hobjective :=
    (HasDerivAt.const_mul (alpha * delta) hsqrt).sub (hasDerivAt_id eStar)
  have hderiv :
      alpha * delta * (skill / (2 * Real.sqrt (skill * eStar + theta))) - 1 =
        0 := by
    rw [show eStar = effortStar alpha delta skill theta by rfl]
    rw [sqrt_input_at_effortStar halpha hdelta hskill]
    field_simp
    ring
  change HasDerivAt
    (fun effort : ℝ =>
      alpha * delta * Real.sqrt (skill * effort + theta) - effort)
    0 eStar
  exact hobjective.congr_deriv hderiv

private theorem value_gap_square {alpha delta skill theta effort : ℝ}
    (h : Interior alpha delta skill theta) (heffort : 0 ≤ effort) :
    optimizedValue alpha delta skill theta -
        objective alpha delta skill theta effort =
      (Real.sqrt (skill * effort + theta) -
          alpha * delta * skill / 2) ^ 2 / skill := by
  rcases h with ⟨_, _, hskill, htheta, _⟩
  have hinput : 0 ≤ skill * effort + theta := by positivity
  have hsqrt := Real.sq_sqrt hinput
  unfold optimizedValue objective
  field_simp
  nlinarith

theorem objective_le_effortStar {alpha delta skill theta effort : ℝ}
    (h : Interior alpha delta skill theta) (heffort : 0 ≤ effort) :
    objective alpha delta skill theta effort ≤
      objective alpha delta skill theta
        (effortStar alpha delta skill theta) := by
  rcases h with ⟨halpha, hdelta, hskill, htheta, hinterior⟩
  have hfull : Interior alpha delta skill theta :=
    ⟨halpha, hdelta, hskill, htheta, hinterior⟩
  rw [objective_at_effortStar halpha hdelta hskill]
  have hgap := value_gap_square hfull heffort
  have hnonneg :
      0 ≤ optimizedValue alpha delta skill theta -
        objective alpha delta skill theta effort := by
    rw [hgap]
    exact div_nonneg (sq_nonneg _) hskill.le
  linarith

theorem objective_eq_effortStar_iff {alpha delta skill theta effort : ℝ}
    (h : Interior alpha delta skill theta) (heffort : 0 ≤ effort) :
    objective alpha delta skill theta effort =
        objective alpha delta skill theta
          (effortStar alpha delta skill theta) ↔
      effort = effortStar alpha delta skill theta := by
  rcases h with ⟨halpha, hdelta, hskill, htheta, hinterior⟩
  have hfull : Interior alpha delta skill theta :=
    ⟨halpha, hdelta, hskill, htheta, hinterior⟩
  constructor
  · intro heq
    have hgap := value_gap_square hfull heffort
    have hvalue :
        objective alpha delta skill theta
            (effortStar alpha delta skill theta) =
          optimizedValue alpha delta skill theta :=
      objective_at_effortStar halpha hdelta hskill
    have hsquareDiv :
        (Real.sqrt (skill * effort + theta) -
            alpha * delta * skill / 2) ^ 2 / skill = 0 := by
      rw [← hgap, ← hvalue, heq]
      ring
    have hsquare :
        (Real.sqrt (skill * effort + theta) -
            alpha * delta * skill / 2) ^ 2 = 0 := by
      exact (div_eq_zero_iff).mp hsquareDiv |>.resolve_right hskill.ne'
    have hsqrtEq :
        Real.sqrt (skill * effort + theta) =
          alpha * delta * skill / 2 := by
      nlinarith
    have hinput : 0 ≤ skill * effort + theta := by positivity
    have hsqrtSquare := Real.sq_sqrt hinput
    have hstarInput :=
      input_at_effortStar (alpha := alpha) (delta := delta)
        (theta := theta) hskill.ne'
    have hinputEq :
        skill * effort + theta =
          skill * effortStar alpha delta skill theta + theta := by
      calc
        skill * effort + theta =
            Real.sqrt (skill * effort + theta) ^ 2 := hsqrtSquare.symm
        _ = (alpha * delta * skill / 2) ^ 2 := by rw [hsqrtEq]
        _ = skill * effortStar alpha delta skill theta + theta := hstarInput.symm
    have hmul :
        skill * (effort - effortStar alpha delta skill theta) = 0 := by
      nlinarith
    rcases mul_eq_zero.mp hmul with hskillZero | heffortZero
    · exact False.elim (hskill.ne' hskillZero)
    · nlinarith
  · rintro rfl
    rfl

/-- At tool quality one, positive interior effort forces the uncapped
square-root success index above one. -/
theorem interior_at_one_forces_success_gt_one {alpha delta skill : ℝ}
    (halpha : 0 < alpha) (hdelta : 0 < delta) (hskill : 0 < skill)
    (heffort : 0 < effortStar alpha delta skill 1) :
    1 < alpha * delta * skill / 2 := by
  unfold effortStar at heffort
  have hsquare : 4 < (alpha * delta * skill) ^ 2 := by
    field_simp at heffort
    nlinarith
  nlinarith [sq_nonneg (alpha * delta * skill / 2 - 1),
    mul_pos (mul_pos halpha hdelta) hskill]

end

end Agrawal.Optimization
