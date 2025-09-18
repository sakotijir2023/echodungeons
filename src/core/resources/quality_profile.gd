extends Resource
class_name QualityProfile

@export var id: String = "desktop_high"
@export var resolution_scale: float = 1.0
@export var glow_enabled: bool = true
@export var particles_max: int = 600
@export_enum("low:0", "med:1", "high:2") var shader_quality: int = 2

## Issues ##
#@export var shadows_enabled: bool = true
