extends Node

const SAVE_PATH := "user://save.json"
const VERSION := 1

var data := {
	"version": VERSION,
	"meta": { "shards": 0 },
	"archetype_unlocks": {
		"pyromancer": false, "necromancer": false, "cryomancer": false, "arcanist": false
	},
	"options": { "volume_music": 0.8, "volume_sfx": 0.9 },
}

func _ready() -> void:
	load_game()

func add_shards(n:int) -> void:
	data.meta.shards = max(0, int(data.meta.shards) + n)

func spend_shards(n:int) -> bool:
	if data.meta.shards >= n:
		data.meta.shards -= n
		return true
	return false

func try_unlock_archetype(id:String, cost:int) -> bool:
	if data.archetype_unlocks.get(id, false): return true
	if spend_shards(cost):
		data.archetype_unlocks[id] = true
		save_game()
		return true
	return false

func save_game() -> void:
	var f := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify(data, "  "))
		f.flush()

func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		save_game()
		return

	var f := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not f: 
		return

	var txt := f.get_as_text()
	var parsed: Variant = JSON.parse_string(txt)

	if typeof(parsed) == TYPE_DICTIONARY:
		data = _migrate_if_needed(parsed as Dictionary)
	else:
		push_error("Save file corrupted or wrong type. Resetting.")
		save_game()


func _migrate_if_needed(d:Dictionary) -> Dictionary:
	var v := int(d.get("version", 0))
	if v == VERSION: return d
	# Future migrations go here (copy fields, set defaults)
	d.version = VERSION
	return d
