class_name NPANode
extends GraphNode

const COLOR_SELECTED := Color.GHOST_WHITE

func _ready():
	var _x = resize_request.connect(_on_resize_request)

func _process(_delta):
	size = Vector2(0,0)

func _on_resize_request(min_size: Vector2):
	custom_minimum_size = min_size

func set_input(slot: int, type: NPA.Type):
	set_slot(slot, true, type, NPA.colors[type], false, 0, Color.BLACK)

func set_output(slot: int, type: NPA.Type):
	set_slot(slot, false, 0, Color.BLACK, true, type, NPA.colors[type])

func set_in_out(slot: int, type_in: NPA.Type, type_out: NPA.Type):
	set_slot(slot,
		true, type_in, NPA.colors[type_in],
		true, type_out, NPA.colors[type_out])

func set_input_color(slot: int, color: Color):
	set_slot_color_left(slot, color)

func set_output_color(slot: int, color: Color):
	set_slot_color_right(slot, color)

func reset_input_color(slot: int):
	set_slot_color_left(slot, NPA.colors[get_slot_type_left(slot)])

func reset_output_color(slot: int):
	set_slot_color_right(slot, NPA.colors[get_slot_type_right(slot)])

func delete_port(node: Node):
	var slot = get_children().find(node)
	var edit := get_parent() as NPA
	if !edit:
		print_debug("No GraphEdit node for ", get_path())
		return
		
	if slot < 0:
		return
	edit.disconnect_all(self, slot)
	clear_slot(slot)
	
	for s in range(slot+1, get_child_count()):
		copy_slot(s, s-1)
		edit.reconnect_slot(self, s, s-1)
	var end = get_child_count()
	clear_slot(end)
	node.queue_free()

func copy_slot(slot:int, new_slot: int):
	set_slot(
		new_slot,
		is_slot_enabled_left(slot),
		get_slot_type_left(slot),
		get_slot_color_left(slot),
		is_slot_enabled_right(slot),
		get_slot_type_right(slot),
		get_slot_color_right(slot)
	)

func animation_dropdown(select: OptionButton):
	var p := get_parent()
	while p and p is not NPA:
		p = p.get_parent()
	if p is NPA:
		p._animation_dropdown(select)
	else:
		push_error('Parent of node was not NP-Animator UI')

static func _type_dropdown(select: OptionButton):
	select.clear()
	for c in NPA.Type.keys():
		select.add_item(c.capitalize())

# TODO: do I want to implement a more declarative system?
func _inputs() -> Array[Dictionary]:
	return []

func _outputs() -> Array[Dictionary]:
	return []

func _build_node():
	for input in _inputs():
		pass
	for output in _outputs():
		pass
