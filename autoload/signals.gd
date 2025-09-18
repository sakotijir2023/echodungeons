extends Node

# -------- Declare your global signals here --------
signal run_started(seed:int)
signal run_ended(stats:Dictionary)

signal profile_applied(profile)          # e.g., relay from Platform
signal shard_collected(amount:int, where:Vector2)
signal player_died(cause:String)
signal echo_spawned(data:Dictionary)

# -------- Safe emit helper (uses callv) --------
func emit_safe(sig: String, args: Array = []) -> void:
	if has_signal(sig):
		# callv lets us pass a dynamic arg list as an Array
		self.callv("emit_signal", [sig] + args)
	else:
		push_warning("Signals.emit_safe: unknown signal '%s'" % sig)

# (Nice-to-have) connect helper that no-ops if already connected
func connect_safe(sig: String, target: Object, method: StringName) -> void:
	if not has_signal(sig):
		push_warning("Signals.connect_safe: unknown signal '%s'" % sig)
		return
	var c := Callable(target, method)
	if not is_connected(sig, c):
		connect(sig, c)
