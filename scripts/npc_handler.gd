extends Node3D

@onready var anim_player = $"../Camera3D/AnimationPlayer"
@export var entity01 = load("res://entities/entity01.tscn")
@onready var gui_handler = $"../Camera3D/GUI"
var npc: CharacterBody3D = null
# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#gui_handler.accept_pressed.connect(_replyHandler)
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#entity01_spawn()
	#
#
#func entity01_spawn() -> void:
	#npc = entity01.instance()
	#anim_player.play("npc_move_to_counter")
	#await anim_player.animation_finished
#
###func _replyHandler() -> void:
	##anim_player.play("npc_move_success")
	##await anim_player.animation_finished
	##npc.destroy()
