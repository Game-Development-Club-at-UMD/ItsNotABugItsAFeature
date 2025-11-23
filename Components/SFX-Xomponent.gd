class_name SFX 
extends Resource

@export var attack_sounds: Array[AudioStream] = []
@export var die_sounds: Array[AudioStream] = []
@export var hit_sounds: Array[AudioStream] = []

func get_random_sound(type: String) -> AudioStream:
	match type:
		"attack":
			return attack_sounds.pick_random()
		"die":
			return die_sounds.pick_random()
		"hit":
			return hit_sounds.pick_random()
	return null
