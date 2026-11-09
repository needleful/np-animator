@tool
class_name Anchor
extends Node

@export var anchor_to: Control
@export var local_position := true
@export_group('Offsets', 'offset_')
@export var offset_top: int
@export var offset_bottom: int
@export var offset_left: int
@export var offset_right: int

@onready var p: Control = get_parent()

func _ready():
	set_process(true)

func _process(_delta: float) -> void:
	var anchored_size := anchor_to.size
	var start:Vector2
	var end := Vector2(offset_right, offset_bottom)
	if local_position:
		start = p.global_position - anchor_to.global_position
	else:
		start = Vector2(offset_left, offset_top)
		p.global_position = anchor_to.global_position + start
	p.size = anchored_size - start - end
