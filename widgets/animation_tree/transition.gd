extends NPANode

func _ready():
	super._ready()
	animation_dropdown($OptionButton)
	set_in_out(0, NPA.Type._Animation, NPA.Type._Animation)
