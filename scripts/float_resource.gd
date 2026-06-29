extends Resource

@export var plain_float_no_default: float
@export var plain_float_default: float = 3.14
@export_range(-3.0, 5.0, 0.1) var float_range: float = -1
@export_exp_easing var float_exp: float = 0.0
@export_exp_easing("attenuation") var float_attenuation: float = 0.0
@export_exp_easing("positive_only") var float_exp_positive: float = 1.0


# =============================================================
# ========= Public Functions ==================================

# =============================================================
# ========= Built-in Functions ================================

# =============================================================
# ========= Virtual Methods ===================================

# =============================================================
# ========= Private Functions =================================

# =============================================================
# ========= Signal Callbacks ==================================
