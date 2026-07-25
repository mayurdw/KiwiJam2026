extends Node

signal level_lost
signal level_won(level_path : String)
@warning_ignore("unused_signal")
signal level_changed(level_path : String)

## Optional path to the next level if using an open world level system.
@export_file("*.tscn") var next_level_path : String

@export var tasks: Array[String] = []
@export var aim: String = ""
@export var index: int = 0

@onready var element_handler: ElementHandler = $MarginContainer/HBoxContainer/VBoxContainer/MarginContainer/ElementHandler
@onready var goal: Label = $"MarginContainer/HBoxContainer/VBoxContainer2/PanelContainer/MarginContainer/Goal Container/Goal"
@onready var next_task: Label = $"MarginContainer/HBoxContainer/VBoxContainer2/MarginContainer/VBoxContainer/PanelContainer3/MarginContainer/Current Container/Next Task"
@onready var current_task: Label = $"MarginContainer/HBoxContainer/VBoxContainer2/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/Current Container/Current Task"
@onready var thread: Line2D = $Thread

var level_state : LevelState

func _on_lose_button_pressed() -> void:
	level_lost.emit()

func _on_win_button_pressed() -> void:
	level_won.emit(next_level_path)

func open_tutorials() -> void:
	%TutorialManager.open_tutorials()
	level_state.tutorial_read = true
	GlobalState.save()

func _ready() -> void:
	level_state = GameState.get_level_state(scene_file_path)
	%BackgroundColor.color = level_state.color
	if not level_state.tutorial_read:
		open_tutorials()
	element_handler.columns = (int)(sqrt(tasks.size()))
	goal.text = aim
	current_task.text = aim
	next_task.text = aim

func _on_tutorial_button_pressed() -> void:
	open_tutorials()

func _on_grid_container_button_pressed(current_value: int, current_position: Vector2) -> void:
	print("Got new value = %d, current_position = [%f, %f]" % [current_value, current_position.x, current_position.y])
	if current_value in range(1, tasks.size()):
		index += 1
		current_task.text = "%d. %s" % [ index, tasks[index - 1] ]
		next_task.text = "%d. %s" % [ index + 1, tasks[index] ]
	
	var points: PackedVector2Array = thread.points.duplicate()

	if not current_position in thread.points:
		points.append(current_position)

	thread.points = points
