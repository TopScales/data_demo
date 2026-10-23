##
@tool
@icon("res://assets/icons/classes/game.svg")
extends Node

const LOADING_SCREEN_PATH: String = "res://scenes/game/loading_screen.tscn"

const _MOD: StringName = &"Game"

@export var version: Version
@export_file("*.scn", "*.tscn") var main_scene_path: String

var standalone_scene: bool = true

var _loading_scene: bool = false

@onready var settings: Settings = $Settings
@onready var saver: Saver = $Saver
@onready var debug: Debug = null

# =============================================================
# ========= Public Functions ==================================


func change_active_scene(
	path: String, use_loading_screen: bool = false, initial_data: Dictionary[StringName, Variant] = {}
) -> void:
	if Err.fail(_loading_scene, "Already loading a scene.", _MOD):
		return

	_loading_scene = true

	if use_loading_screen:
		var scene: PackedScene = load(LOADING_SCREEN_PATH)
		var loading_screen: LoadingScreen = scene.instantiate()
		loading_screen.path = path
		Err.conn(loading_screen.scene_loaded, _on_scene_loaded.bind(initial_data), 0, _MOD)
		Err.try_err(get_tree().change_scene_to_node(loading_screen), "Can't open loading screen.", _MOD)
	elif Err.success_err(get_tree().change_scene_to_file(path), "Can't open active scene.", "Game"):
		await get_tree().scene_changed
		__initialize_scene(initial_data)
		_loading_scene = false


# =============================================================
# ========= Callbacks =========================================


func _ready() -> void:
	if Engine.is_editor_hint() and version:
		ProjectSettings.set_setting("application/config/version", version.get_as_string(false, false))


# =============================================================
# ========= Virtual Methods ===================================

# =============================================================
# ========= Private Functions =================================


func __initialize_scene(initial_data: Dictionary[StringName, Variant]) -> void:
	var scene: Node = get_tree().current_scene

	for prop in initial_data:
		var value: Variant = initial_data[prop]
		scene.set(prop, value)

# =============================================================
# ========= Signal Callbacks ==================================

func _on_scene_loaded(initial_data: Dictionary[StringName, Variant]) -> void:
	await get_tree().scene_changed
	_loading_scene = false
	__initialize_scene(initial_data)
