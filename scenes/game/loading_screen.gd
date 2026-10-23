##
##
class_name LoadingScreen
extends Control

signal scene_loaded

const PROGRESS_ADVANCE_TIME: float = 0.2

const _MOD: StringName = &"LoadingScreen"

var path: String

var _scene_load_weight: float = 1.0
var _accum_progress: float = 0.0
var _tween: Tween

@onready var _progress_bar: ProgressBar = $ProgressBar

# =============================================================
# ========= Public Functions ==================================

# =============================================================
# ========= Callbacks =========================================

func _ready() -> void:
	if path.is_empty():
		Game.standalone_scene = false
		path = Game.main_scene_path
		#_scene_load_weight = 1.0 - Data.DATA_LOAD_WEIGHT
		#Data.load_data()
		#__set_progress(1.0, Data.DATA_LOAD_WEIGHT)
		#_accum_progress = Data.DATA_LOAD_WEIGHT

	Err.try_err(ResourceLoader.load_threaded_request(path, "PackedScene"), "Error while trying to load scene in the background.", _MOD)


func _process(_delta: float) -> void:
	var progress: Array
	var status: int = ResourceLoader.load_threaded_get_status(path, progress)
#
	match status:
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			Log.error("Background loading tried to load an invalid scene.", _MOD)
			set_process(false)
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			__set_progress(progress[0], _scene_load_weight)
		ResourceLoader.THREAD_LOAD_FAILED:
			Log.error("Background loading failed to load the scene.", _MOD)
			set_process(false)
		ResourceLoader.THREAD_LOAD_LOADED:
			set_process(false)
			var scene: PackedScene = ResourceLoader.load_threaded_get(path)
			__set_progress(1.0, _scene_load_weight)
			await _tween.finished
			scene_loaded.emit()
			Err.try_err(get_tree().change_scene_to_packed(scene), "Can't change main scene.", _MOD)

# =============================================================
# ========= Virtual Methods ===================================

# =============================================================
# ========= Private Functions =================================

func __set_progress(value: float, weight: float) -> void:
	if _tween and _tween.is_valid():
		_tween.kill()

	var total_progress: float = _accum_progress + value * weight
	_tween = create_tween()
	@warning_ignore("return_value_discarded")
	_tween.tween_property(_progress_bar, "value", total_progress, PROGRESS_ADVANCE_TIME)

# =============================================================
# ========= Signal Callbacks ==================================
