##
## Game saver
##
@icon("res://assets/icons/classes/saver.svg")
class_name Saver
extends Node

const SAVES_PATH: String = "user://saves/"
const SAVE_EXTENSION: String = "save"
const FILE_VERSION: int = 1
const HEADER_SIZE: int = 4

const _MOD: StringName = &"Saver"

@export_range(0, 10) var num_save_files: int = 0

var saved_games: int = 0

var _saves_list: PackedStringArray
var _open_files: Dictionary[int, FileAccess]

# =============================================================
# ========= Public Functions ==================================

func has_saved_games() -> bool:
	return saved_games != 0


func get_saved_file(index: int = 0) -> FileAccess:
	var file: FileAccess = _open_files.get(index, null)

	if file == null:
		var file_name: String = _saves_list[index]
		file = FileAccess.open(file_name, FileAccess.READ)

		if Err.success_err(FileAccess.get_open_error(), "Can't open save file %s." % file_name, _MOD):
			_open_files[index] = file

	return file


func get_saved_file_data_offset(file: FileAccess) -> int:
	file.seek(0)
	var version: int = file.get_16()

	if version == FILE_VERSION:
		return HEADER_SIZE
	else:
		return 0

# =============================================================
# ========= Callbacks =========================================

func _ready() -> void:
	if not DirAccess.dir_exists_absolute(SAVES_PATH):
		Err.try_err(DirAccess.make_dir_recursive_absolute(SAVES_PATH), "Can't create saves directory.", _MOD)

	saved_games = 0
	_saves_list.clear()
	var dir: DirAccess = DirAccess.open(SAVES_PATH)

	if Err.success_err(DirAccess.get_open_error(), "", _MOD):
		var files: PackedStringArray = dir.get_files()

		for file in files:
			if file.get_extension() == SAVE_EXTENSION:
				Err.try_append(_saves_list.push_back(SAVES_PATH + file), _MOD)
				saved_games += 1

# =============================================================
# ========= Virtual Methods ===================================

# =============================================================
# ========= Private Functions =================================

# =============================================================
# ========= Signal Callbacks ==================================
