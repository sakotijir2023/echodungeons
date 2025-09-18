extends Node

# Player
var player_base_hp := 100
var player_move_speed := 180.0

# Economy
var shard_drop_chance := 0.25
var shard_min_max := Vector2i(1, 3)

func shards_for_drop() -> int:
	return RNG.rangei(shard_min_max.x, shard_min_max.y)  # uses your RNG autoload
