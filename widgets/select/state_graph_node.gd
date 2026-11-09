extends NPANode

func _ready():
	super._ready()
	set_in_out(0, NPA.Type._Animation, NPA.Type._Animation)
	animation_dropdown($OptionButton)
