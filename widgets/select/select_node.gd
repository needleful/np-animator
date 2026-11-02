extends NPANode

# number of children in the node until the first match row
const HEADER_CHILDREN := 1
const FOOTER_CHILDREN := 2

@onready var item := $item
@onready var item_template := item.duplicate()

func _ready():
	set_input(0, NPA.Type._int)
	set_output(get_child_count() - FOOTER_CHILDREN, NPA.Type._Animation)
	
	var slot := get_children().find(item)
	if slot >= 0:
		add_item(slot, item)

func add_item(slot: int, _item: Node):
	set_input(slot, NPA.Type._Animation)

func delete_item(new_item: Node):
	var i = get_children().find(new_item) - HEADER_CHILDREN
	if i < 0:
		return
	delete_port(new_item)

func _on_add_pressed():
	var old_output := get_child_count() - FOOTER_CHILDREN
	var n := item_template.duplicate()
	add_child(n)
	move_child(n, old_output)

	var new_output := get_child_count() - FOOTER_CHILDREN
	copy_slot(old_output, new_output)
	
	var edit := get_parent() as NPA
	if edit:
		edit.reconnect_slot(self, old_output, new_output)
	
	set_input(old_output, NPA.Type._Animation)
	
	var slot := get_children().find(item)
	add_item(slot, n)
