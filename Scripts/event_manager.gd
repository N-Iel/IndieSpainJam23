extends Node2D

@export var max_events := 2
var active_events := 0
var events_failed := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(active_events)
