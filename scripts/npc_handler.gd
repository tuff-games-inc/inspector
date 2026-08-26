extends Node3D

@onready var anim_player = $"../Camera3D/AnimationPlayer"
@export var entity01 = load("res://entities/entity01.tscn")
@onready var gui_handler = $"../Camera3D/GUI"
var isSpawned = false
var isMoving = false
var npc: CharacterBody3D = null

signal change_score(direction: bool)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gui_handler.reply_pressed.connect(_replyHandler)
	gui_handler.next_pressed.connect(_spawnHandler)

#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	
	
#

func _spawnHandler() -> void:
	if !npc:
		isSpawned = true
		isMoving = true
		entity01_spawn()
	else:
		print("npc already spawned")

func entity01_spawn() -> void:
	npc = entity01.instantiate() as CharacterBody3D
	add_child(npc)
	anim_player.play("npc_move_to_counter")
	await anim_player.animation_finished
	isMoving = false
#
func _replyHandler(outcome: bool) -> void:
	if !isMoving && isSpawned:
		var isAllowedIn = npc.IsAllowedIn
		if isAllowedIn && outcome:
			print("succesfully let in")
			anim_player.play("npc_move_success")
			await anim_player.animation_finished
			change_score.emit(true)
		elif isAllowedIn && !outcome:
			print("incorrectly denied")
			anim_player.play("npc_deny")
			await anim_player.animation_finished
			change_score.emit(false)
		elif !isAllowedIn && !outcome:
			print("succesfully denied")
			anim_player.play("npc_deny")
			await anim_player.animation_finished
			change_score.emit(true)
		elif !isAllowedIn && outcome:
			print("incorrectly accepted")
			anim_player.play("npc_move_success")
			await anim_player.animation_finished
			change_score.emit(false)
		npc.queue_free()
		isSpawned = false
	else:
		print("moving")
