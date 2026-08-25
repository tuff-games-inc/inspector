extends Control

var day: int = 0
@onready var day_counter = $CanvasLayer/Day
@onready var anim_player = $"../AnimationPlayer"
@onready var board = $"../GuiNoticeBoard"
# Called when the node enters the scene tree for the first time.
signal show_notice_board()
func _ready() -> void:
	day_counter.text = "Day 0"
	board.show_normal.connect(show_normal)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	print("day ended")
	day += 1
	var day_string = "Day %s"
	day_counter.text = day_string % day
	pass # Replace with function body.

func hide_normal() -> void:
	$CanvasLayer.visible = false
	$CanvasLayer/Accept.visible = false
	$CanvasLayer/Button.visible = false
	$CanvasLayer/Day.visible = false
	$CanvasLayer/Deny.visible = false

func show_normal() -> void:
	$CanvasLayer.visible = true
	$CanvasLayer/Accept.visible = true
	$CanvasLayer/Button.visible = true
	$CanvasLayer/Day.visible = true
	$CanvasLayer/Deny.visible = true

func _on_button_pressed() -> void:
	print("go to board")
	hide_normal()
	anim_player.play("camera_tilt_to_board")
	await anim_player.animation_finished
	show_notice_board.emit()
