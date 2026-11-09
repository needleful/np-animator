extends GraphEdit
class_name NPA

enum Type {
	_int,
	_float,
	_bool,
	_Vector2,
	_Vector3,
	_Animation,
	_String
}

const colors = {
	Type._int: Color.CYAN,
	Type._float: Color.RED,
	Type._bool: Color.GREEN,
	Type._Vector2: Color.ORANGE,
	Type._Vector3: Color.YELLOW,
	Type._Animation: Color.DEEP_PINK
}

const animations = [
	"Idle-loop",
	"IdleFlair",
	"RunLevel-loop",
	"RunSlopeUp-loop",
	"RunSlopeDown-loop",
	"SlideRun-loop",
	"Jump",
	"Fall-loop",
	"Crouch-loop",
	"Crawl-loop",
	"ClimbUp-loop",
	"ClimpUpOverhang-loop",
	"ClimbDown-loop",
	"ClimbDownOverhang-loop",
	"ClimbLeft-loop",
	"ClimbLeftOverhang-loop",
	"ClimbRight-loop",
	"ClimbRightOverhang-loop",
	"LungeKickLeft",
	"LungeKickRight",
	"SpinKick"
]

@export var widget_groups: Array[WidgetGroup]

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			$creationMenu.position = event.position
			$creationMenu.popup()

func _ready():
	$Output.set_input(0, Type._Animation)
	var _x = connection_request.connect(_on_connection_request)
	_x = disconnection_request.connect(_on_disconnection_request)
	var menu:PopupMenu = $creationMenu
	for wg in widget_groups:
		var popup := PopupMenu.new()
		menu.add_submenu_node_item(wg.name, popup)
		for widget in wg.widgets:
			_add_widget(popup, widget)
		popup.index_pressed.connect(_create_widget.bind(wg))

func _add_widget(menu: PopupMenu, widget: PackedScene):
	var str_start = widget.resource_path.rfind("/") + 1
	var widget_name = widget.resource_path.substr(str_start, widget.resource_path.rfind(".") - str_start)
	menu.add_item("New "+widget_name.capitalize())

func _on_connection_request(from: String, from_slot:int, to:String, to_slot:int):
	var con = get_connection_list()
	for c in con:
		# Only one connection allowed into a port at a time
		if c.to_node == to and c.to_port == to_slot:
			disconnect_node(c.from_node, c.from_port, to, to_slot)
	var res = connect_node(from, from_slot, to, to_slot)
	if res != OK:
		print_debug("Could not connect %s and %s: %d" % [from, to, res])

func _on_disconnection_request(from, from_slot, to, to_slot):
	disconnect_node(from, from_slot, to, to_slot)

func _on_close_request(n: GraphNode):
	for c in get_connection_list():
		if c.to_node == n.name or c.from_node == n.name:
			disconnect_node(c.from_node, c.from_port, c.to_node, c.to_port)
	n.queue_free()

func disconnect_all(node: GraphNode, port: int):
	var con = get_connection_list()
	for c in con:
		if (c.to_node == node.name and c.to_port == port) or (c.from_node == node.name and c.from_port == port):
			disconnect_node(c.from_node, c.from_port, c.to_node, c.to_port)

func reconnect_slot(node: GraphNode, old_port, new_port):
	var con = get_connection_list()
	for c in con:
		if c.from_node == node.name and c.from_port == old_port:
			disconnect_node(c.from_node, old_port, c.to_node, c.to_port)
			var res = connect_node(c.from_node, new_port, c.to_node, c.to_port)
			if res != OK:
				print_debug("Could not connect %s to %s: %d" % [c.from_node, c.to_node, res])
		if c.to_node == node.name and c.to_port == old_port:
			disconnect_node(c.from_node, c.from_port, c.to_node, old_port)
			var res = connect_node   (c.from_node, c.from_port, c.to_node, new_port)
			if res != OK:
				print_debug("Could not connect %s to %s: %d" % [c.from_node, c.to_node, res])

func _create_widget(index: int, widget_group: WidgetGroup):
	var widget := widget_group.widgets[index]
	var w:NPANode = widget.instantiate()
	add_child(w)
	var m := get_global_mouse_position()
	w.position_offset = (m + scroll_offset) / zoom
	var _x = w.delete_request.connect(_on_close_request.bind(w))

func _animation_dropdown(select: OptionButton):
	select.clear()
	for a in animations:
		select.add_item(a)

# Constrain a LineEdit for a given type
static func _typed_input(text: LineEdit, type: Type):
	match type:
		Type._int:
			text.virtual_keyboard_type = LineEdit.KEYBOARD_TYPE_NUMBER
		Type._float:
			text.virtual_keyboard_type = LineEdit.KEYBOARD_TYPE_NUMBER_DECIMAL
		Type._String:
			text.virtual_keyboard_type = LineEdit.KEYBOARD_TYPE_DEFAULT
		_:
			push_error('Unsupported type for text input: ', type)
