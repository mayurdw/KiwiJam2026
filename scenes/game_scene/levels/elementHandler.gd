extends GridContainer
class_name ElementHandler

@export var cardScene: PackedScene = preload("res://scenes/game_scene/levels/element.tscn")

var indices : Array[int] = []

func _ready() -> void:
	var maxValue = range(0, columns * columns)
	var ids = maxValue.duplicate(true)

	# Instantiate column x column cards and add to container
	for i in maxValue:
		var id = ids.pick_random()
		ids.remove_at(ids.find(id))

		var instance : Element = cardScene.instantiate()
			
		if id == 0:
			instance.elementState = Element.ElementState.START

		instance.id = "%d" % (id + 1)
		indices.append(id + 1)
		instance.button_selected.connect(_on_button_selected)
		add_child(instance)

func _on_button_selected(id: String) -> void:
	print("Button selected on id = %s" % id)
	var id_int: int = id.to_int()

	if id_int in range(1, (columns * columns) + 1):
		var index = indices.find(id_int + 1)
		var child_element : Element = get_children().get(index)

		child_element.setButtonState(Element.ElementState.ACTIVE)
