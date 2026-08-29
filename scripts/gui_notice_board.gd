extends Control

@onready var main_gui = $"../GUI"
@onready var anim_tilt_main = $"../AnimTiltToMain"
@onready var npc_handler = $"../../NPC"

@export var entity01_mugshot = load("res://assets/entity01_mugshot.png")
@export var entity02_mugshot = load("res://assets/entity02_mugshot.png")
@export var entity03_mugshot = load("res://assets/entity03_mugshot.png")
@export var entity04_mugshot = load("res://assets/entity04_mugshot.png")
@export var entity05_mugshot = load("res://assets/entity05_mugshot.png")
@export var entity06_mugshot = load("res://assets/entity06_mugshot.png")

signal show_normal()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_hide_board()
	main_gui.show_notice_board.connect(_show_board)
	npc_handler.update_board.connect(_update_board)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _show_board() -> void:
	$CanvasLayer/Back.visible = true
	$CanvasLayer/TextureRect.visible = true
	$CanvasLayer.visible = true
	$CanvasLayer/Name.visible = true
	$CanvasLayer/DOB.visible = true
	$"CanvasLayer/Entry permit".visible = true
	$CanvasLayer/Occupation.visible = true

func _hide_board() -> void:
	$CanvasLayer/Back.visible = false
	$CanvasLayer/TextureRect.visible = false
	$CanvasLayer.visible = false
	$CanvasLayer/Name.visible = false
	$CanvasLayer/DOB.visible = false
	$"CanvasLayer/Entry permit".visible = false
	$CanvasLayer/Occupation.visible = false

func _on_back_pressed() -> void:
	print("go to normal pos")
	anim_tilt_main.play("camera_tilt_to_main")
	_hide_board()
	await anim_tilt_main.animation_finished
	print("animation finished")
	show_normal.emit()
	
func _update_board(name, dob, permit, occupation, id) -> void:
	$CanvasLayer/Name.text = name
	$CanvasLayer/DOB.text = dob
	if permit:
		$"CanvasLayer/Entry permit".text = "Entry Permit: VALID"
	else:
		$"CanvasLayer/Entry permit".text = "Entry Permit: INVALID"
	$CanvasLayer/Occupation.text = occupation
	if id == 1:
		$"CanvasLayer/Mugshot".texture = entity01_mugshot
	elif id == 2:
		$"CanvasLayer/Mugshot".texture = entity02_mugshot
	elif id == 3:
		$"CanvasLayer/Mugshot".texture = entity03_mugshot
	elif id == 4:
		$"CanvasLayer/Mugshot".texture = entity04_mugshot
	elif id == 5:
		$"CanvasLayer/Mugshot".texture = entity05_mugshot
	elif id == 6:
		$"CanvasLayer/Mugshot".texture = entity06_mugshot
	print("updated notice board") 
