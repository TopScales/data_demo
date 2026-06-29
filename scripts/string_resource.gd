extends Resource

@export var plain_string: String
@export var string_name: StringName
@export_enum("Option 1", "Option 2") var string_enum: String = "Option 1"
@export_file_path("*.gd") var file: String
@export_dir var directory: String
@export var file_collection_reference: String

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
