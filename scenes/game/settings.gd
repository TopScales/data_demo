##
## Brief description.
##
## Long description.
##
@icon("res://assets/icons/classes/settings.svg")
class_name Settings
extends Node

const BUS_MASTER: StringName = &"Master"
const BUS_MUSIC: StringName = &"Music"
const BUS_SOUNDFX: StringName = &"SoundFX"

const CONFIG_PATH: String = "user://settings.cfg"

const _MOD: StringName = &"Settings"

var _master_bus_idx: int
var _music_bus_idx: int
var _soundfx_bus_idx: int

var _muted_master: bool = false
var _muted_music: bool = false
var _muted_soundfx: bool = false

@onready var _config: ConfigFile = ConfigFile.new()

# =============================================================
# ========= Public Functions ==================================

func set_bus_mute(bus: StringName) -> void:
	match bus:
		BUS_MASTER:
			AudioServer.set_bus_mute(_master_bus_idx, true)
			_config.set_value("audio", "master_muted", true)
			_muted_master = true
		BUS_MUSIC:
			AudioServer.set_bus_mute(_music_bus_idx, true)
			_config.set_value("audio", "music_muted", true)
			_muted_music = true
		BUS_SOUNDFX:
			AudioServer.set_bus_mute(_soundfx_bus_idx, true)
			_config.set_value("audio", "soundfx_muted", true)
			_muted_soundfx = true


func set_bus_volume(volume: float, bus: StringName) -> void:
	match bus:
		BUS_MASTER:
			AudioServer.set_bus_volume_db(_master_bus_idx, volume)
			_config.set_value("audio", "master", volume)

			if _muted_master:
				AudioServer.set_bus_mute(_master_bus_idx, false)
				_config.erase_section_key("audio", "master_muted")
				_muted_master = false
		BUS_MUSIC:
			AudioServer.set_bus_volume_db(_music_bus_idx, volume)
			_config.set_value("audio", "music", volume)

			if _muted_music:
				AudioServer.set_bus_mute(_music_bus_idx, false)
				_config.erase_section_key("audio", "music_muted")
				_muted_music = false
		BUS_SOUNDFX:
			AudioServer.set_bus_volume_db(_soundfx_bus_idx, volume)
			_config.set_value("audio", "soundfx", volume)

			if _muted_soundfx:
				AudioServer.set_bus_mute(_soundfx_bus_idx, false)
				_config.erase_section_key("audio", "soundfx_muted")
				_muted_soundfx = false


func get_bus_volume(bus: StringName) -> float:
	match bus:
		BUS_MASTER:
			return AudioServer.get_bus_volume_db(_master_bus_idx)
		BUS_MUSIC:
			return AudioServer.get_bus_volume_db(_music_bus_idx)
		BUS_SOUNDFX:
			return AudioServer.get_bus_volume_db(_soundfx_bus_idx)

	return 0.0


func save_config() -> void:
	Err.try_err(_config.save(CONFIG_PATH), "Can't save config file.", _MOD)

# =============================================================
# ========= Callbacks =========================================

func _ready() -> void:
	__load_config()

# =============================================================
# ========= Virtual Methods ===================================

# =============================================================
# ========= Private Functions =================================

func __load_config() -> void:
	_master_bus_idx = AudioServer.get_bus_index(&"Master")
	_music_bus_idx = AudioServer.get_bus_index(&"Music")
	_soundfx_bus_idx = AudioServer.get_bus_index(&"SoundFX")

	if FileAccess.file_exists(CONFIG_PATH) \
			and Err.success_err(_config.load(CONFIG_PATH), "Can't open config file.", _MOD):
		AudioServer.set_bus_volume_db(_master_bus_idx, _config.get_value("audio", "master", 0.0))
		AudioServer.set_bus_volume_db(_music_bus_idx, _config.get_value("audio", "music", -2.0))
		AudioServer.set_bus_volume_db(_soundfx_bus_idx, _config.get_value("audio", "soundfx", 0.0))
		_muted_master = _config.get_value("audio", "master_muted", false)
		_muted_music = _config.get_value("audio", "music_muted", false)
		_muted_soundfx = _config.get_value("audio", "soundfx_muted", false)
		AudioServer.set_bus_mute(_master_bus_idx, _muted_master)
		AudioServer.set_bus_mute(_music_bus_idx, _muted_music)
		AudioServer.set_bus_mute(_soundfx_bus_idx, _muted_soundfx)


# =============================================================
# ========= Signal Callbacks ==================================
