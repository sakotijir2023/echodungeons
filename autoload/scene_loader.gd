extends Node

signal scene_changed(new_path:String)

var _is_loading := false

func goto(path:String) -> void:
	if _is_loading: return
	_is_loading = true
	# TODO: trigger fade-out UI here (emit signal or call a Fade layer)
	call_deferred("_do_change", path)

func _do_change(path:String) -> void:
	var err := get_tree().change_scene_to_file(path)
	if err != OK:
		push_error("Failed to change scene: %s (err %s)" % [path, err])
	emit_signal("scene_changed", path)
	_is_loading = false
	# TODO: trigger fade-in
