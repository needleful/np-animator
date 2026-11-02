extends NPANode

@onready var state_template := $state.duplicate()
@onready var states_list := $header/states

# number of children in the state machine editor until the first state row
const HEADER_CHILDREN := 1
const FOOTER_CHILDREN := 2

func _ready():
	var state := $state 
	set_input(0, NPA.Type._int)
	set_output(get_child_count() - FOOTER_CHILDREN, NPA.Type._Animation)
	var slot := get_children().find(state)
	if slot < 0:
		return
	set_input(slot, NPA.Type._Animation)
	add_state(state)

func add_state(state: Node):
	var state_name = "state"+str(states_list.get_child_count())
	state.set_state_name(state_name)
	var l := Label.new()
	l.text = state_name
	l.custom_minimum_size.x = 110
	states_list.add_child(l)
	for s in range(HEADER_CHILDREN, get_child_count() - FOOTER_CHILDREN):
		var snode = get_child(s)
		snode.add_transition()
	state.set_transition_count(states_list.get_child_count())

func delete_state(state: Node):
	var i = get_children().find(state) - HEADER_CHILDREN
	if i < 0:
		return
	states_list.remove_child(states_list.get_child(i))
	delete_port(state)
	for s in range(HEADER_CHILDREN, get_child_count() - FOOTER_CHILDREN):
		var snode = get_child(s)
		snode.delete_transition(i)

func rename_state(state: Node, text: String):
	var i = get_children().find(state) - HEADER_CHILDREN
	if i < 0:
		return
	var label = states_list.get_child(i) as Label
	if !label:
		print_debug("Missing label for state: ", state.get_path())
	else:
		label.text = text

func _on_add_pressed():
	var old_output := get_child_count() - FOOTER_CHILDREN
	var new_state = state_template.duplicate()
	add_child(new_state)
	move_child(new_state, old_output)
	
	var new_output := get_child_count() - FOOTER_CHILDREN
	copy_slot(old_output, new_output)
	
	var edit := get_parent() as NPA
	if edit:
		edit.reconnect_slot(self, old_output, new_output)
	
	set_input(old_output, NPA.Type._Animation)
	add_state(new_state)
