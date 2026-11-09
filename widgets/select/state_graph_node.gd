class_name StateGraphNode
extends NPANode

signal name_changed(name: String, id: int)

var id: int

var default_name := '':
	set(sn):
		$StateName.placeholder_text = sn
	get():
		return $StateName.placeholder_text

var state_name: String:
	get():
		var sn :LineEdit = $StateName
		if sn.text:
			return sn.text
		else:
			return sn.placeholder_text

func _ready():
	super._ready()
	set_in_out(0, NPA.Type._Animation, NPA.Type._Animation)
	animation_dropdown($OptionButton)
	$StateName.text_changed.connect(name_changed.emit.bind(id))
