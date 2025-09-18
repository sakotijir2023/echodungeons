extends Node

var particles_budget:int = 600

func set_particles_budget(n:int) -> void:
	particles_budget = n

func play_screen_shake(intensity: float = 1.0) -> void:
	# Replace with your Camera2D shaker later; for now just log:
	print("[FX] shake x", intensity)

func spawn_effect(name:String, pos:Vector2, parent:Node=null) -> void:
	if parent == null: parent = get_tree().current_scene
	# Stub: later load from a map {name: PackedScene}
	print("[FX] spawn:", name, "at", pos)
