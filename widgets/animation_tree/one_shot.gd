extends NPANode

func _ready():
	super._ready()
	set_in_out(0, NPA.Type._Animation, NPA.Type._Animation)
	set_input(1, NPA.Type._Animation)
	set_input(2, NPA.Type._bool)
