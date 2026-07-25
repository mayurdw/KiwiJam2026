extends Button
class_name Element

enum ElementState {
	HIDDEN,
	START,
	ACTIVE,
	SELECTED,
	COMPLETED
}

signal button_selected(id: String)

var elementState : ElementState = ElementState.HIDDEN
var id: String = ""

@onready var label: Label = $MarginContainer/VBoxContainer/Label
@onready var button_pin: TextureRect = $MarginContainer/VBoxContainer/ButtonPin

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
			button_pressed = true
			button_selected.emit(id)
	
	elementState = state


func _on_toggled(_toggled_on: bool) -> void:
	match elementState:
		ElementState.COMPLETED:
			return
		ElementState.HIDDEN:
			button_pressed = false
		ElementState.START, ElementState.ACTIVE:
			setButtonState(ElementState.SELECTED)
		ElementState.SELECTED:
			setButtonState(ElementState.ACTIVE if id != "0" else ElementState.START)
