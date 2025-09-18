extends Node

signal profile_applied(profile: QualityProfile)

var current_profile: QualityProfile
var is_deck: bool = false
var platform_label: String = "desktop"

## Paths to assets (fixed) ##
const P_DESKTOP: String  = "res://app/config/quality_profiles/desktop_high.tres"
const P_DECK_MED: String = "res://app/config/quality_profiles/deck_med.tres"   # fixed
const P_DECK_LOW: String = "res://app/config/quality_profiles/deck_low.tres"   # fixed

func _ready() -> void:
	var profile := _choose_profile()
	_apply_profile(profile)

func _choose_profile() -> QualityProfile:
	var args := OS.get_cmdline_args()
	var force_deck_low := args.has("--deck-low")
	var force_deck_med := args.has("--deck") or args.has("--deck-med")
	var is_deck_env := OS.get_environment("STEAM_DECK") == "1"

	# Heuristic: Linux + 1280x800 looks like Deck
	var is_linux := OS.get_name() == "Linux"
	var size := DisplayServer.screen_get_size()
	var looks_like_deck := is_linux and size == Vector2i(1280, 800)

	var path := P_DESKTOP
	is_deck = false
	platform_label = "desktop"

	if force_deck_low:
		path = P_DECK_LOW
		is_deck = true
		platform_label = "deck_low"
	elif force_deck_med or is_deck_env or looks_like_deck:
		path = P_DECK_MED
		is_deck = true
		platform_label = "deck_med"

	var prof := load(path) as QualityProfile
	assert(prof != null, "Failed to load QualityProfile at: %s" % path)
	return prof

func _apply_profile(profile: QualityProfile) -> void:
	current_profile = profile

	## Resolution scale ##
	var root := get_tree().root
	root.content_scale_factor = profile.resolution_scale

	## Glow toggle via WorldEnvironment ##
	var env := _find_world_environment()
	if env and env.environment:
		env.environment.glow_enabled = profile.glow_enabled

	## Shader quality as global parameter ##
	RenderingServer.global_shader_parameter_set("quality_level", profile.shader_quality)

	## FX budget hook (autoload named 'FX') ##
	if has_node("/root/FX"):
		var fx = get_node("/root/FX")
		if fx and fx.has_method("set_particles_budget"):
			fx.set_particles_budget(profile.particles_max)

	emit_signal("profile_applied", profile)
	print("Platform profile applied:", platform_label)

func _find_world_environment() -> WorldEnvironment:
	# Prefer a node you added to group "world_environment"
	for n in get_tree().get_nodes_in_group("world_environment"):
		if n is WorldEnvironment:
			return n
	# Fallback: recursive search
	return _find_first_world_env(get_tree().root)

func _find_first_world_env(node: Node) -> WorldEnvironment:
	if node is WorldEnvironment:
		return node
	for c in node.get_children():
		var found := _find_first_world_env(c)
		if found:
			return found
	return null
