##
##
extends Resource

@export var plain_int_no_default: int
@export var plain_int_default: int = 8
@export_range(-3, 5) var int_range: int = -1
@export_enum("Value 0", "Value 1", "Value 2") var int_enum: int = 0
@export_flags("Flag 1", "Flag 2", "Flag 3") var int_flags: int = 0
@export var file_reference: int

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
