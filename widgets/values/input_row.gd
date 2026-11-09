extends Node

@onready var select: OptionButton

func _ready():
	select = $OptionButton
	NPANode._type_dropdown(select)
	
func _on_delete_pressed():
	get_parent().delete_port(self)

func _on_type_selected(index):
	get_parent().set_row_type(self, index)

func get_type():
	if !select:
		select = $OptionButton
	return select.selected
