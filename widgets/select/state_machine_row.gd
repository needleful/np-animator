extends Control
class_name StateRowEdit

@onready var tr_template := $row/transitions/tr.duplicate()
@onready var transitions := $row/transitions
@onready var properties := $row/properties

func _ready():
	$row/properties/animation.clear()
	for a in NPA.animations:
		$row/properties/animation.add_item(a)

func _on_delete_pressed():
	get_parent().delete_state(self)

func _on_name_text_changed(new_text):
	get_parent().rename_state(self, new_text)

func set_state_name(p_name):
	$row/properties/name.placeholder_text = p_name

func add_transition():
	var tr = tr_template.duplicate()
	transitions.add_child(tr)

func delete_transition(i: int):
	transitions.get_child(i).queue_free()

func set_transition_count(count: int):
	var children = transitions.get_child_count()
	var t_count = count
	while t_count > children:
		t_count -= 1
		add_transition()
	t_count = count
	children = transitions.get_child_count()
	while t_count < children:
		t_count += 1
		transitions.remove_child(transitions.get_child(0))
