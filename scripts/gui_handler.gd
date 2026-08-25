extends Node2D

var day: int = 0
@onready var day_counter = $Day
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	day_counter.text = "Day 0"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	print("day ended")
	day += 1
	var day_string = "Day %s"
	day_counter.text = day_string % day
	pass # Replace with function body.
