extends PanelContainer

func _ready():
	$row/properties/animation.clear()
	for a in NPA.animations:
		$row/properties/animation.add_item(a)

func _on_delete_pressed():
	get_parent().delete_item(self)
