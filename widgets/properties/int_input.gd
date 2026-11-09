@tool
class_name IntProperty
extends Control

signal value_changed(val: int)

@export var label_name := 'Amount':
	set(lm):
		label_name = lm
		_update_spinbox()
@export var range_max := 100:
	set(rm):
		range_max = rm
		_update_spinbox()
@export var range_min := 0:
	set(rm):
		range_min = rm
		_update_spinbox()

func _ready():
	$SpinBox.value_changed.connect(value_changed.emit)

func _update_spinbox():
	if not has_node('Label'):
		return
	$Label.text = label_name
	var s := $SpinBox
	s.max_value = range_max
	s.min_value = range_min
