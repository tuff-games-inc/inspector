extends Control

@onready var main_gui = $"../GUI"
signal play_pressed()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_gui.hide_normal()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass



func _on_play_pressed() -> void:
	visible = false
	play_pressed.emit()
	main_gui.show_normal()
