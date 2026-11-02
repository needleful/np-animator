extends GraphNode
class_name NPANode

func _ready():
	var _x = connect("resize_request", Callable(self, "_on_resize_request"))

func _process(_delta):
	size = Vector2(0,0)

func _on_resize_request(min_size: Vector2):
	custom_minimum_size = min_size

func set_input(slot: int, type: int):
	set_slot(slot, true, type, NPA.colors[type], false, 0, Color.BLACK)

func set_output(slot: int, type: int):
	set_slot(slot, false, 0, Color.BLACK, true, type, NPA.colors[type])

func set_in_out(slot: int, type_in: int, type_out: int):
	set_slot(slot,
		true, type_in, NPA.colors[type_in],
		true, type_out, NPA.colors[type_out])
	
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
