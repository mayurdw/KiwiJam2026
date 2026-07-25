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
@export var remaining_time_sec : int = 60

@onready var element_handler: ElementHandler = $VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/MarginContainer/ElementHandler
@onready var goal: Label = $"VBoxContainer/MarginContainer/HBoxContainer/MarginContainer2/Task Sidebar/Goal Container/MarginContainer/VBoxContainer3/Goal"
@onready var current_task: Label = $"VBoxContainer/MarginContainer/HBoxContainer/MarginContainer2/Task Sidebar/MarginContainer/Tasks Container/PanelContainer2/MarginContainer/VBoxContainer4/Current Task"
@onready var next_task: Label = $"VBoxContainer/MarginContainer/HBoxContainer/MarginContainer2/Task Sidebar/MarginContainer/Tasks Container/PanelContainer3/MarginContainer/VBoxContainer5/Next Task"
@onready var label: Label = $VBoxContainer/MarginContainer2/HBoxContainer/Label
@onready var progress_bar: ProgressBar = $VBoxContainer/MarginContainer2/HBoxContainer/ProgressBar
@onready var thread: Line2D = $Thread
@onready var timer: Timer = $Timer

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
	if not level_state.tutorial_read:
		open_tutorials()
	element_handler.columns = (int)(sqrt(tasks.size()))
	goal.text = aim
	current_task.text = aim
	next_task.text = aim
	timer.start()
	label.text = "%d:%d" % [ remaining_time_sec / 60, remaining_time_sec % 60]
	progress_bar.max_value = remaining_time_sec + level_state.carry_over_time
	progress_bar.value = progress_bar.max_value

func _complete_level() -> void:
	timer.stop()
	element_handler.clear_grid()
	level_state.carry_over_time = remaining_time_sec
	level_won.emit()

func _on_grid_container_button_pressed(current_value: int, current_position: Vector2) -> void:
	print("Got new value = %d, current_position = [%f, %f]" % [current_value, current_position.x, current_position.y])

	if current_value == tasks.size():
		_complete_level()
	elif current_value in range(1, tasks.size()):
		index += 1
		current_task.text = "%d. %s" % [ index, tasks[index - 1] ]
		next_task.text = "%d. %s" % [ index + 1, tasks[index] ]
	_add_points(current_position)
	
func _add_points(new_point: Vector2):
	if thread.points.size() > 0:
		create_tween().tween_method(thread.add_point, thread.points.get(thread.points.size() - 1), new_point, 0.2)
	else:
		thread.add_point(new_point)

func _on_timer_timeout() -> void:
	remaining_time_sec -= 1
	if remaining_time_sec <= 0:
		level_lost.emit()
	else:
		print("Time Remaining %d" % remaining_time_sec)
		progress_bar.value = remaining_time_sec
		label.text = "0:%d" % remaining_time_sec
		timer.start()


func _on_element_handler_button_removed(removed_value: int) -> void:
	print("Got value to remove %d" % removed_value)
	
	thread.clear_points()
