extends Control

@onready var main_gui = $"../GUI"
@onready var anim_cutscene = $"../StartCutscene"
@onready var startcam = $"../../Camera3D2"
@onready var maincam = $"../../Camera3D"
@onready var fade_rect = $CanvasLayer/ColorRect2
@onready var tween
@onready var right_booth_door = $"../../Building/RightBoothDoor"
@onready var right_booth_door_2 = $"../../Building/RightBoothDoor2"
@export var open_door_texture = load("res://assets/door_open.png")
@export var normal_door_texture = load("res://assets/door_normal.png")
@onready var next_light_mesh: MeshInstance3D = $"../../Counter/NextLight/MeshInstance3D/MeshInstance3D"
@onready var next_light: StandardMaterial3D = next_light_mesh.get_active_material(0)

signal play_pressed()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_gui.hide_normal()
	startcam.current = true
	await get_tree().create_timer(1.0).timeout
	fade_rect.modulate.a = 1.0
	tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, 1.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_play_pressed() -> void:
	fade_rect.modulate.a = 0.0
	tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, 2.0)
	await tween.finished
	fade_rect.modulate.a = 1.0
	$CanvasLayer/ColorRect.visible = false
	$CanvasLayer/Label.visible = false
	$CanvasLayer/Play.visible = false
	startcam.current = false
	maincam.current = true
	anim_cutscene.play("prepcam")
	tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, 1.0)
	play_pressed.emit()
	anim_cutscene.play("cutscene")
	await tween.finished
	$CanvasLayer.visible = false
	await anim_cutscene.animation_finished
	await get_tree().create_timer(0.5).timeout
	next_light.emission_enabled = true
	main_gui.show_normal()
