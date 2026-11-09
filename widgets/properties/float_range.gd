@tool
class_name FloatRangeProperty
extends Control

signal value_changed(val: float)

@export var label_name := 'Amount':
	set(lm):
		label_name = lm
		_update_slider()
@export_group('Range', 'range_')
@export var range_min := 0.0:
	set(rm):
		range_min = rm
		_update_slider()
@export var range_max := 1.0:
	set(rm):
		range_max = rm
		_update_slider()
@export var range_increment := 0.01:
	set(ri):
		range_increment = ri
		_update_slider()
@export var value := 0.0:
	set(val):
		value = val
		_update_slider()

func _ready():
	value = $Slider.value
	_update_slider()
	$Slider.value_changed.connect(_on_value_changed)

func _update_slider():
	if not has_node('Slider'):
		return
	$HBoxContainer/Label.text = label_name
	var s: Slider = $Slider
	s.max_value = range_max
	s.min_value = range_min
	s.value = value

func _on_value_changed(val: float):
	value = val
	$HBoxContainer/Label2.text = val
	value_changed.emit(val)
