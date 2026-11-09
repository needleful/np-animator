class_name ConstantNode
extends NPANode

@onready var type_select:OptionButton= $Type/OptionButton

func _ready():
	super._ready()
	NPANode._type_dropdown(type_select)
	type_select.item_selected.connect(_on_type_changed)
	_on_type_changed(NPA.Type._int)

func _on_type_changed(index: int):
	for i in $Inputs.get_children():
		i.hide()
	match index:
		NPA.Type._int:
			$Inputs/SpinBox.show()
		NPA.Type._float, NPA.Type._String:
			var t:LineEdit = $Inputs/TextEdit
			t.show()
			NPA._typed_input(t, index)
		NPA.Type._Animation:
			var b: OptionButton = $Inputs/AnimationSelect
			b.show()
			animation_dropdown(b)
		NPA.Type._bool:
			$Inputs/BoolSelect.show()
		NPA.Type._Vector2:
			$Inputs/Vector1.show()
			$Inputs/Vector2.show()
		NPA.Type._Vector3:
			$Inputs/Vector1.show()
			$Inputs/Vector2.show()
			$Inputs/Vector3.show()
		_:
			push_error('Invalid type: ', index)
	set_output(1, index)
