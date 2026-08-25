extends Control

@onready var main_gui = $"../GUI"
@onready var anim_player = $"../AnimationPlayer"

signal show_normal()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_hide_board()
	main_gui.show_notice_board.connect(_show_board)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _show_board() -> void:
	$CanvasLayer/Back.visible = true
	$CanvasLayer/TextureRect.visible = true
	$CanvasLayer.visible = true

func _hide_board() -> void:
	$CanvasLayer/Back.visible = false
	$CanvasLayer/TextureRect.visible = false
	$CanvasLayer.visible = false

func _on_back_pressed() -> void:
	print("go to normal pos")
	anim_player.play("camera_tilt_to_main")
	_hide_board()
	await anim_player.animation_finished
	print("animation finished")
	show_normal.emit()
