class_name BlendNode
extends NPANode

enum BlendType {
	Mix,
	Add,
	Subtract
}

@export var blend_type := BlendType.Mix
@export var blend_count := 2

func _ready():
	super._ready()
	for b in blend_count:
		set_input(b, NPA.Type._Animation)
	set_in_out(blend_count, NPA.Type._float, NPA.Type._Animation)
