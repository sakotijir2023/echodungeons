extends Node

## Main Scene Script ##

func _ready() -> void:
	print("Main Scene Loaded!")

	Signals.run_started.emit(RNG.get_seed())
	FX.play_screen_shake(0.5)
	Save.add_shards(3); Save.save_game()
	print("Shards:", Save.data.meta.shards)
	if has_node("/root/Platform"):
		print("Profile?", Platform.platform_label)
	else:
		print("Profile?", "no Platform")


	# Placeholder world object
	var placeholder = ColorRect.new()
	placeholder.color = Color.DARK_SLATE_GRAY
	placeholder.size = Vector2(1280, 720)
	$GameRoot.add_child(placeholder)

	# Placeholder HUD text
	var hud = Label.new()
	hud.text = "Echo Dungeons - Prototype Start"
	hud.add_theme_color_override("font_color", Color.WHITE)
	hud.position = Vector2(20, 20)
	$UIRoot.add_child(hud)

	## Reproducable Runs During Testing ##
	# RNG.init(12345)
	
	# For normal gameplay
	RNG.init()
	
	print("Seed in Use:", RNG.get_seed())
	print("Random Pick:", RNG.pick([1,2,3,4,5]))
