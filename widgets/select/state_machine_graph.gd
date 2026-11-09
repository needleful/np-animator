class_name StateMachineGraphEdit
extends GraphEdit

signal create_at(global_position: Vector2)
signal clicked(global_position: Vector2)

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			create_at.emit(event.global_position)
		elif event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			clicked.emit(event.position)

func _ready():
	var _x = connection_request.connect(_on_connection_request)
	_x = disconnection_request.connect(_on_disconnection_request)

func _on_connection_request(from: String, from_slot:int, to:String, to_slot:int):
	var res = connect_node(from, from_slot, to, to_slot)
	if res != OK:
		print_debug("Could not connect %s and %s: %d" % [from, to, res])

func _on_disconnection_request(from, from_slot, to, to_slot):
	disconnect_node(from, from_slot, to, to_slot)
