import Mathlib

/-!
# Variance audit

This module takes the paper's moment decomposition as an input and verifies
its algebraic consequences exactly over the real numbers.  It does not build
probability spaces or prove the maintained independence assumptions.

The economic interpretation of the quadratic curve is valid only over a
common range on which every worker's effort solution remains interior.
-/

namespace Agrawal.Variance

noncomputable section

/-- Moments entering the specialized continuation-value variance formula. -/
structure MomentInputs where
  improvementValue : ℝ
  expectedAlphaSq : ℝ
  meanSkill : ℝ
  expectedInvSkill : ℝ
  expectedInvSkillSq : ℝ
  expectedGamma : ℝ
  expectedGammaSq : ℝ
  varianceConstant : ℝ

/-- The constant `K = Delta^2 / 4` in the optimized task value. -/
def k (m : MomentInputs) : ℝ := m.improvementValue ^ 2 / 4

/-- Mean per-opportunity value inside the common interior regime. -/
def perOpportunityMean (m : MomentInputs) (theta : ℝ) : ℝ :=
  k m * m.expectedAlphaSq * m.meanSkill + theta * m.expectedInvSkill

/-- Variance of per-opportunity value inside the common interior regime. -/
def perOpportunityVariance (m : MomentInputs) (theta : ℝ) : ℝ :=
  m.varianceConstant +
    2 * k m * m.expectedAlphaSq *
      (1 - m.meanSkill * m.expectedInvSkill) * theta +
    (m.expectedInvSkillSq - m.expectedInvSkill ^ 2) * theta ^ 2

/-- Cross-sectional continuation-value variance after applying the
product-variance decomposition. -/
def continuationVariance (m : MomentInputs) (theta : ℝ) : ℝ :=
  m.expectedGammaSq * perOpportunityVariance m theta +
    (m.expectedGammaSq - m.expectedGamma ^ 2) *
      perOpportunityMean m theta ^ 2

/-- Constant term in the slope of continuation-value variance. -/
def slopeIntercept (m : MomentInputs) : ℝ :=
  m.improvementValue ^ 2 * m.expectedAlphaSq / 2 *
    (m.expectedGammaSq -
      m.expectedGamma ^ 2 * m.meanSkill * m.expectedInvSkill)

/-- Quadratic curvature, algebraically equal to `Var(Gamma / skill)`. -/
def curvature (m : MomentInputs) : ℝ :=
  m.expectedGammaSq * m.expectedInvSkillSq -
    m.expectedGamma ^ 2 * m.expectedInvSkill ^ 2

/-- Slope of continuation-value variance with respect to tool quality. -/
def varianceSlope (m : MomentInputs) (theta : ℝ) : ℝ :=
  slopeIntercept m + 2 * theta * curvature m

/-- Unique turning point when the intercept is negative and curvature positive. -/
def turningPoint (m : MomentInputs) : ℝ :=
  -slopeIntercept m / (2 * curvature m)

/-- The paper's condition (30). -/
def condition30 (m : MomentInputs) : Prop :=
  m.expectedGammaSq / m.expectedGamma ^ 2 <
    m.meanSkill * m.expectedInvSkill

/-- Cross-sectional variance of the individual adoption benefit. -/
def adoptionVariance (m : MomentInputs) (theta : ℝ) : ℝ :=
  theta ^ 2 * curvature m

theorem continuationVariance_hasDerivAt (m : MomentInputs) (theta : ℝ) :
    HasDerivAt (continuationVariance m) (varianceSlope m theta) theta := by
  let b := 2 * k m * m.expectedAlphaSq *
    (1 - m.meanSkill * m.expectedInvSkill)
  let c := m.expectedInvSkillSq - m.expectedInvSkill ^ 2
  have hVariance :
      HasDerivAt (perOpportunityVariance m) (b + 2 * c * theta) theta := by
    have hLinear := hasDerivAt_const_mul (x := theta) b
    have hQuadratic :=
      HasDerivAt.const_mul c ((hasDerivAt_id theta).pow 2)
    have hraw := ((hasDerivAt_const theta m.varianceConstant).add hLinear).add
      hQuadratic
    change HasDerivAt
      (fun x : ℝ => m.varianceConstant + b * x + c * x ^ 2)
      (b + 2 * c * theta) theta
    exact hraw.congr_deriv (by simp only [id_eq]; ring)
  have hMean :
      HasDerivAt (perOpportunityMean m) m.expectedInvSkill theta := by
    have hraw := (hasDerivAt_const theta
      (k m * m.expectedAlphaSq * m.meanSkill)).add
      ((hasDerivAt_id theta).mul_const m.expectedInvSkill)
    change HasDerivAt
      (fun x : ℝ => k m * m.expectedAlphaSq * m.meanSkill +
        x * m.expectedInvSkill) m.expectedInvSkill theta
    exact hraw.congr_deriv (by ring)
  have hTotal :=
    (HasDerivAt.const_mul m.expectedGammaSq hVariance).add
      (HasDerivAt.const_mul
        (m.expectedGammaSq - m.expectedGamma ^ 2) (hMean.pow 2))
  change HasDerivAt
    (fun x : ℝ =>
      m.expectedGammaSq * perOpportunityVariance m x +
        (m.expectedGammaSq - m.expectedGamma ^ 2) *
          perOpportunityMean m x ^ 2)
    (varianceSlope m theta) theta
  apply hTotal.congr_deriv
  simp only [varianceSlope, slopeIntercept, curvature, perOpportunityMean,
    b, c, k]
  ring

theorem condition30_iff_intercept_neg (m : MomentInputs)
    (hDelta : 0 < m.improvementValue)
    (hAlpha : 0 < m.expectedAlphaSq)
    (hGamma : 0 < m.expectedGamma) :
    condition30 m ↔ slopeIntercept m < 0 := by
  unfold condition30 slopeIntercept
  have hGammaSq : 0 < m.expectedGamma ^ 2 := sq_pos_of_pos hGamma
  constructor
  · intro h
    have hcore :
        m.expectedGammaSq <
          m.expectedGamma ^ 2 * m.meanSkill * m.expectedInvSkill := by
      apply (div_lt_iff₀ hGammaSq).mp at h
      nlinarith
    have hprefactor :
        0 < m.improvementValue ^ 2 * m.expectedAlphaSq / 2 := by positivity
    exact mul_neg_of_pos_of_neg hprefactor (sub_neg.mpr hcore)
  · intro h
    have hprefactor :
        0 < m.improvementValue ^ 2 * m.expectedAlphaSq / 2 := by positivity
    have hcore :
        m.expectedGammaSq <
          m.expectedGamma ^ 2 * m.meanSkill * m.expectedInvSkill := by
      rcases mul_neg_iff.mp h with hcase | hcase
      · exact sub_neg.mp hcase.2
      · exact False.elim ((not_lt_of_ge hprefactor.le) hcase.1)
    exact (div_lt_iff₀ hGammaSq).mpr (by nlinarith)

theorem turningPoint_pos (m : MomentInputs)
    (hIntercept : slopeIntercept m < 0) (hCurvature : 0 < curvature m) :
    0 < turningPoint m := by
  unfold turningPoint
  exact div_pos (neg_pos.mpr hIntercept) (mul_pos (by norm_num) hCurvature)

theorem continuationVariance_quadratic (m : MomentInputs) (theta : ℝ) :
    continuationVariance m theta =
      continuationVariance m 0 + slopeIntercept m * theta +
        curvature m * theta ^ 2 := by
  unfold continuationVariance perOpportunityVariance perOpportunityMean
    slopeIntercept curvature k
  ring

theorem variance_completeSquare (m : MomentInputs)
    (hCurvature : curvature m ≠ 0) (theta : ℝ) :
    continuationVariance m theta -
        continuationVariance m (turningPoint m) =
      curvature m * (theta - turningPoint m) ^ 2 := by
  rw [continuationVariance_quadratic m theta,
    continuationVariance_quadratic m (turningPoint m)]
  unfold turningPoint
  field_simp [hCurvature]
  ring

theorem variance_decreases_before_turningPoint (m : MomentInputs)
    (hCurvature : 0 < curvature m) {theta₁ theta₂ : ℝ}
    (hOrder : theta₁ < theta₂) (hBefore : theta₂ ≤ turningPoint m) :
    continuationVariance m theta₂ < continuationVariance m theta₁ := by
  have h1 := variance_completeSquare m hCurvature.ne' theta₁
  have h2 := variance_completeSquare m hCurvature.ne' theta₂
  have hdist :
      (theta₂ - turningPoint m) ^ 2 <
        (theta₁ - turningPoint m) ^ 2 := by nlinarith
  nlinarith

theorem variance_increases_after_turningPoint (m : MomentInputs)
    (hCurvature : 0 < curvature m) {theta₁ theta₂ : ℝ}
    (hAfter : turningPoint m ≤ theta₁) (hOrder : theta₁ < theta₂) :
    continuationVariance m theta₁ < continuationVariance m theta₂ := by
  have h1 := variance_completeSquare m hCurvature.ne' theta₁
  have h2 := variance_completeSquare m hCurvature.ne' theta₂
  have hdist :
      (theta₁ - turningPoint m) ^ 2 <
        (theta₂ - turningPoint m) ^ 2 := by nlinarith
  nlinarith

theorem turningPoint_unique_minimum (m : MomentInputs)
    (hCurvature : 0 < curvature m) (theta : ℝ) :
    continuationVariance m (turningPoint m) ≤
      continuationVariance m theta ∧
    (continuationVariance m (turningPoint m) =
      continuationVariance m theta ↔ theta = turningPoint m) := by
  have hsquare := variance_completeSquare m hCurvature.ne' theta
  constructor
  · nlinarith [sq_nonneg (theta - turningPoint m)]
  · constructor
    · intro heq
      have : curvature m * (theta - turningPoint m) ^ 2 = 0 := by nlinarith
      rcases mul_eq_zero.mp this with hzero | hzero
      · exact False.elim (hCurvature.ne' hzero)
      · nlinarith
    · rintro rfl
      rfl

theorem slope_at_one_pos_iff (m : MomentInputs)
    (hCurvature : 0 < curvature m) :
    0 < varianceSlope m 1 ↔ turningPoint m < 1 := by
  unfold varianceSlope turningPoint
  constructor <;> intro h
  · apply (div_lt_iff₀ (show 0 < 2 * curvature m by positivity)).mpr
    nlinarith
  · apply (div_lt_iff₀ (show 0 < 2 * curvature m by positivity)).mp at h
    nlinarith

/-- Exact witness that an initially negative slope and positive curvature do
not force a positive slope at tool quality one. -/
example :
    let a0 : ℝ := -3
    let b : ℝ := 1
    a0 < 0 ∧ 0 < b ∧ a0 + 2 * 0 * b < 0 ∧ a0 + 2 * 1 * b < 0 := by
  norm_num

theorem adoptionVariance_mono (m : MomentInputs)
    (hCurvature : 0 ≤ curvature m) {theta₁ theta₂ : ℝ}
    (hTheta₁ : 0 ≤ theta₁) (hOrder : theta₁ ≤ theta₂) :
    adoptionVariance m theta₁ ≤ adoptionVariance m theta₂ := by
  unfold adoptionVariance
  have hsquares : theta₁ ^ 2 ≤ theta₂ ^ 2 := by nlinarith
  exact mul_le_mul_of_nonneg_right hsquares hCurvature

theorem adoptionVariance_strictMono (m : MomentInputs)
    (hCurvature : 0 < curvature m) {theta₁ theta₂ : ℝ}
    (hTheta₁ : 0 ≤ theta₁) (hOrder : theta₁ < theta₂) :
    adoptionVariance m theta₁ < adoptionVariance m theta₂ := by
  unfold adoptionVariance
  have hsquares : theta₁ ^ 2 < theta₂ ^ 2 := by nlinarith
  exact mul_lt_mul_of_pos_right hsquares hCurvature

end

end Agrawal.Variance
