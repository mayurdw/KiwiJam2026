extends Button
class_name Element

enum ElementState {
	HIDDEN,
	START,
	ACTIVE,
	SELECTED,
}

signal button_selected(id: String)

var elementState : ElementState = ElementState.HIDDEN
var id: String = ""

@onready var label: Label = $MarginContainer/VBoxContainer/Label
@onready var button_pin: TextureRect = $MarginContainer/VBoxContainer/ButtonPin
@onready var click: AudioStreamPlayer2D = $Click
@onready var error: AudioStreamPlayer2D = $Error

func _ready() -> void:
	setButtonState(elementState)
	label.text = id

func setButtonState(state: ElementState):
	match state:
		ElementState.HIDDEN:
			button_pin.visible = false
			label.visible = false
		ElementState.START:
			button_pin.visible = true
			label.visible = true
		ElementState.ACTIVE:
			button_pin.visible = true
			label.visible = true
		ElementState.SELECTED:
			play_click()
			button_pressed = true
			button_selected.emit(id)
	
	elementState = state


func _on_toggled(_toggled_on: bool) -> void:
	match elementState:
		ElementState.HIDDEN:
			button_pressed = false
			play_error()
		ElementState.START, ElementState.ACTIVE:
			setButtonState(ElementState.SELECTED)
		ElementState.SELECTED:
			button_pressed = true

func play_error() -> void:
	error.pitch_scale = randf_range(0.8, 1.2)
	error.play()

func play_click() -> void:
	click.pitch_scale = randf_range(0.8, 1.2)
	click.play()

func drop_element() -> void:
	visible = false
	call_deferred("queue_free")
