extends Control

@onready var main_gui = $"../GUI"
@onready var anim_player = $"../AnimationPlayer"
@onready var right_booth_door = $"../../Building/RightBoothDoor"
@onready var right_booth_door_2 = $"../../Building/RightBoothDoor2"
@export var open_door_texture = load("res://assets/door_open.png")
@export var normal_door_texture = load("res://assets/door_normal.png")

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
	anim_player.play("cutscene")
	await get_tree().create_timer(0.25).timeout
	right_booth_door.texture = open_door_texture
	right_booth_door_2.texture = open_door_texture	
	await anim_player.animation_finished
	right_booth_door.texture = normal_door_texture
	right_booth_door_2.texture = normal_door_texture
	main_gui.show_normal()
