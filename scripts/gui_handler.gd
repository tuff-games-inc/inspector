extends Control

@export var day: int = 0
@export var points: int = 0
@onready var day_counter = $CanvasLayer/Day
@onready var anim_tilt_to_board = $"../AnimTiltToBoard"
@onready var board = $"../GuiNoticeBoard"
@onready var npc_handler = $"../../NPC"
@onready var start_screen = $"../StartScreen"
var points_string = "Points: %s"
# Called when the node enters the scene tree for the first time.
signal show_notice_board()
signal reply_pressed(outcome: bool)
signal next_pressed()
func _ready() -> void:
	day_counter.text = "Day 0"
	$CanvasLayer/Points.text = points_string % points
	$CanvasLayer/GameOver.visible = false
	board.show_normal.connect(show_normal)
	npc_handler.change_score.connect(change_score)
	npc_handler.hide_gui.connect(hide_normal)
	npc_handler.game_over.connect(_game_over)
	start_screen.play_pressed.connect(start)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
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
	$CanvasLayer/Information.visible = false
	$CanvasLayer/Day.visible = false
	$CanvasLayer/Deny.visible = false
	$CanvasLayer/Next.visible = false
	$CanvasLayer/Points.visible = false
	$CanvasLayer/GameOver.visible = false
	$CanvasLayer/RestartButton.visible = false
	$CanvasLayer/RestartButton.disabled = true

func show_normal() -> void:
	$CanvasLayer.visible = true
	$CanvasLayer/Accept.visible = true
	$CanvasLayer/Information.visible = true
	$CanvasLayer/Day.visible = true
	$CanvasLayer/Deny.visible = true
	$CanvasLayer/Next.visible = true
	$CanvasLayer/Points.visible = true

func _on_information_pressed() -> void:
	print("go to board")
	hide_normal()
	anim_tilt_to_board.play("camera_tilt_to_board")
	await anim_tilt_to_board.animation_finished
	show_notice_board.emit()


func _on_accept_pressed() -> void:
	reply_pressed.emit(true) # true for accept
	


func _on_next_pressed() -> void:
	next_pressed.emit()


func _on_deny_pressed() -> void:
	reply_pressed.emit(false) # false for deny

# true = increment, false = decrement
func change_score(direction) -> void:
	if direction:
		points += 1
		print(points)
		$CanvasLayer/Points.text = points_string % points
	else:
		if !(points == 0):
			points -= 1
			print(points)
			$CanvasLayer/Points.text = points_string % points
		else:
			points -= 1
			_game_over()

func _game_over() -> void:
	print("game over")
	var gameovertext = "Game Over!\nScore: %s"
	var gamelost = "Your score\ndropped\nbelow 0!"
	hide_normal()
	if points <= 0:
		$CanvasLayer/GameOver.text = gamelost
		$CanvasLayer.visible = true
		$CanvasLayer/GameOver.visible = true
	else:
		$CanvasLayer/GameOver.text = gameovertext % points
		$CanvasLayer.visible = true
		$CanvasLayer/GameOver.visible = true
	$CanvasLayer/RestartButton.visible = true
	$CanvasLayer/RestartButton.disabled = false

func start() -> void:
	$CanvasLayer/Timer.start()


func _on_restart_button_pressed() -> void:
	print("resetting scene")
	get_tree().reload_current_scene()
