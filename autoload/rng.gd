extends Node

## Random Number Generator Script ## 

var _rng := RandomNumberGenerator.new()
var _fixed := false
var _seed_used: int = 0

## Called Once At Boot / Main ##
## If Fixed Seed Zero; Init Becomes Deterministic ##
func init(fixed_seed: int = 0) -> void:
	if fixed_seed != 0:
		set_fixed_seed(fixed_seed)
	else:
		reseed_with_entropy()

func reseed_with_entropy() -> void:
	_fixed = false
	_rng.randomize()
	_seed_used = _rng.seed
	print("RNG reseeded with entropy ->", _seed_used)

func set_fixed_seed(seed: int) -> void:
	_fixed = true
	_rng.seed = seed
	_seed_used = seed
	print("RNG fixed seed ->", _seed_used)

func get_seed() -> int:
	return _seed_used

# ---------- Convenience helpers ----------
func randi() -> int: 
	return _rng.randi()

func randf() -> float: 
	return _rng.randf()

func rangei(a:int, b:int) -> int:
	return _rng.randi_range(a, b)  # inclusive range

func rangef(a:float, b:float) -> float:
	return lerp(a, b, _rng.randf())

func chance(p: float) -> bool: # p in [0,1]
	return _rng.randf() < clamp(p, 0.0, 1.0)

func pick(arr: Array):
	if arr.is_empty():
		return null
	return arr[_rng.randi_range(0, arr.size() - 1)]

func shuffle(arr: Array) -> void:
	arr.shuffle()  # Godot 4.4 built-in
