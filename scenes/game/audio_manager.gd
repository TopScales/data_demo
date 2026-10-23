@tool
extends Node

#const START_MUSIC: AudioStreamOggVorbis = preload("uid://ehx3brq2kp2w")
#const GAMEPLAY_MUSIC: AudioStreamOggVorbis = preload("uid://brscx8ujael15")

const _MODULE: StringName = &"AudioManager"

#@export var button_sound: SoundEffect
#
#var _current_sounds: Dictionary[SoundEffect, int]

#@onready var _music_player: AudioStreamPlayer = $MusicPlayer
#@onready var _sound_players: Array[AudioStreamPlayer] = [$SoundPlayer]

# =============================================================
# ========= Public Functions ==================================

#func play_music(stream: AudioStreamOggVorbis) -> void:
	#if not _music_player.playing or _music_player.stream != stream:
		#_music_player.stream = stream
		#_music_player.play()
#
#
#func play_sound(sound: SoundEffect) -> void:
	#var count: int = _current_sounds.get(sound, 0)
#
	#if count < sound.limit:
		#var player: AudioStreamPlayer = null
#
		#if _sound_players.is_empty():
			#player = AudioStreamPlayer.new()
			#add_child(player)
			#player.bus = &"SoundFX"
		#else:
			#player = _sound_players.pop_back()
#
		#player.stream = sound.stream
		#player.volume_db = sound.volume
#
		#if sound.pitch_randomness == 0.0:
			#player.pitch_scale = sound.pitch_scale
		#else:
			#var r: float = randf_range(-sound.pitch_randomness, sound.pitch_randomness)
			#player.pitch_scale = clamp(sound.pitch_scale + r, 0.01, 4.0)
#
		#Err.conn(player.finished, _on_sound_player_finished.bind(sound, player), CONNECT_ONE_SHOT, _MODULE)
		#player.play()
		#_current_sounds[sound] = count + 1
#
#
#func play_button_sound() -> void:
	#play_sound(button_sound)


# =============================================================
# ========= Built-in Functions ================================

# =============================================================
# ========= Virtual Methods ===================================

# =============================================================
# ========= Private Functions =================================

# =============================================================
# ========= Signal Callbacks ==================================

#func _on_sound_player_finished(sound: SoundEffect, player: AudioStreamPlayer) -> void:
	#_sound_players.push_back(player)
	#var count: int = _current_sounds[sound]
#
	#if count == 0:
		#Err.try_erase(_current_sounds.erase(sound), _MODULE)
	#else:
		#_current_sounds[sound] = count - 1
