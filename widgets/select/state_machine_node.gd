extends NPANode
# number of children until the first input
const HEADER_CHILDREN := 2

@onready var creationMenu := $Graph/GraphEdit/PopupMenu
@onready var stateInput: IntProperty = $HBoxContainer/IntInput
@export var graph_node_template : PackedScene
@export var empty_node_template : PackedScene

var max_state_id := 0
var created_position: Vector2

var has_start := false
var has_end := false

var state_labels: Dictionary[int, Label]

func _ready():
	super._ready()
	set_in_out(0, NPA.Type._int, NPA.Type._Animation)
	$Graph/GraphEdit.create_at.connect(_request_creation)
	creationMenu.index_pressed.connect(_create_node)

func _create_node(index: int):
	var c: GraphNode
	match index:
		# State
		0:
			var l := Label.new()
			add_child(l)
			set_input(get_child_count() - 1, NPA.Type._Animation)
			c = graph_node_template.instantiate()
			if c is StateGraphNode:
				c.id = max_state_id
				c.default_name = 'state'+str(max_state_id)
				c.name_changed.connect(_on_state_name_changed)
				max_state_id += 1
				l.text = c.default_name
				state_labels[c.id] = l
				stateInput.range_max = c.id
		1, 2:
			c = empty_node_template.instantiate()
			if c is EmptyStateNode:
				c.start = index == 1
				if c.start:
					if has_start:
						push_warning('Tried to create another start node!')
						c.free()
						return
					has_start = true
				else:
					if has_end:
						push_warning('Tried to create another end node!')
						c.free()
						return
					has_end = true
	$Graph/GraphEdit.add_child(c)
	c.global_position = created_position

func _on_state_name_changed(new_name: String, id: int):
	if id in state_labels:
		if not new_name:
			new_name = 'state'+str(id)
		state_labels[id].text = new_name

func _request_creation(event_position: Vector2):
	var embed = ProjectSettings.get_setting('display/window/subwindows/embed_subwindows')
	created_position = event_position
	if embed:
		creationMenu.position = event_position
	else:
		var v := get_viewport_rect()
		creationMenu.position = v.position + event_position
	creationMenu.popup()
