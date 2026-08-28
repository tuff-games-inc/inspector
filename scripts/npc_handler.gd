extends Node3D

@onready var anim_player = $"../Camera3D/AnimationPlayer"
@export var entity01:PackedScene  = load("res://entities/entity01.tscn")
@export var entity02:PackedScene = load("res://entities/entity02.tscn")
@export var entity03:PackedScene = load("res://entities/entity03.tscn")
@export var open_door_texture = load("res://assets/door_open.png")
@export var normal_door_texture = load("res://assets/door_normal.png")
@export var deny_door_texture = load("res://assets/door_wrong_way.png")
@onready var gui_handler = $"../Camera3D/GUI"
@onready var door_deny = $"../Building/DoorDeny"
@onready var door_accept = $"../Building/DoorAccept"
@onready var next_light_mesh: MeshInstance3D = $"../Counter/NextLight/MeshInstance3D/MeshInstance3D"
@onready var next_light: StandardMaterial3D = next_light_mesh.get_active_material(0)
@onready var right_booth_door = $"../Building/RightBoothDoor"
@onready var killer = $killer
var isKiller = false
var isSpawned = false
var isMoving = false
var npc: CharacterBody3D = null
var possible_entities: Array[PackedScene] = [entity01, entity02, entity03]

signal hide_gui()
signal change_score(direction: bool)
signal game_over()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	killer.visible = false
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
		next_light.emission_enabled = false
		entity_spawn()
	else:
		print("npc already spawned")

func entity_spawn() -> void:
	var random_entity: PackedScene = possible_entities.pick_random()
	if random_entity == entity03:
		isKiller = true
	npc = random_entity.instantiate() as CharacterBody3D
	add_child(npc)
	door_deny.texture = open_door_texture
	anim_player.play("npc_move_to_counter")
	await anim_player.animation_finished
	door_deny.texture = deny_door_texture
	isMoving = false

func _replyHandler(outcome: bool) -> void:
	if !isSpawned:
		print("npc not spawnmed")
	elif !isMoving:
		var isAllowedIn = npc.IsAllowedIn
		if isAllowedIn && outcome:
			print("succesfully let in")
			isSpawned = false
			door_accept.texture = open_door_texture
			anim_player.play("npc_move_success")
			await anim_player.animation_finished
			door_accept.texture = normal_door_texture
			next_light.emission_enabled = true
			change_score.emit(true)
		elif isAllowedIn && !outcome:
			print("incorrectly denied")
			isSpawned = false
			door_deny.texture = open_door_texture
			anim_player.play("npc_deny")
			await anim_player.animation_finished
			door_deny.texture = deny_door_texture
			next_light.emission_enabled = true
			change_score.emit(false)
		elif !isAllowedIn && !outcome:
			print("succesfully denied")
			isSpawned = false
			door_deny.texture = open_door_texture
			anim_player.play("npc_deny")
			await anim_player.animation_finished
			door_deny.texture = deny_door_texture
			next_light.emission_enabled = true
			change_score.emit(true)
		elif !isAllowedIn && outcome:
			print("incorrectly accepted")
			isSpawned = false
			if isKiller:
				anim_player.play("npc_move_success")
				door_accept.texture = open_door_texture
				await anim_player.animation_finished
				door_accept.texture = normal_door_texture
				next_light.emission_enabled = true
				npc.visible = false
				kill_player()
				isKiller = false
			else:
				anim_player.play("npc_move_success")
				door_accept.texture = open_door_texture
				await anim_player.animation_finished
				door_accept.texture = normal_door_texture
				next_light.emission_enabled = true
				change_score.emit(false)
		npc.queue_free()
		npc = null
		isSpawned = false
	else:
		print("npc is still moving")

func kill_player() -> void:
	await get_tree().create_timer(3.0).timeout
	right_booth_door.texture = open_door_texture
	killer.visible = true
	hide_gui.emit()
	anim_player.play("npc_kills_you")
	await anim_player.animation_finished
	game_over.emit()
