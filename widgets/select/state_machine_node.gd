extends NPANode
# number of children until the first input
const HEADER_CHILDREN := 2

@onready var creationMenu := $Graph/GraphEdit/PopupMenu
@export var graph_node_template : PackedScene

var state_count := 0
var created_position: Vector2

func _ready():
	super._ready()
	set_in_out(0, NPA.Type._int, NPA.Type._Animation)
	$Graph/GraphEdit.create_at.connect(_request_creation)
	creationMenu.index_pressed.connect(_create_node)

func _create_node(_index: int):
	add_child(_empty_port())
	set_input(state_count + HEADER_CHILDREN, NPA.Type._Animation)
	var c := graph_node_template.instantiate()
	c.global_position = created_position
	$Graph/GraphEdit.add_child(c)
	state_count += 1

func _request_creation(event_position: Vector2):
	var embed = ProjectSettings.get_setting('display/window/subwindows/embed_subwindows')
	created_position = event_position
	if embed:
		creationMenu.position = event_position
	else:
		var v := get_viewport_rect()
		creationMenu.position = v.position + event_position
	creationMenu.popup()

func _empty_port() -> Control:
	var c := Control.new()
	c.custom_minimum_size.y = 35
	return c
