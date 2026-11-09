class_name EmptyStateNode
extends NPANode

@export var start := true:
	set(s):
		start = s
		_update()

func _update():
	if start:
		title = "Start"
		set_output(0, NPA.Type._Animation)
	else:
		title = "End"
		set_input(0, NPA.Type._Animation)
