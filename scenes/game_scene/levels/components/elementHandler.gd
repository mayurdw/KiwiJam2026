extends GridContainer
class_name ElementHandler

@export var cardScene: PackedScene = preload("res://scenes/game_scene/levels/components/element.tscn")

var indices : Array[int] = []

signal button_pressed(current_value: int)
signal button_removed(removed_value: int, removed_position: Vector2)

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
	var id_int: int = id.to_int()

	if id_int in range(1, (columns * columns) + 1):
		var next_id = indices.find(id_int + 1)
		var current_id = indices.find(id_int)
		var current_positon: Vector2 = get_children().get(current_id).button_pin.global_position

		if not next_id < 0:
			var child_element : Element = get_children().get(next_id)
			child_element.setButtonState(Element.ElementState.ACTIVE)

		button_pressed.emit(id_int, current_positon)
		print("Emitting signal with id = [%d] and current_positon = [%f, %f]" % [ id_int, current_positon.x, current_positon.y])

func clear_grid() -> void:
	var child_count : int = get_child_count()
	for id : Element in get_children():
		if child_count > 1:
			button_removed.emit(child_count)
			child_count -= 1
			id.queue_free()
			if columns > child_count:
				columns = child_count
			await get_tree().create_timer(0.3).timeout
