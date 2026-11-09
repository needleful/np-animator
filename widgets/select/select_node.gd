extends NPANode

# number of children in the node until the first match row
const HEADER_CHILDREN := 1
const FOOTER_CHILDREN := 2

@onready var item := $item
@onready var item_template := item.duplicate()

func _ready():
	super._ready()
	set_in_out(0, NPA.Type._int, NPA.Type._Animation)
	set_input(1, NPA.Type._float)
	
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
	var pos := get_child_count() - FOOTER_CHILDREN
	var n := item_template.duplicate()
	add_child(n)
	move_child(n, pos)
	set_input(pos+1, NPA.Type._Animation)
