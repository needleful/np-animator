extends NPANode

@onready var row_template:Control = $inputRow.duplicate()

# Number of nodes at the bottom of the control
const FIXED_NODES := 2

func _ready():
	super._ready()
	set_row_type($inputRow, $inputRow.get_type())

func _on_add_pressed():
	var pos := get_child_count() - FIXED_NODES
	var new_row := row_template.duplicate()
	add_child(new_row)
	move_child(new_row, pos)
	set_row_type(new_row, new_row.get_type())

func set_row_type(row: Node, type: int):
	var pos = get_children().find(row)
	if pos < 0:
		return
	set_output(pos, type)
