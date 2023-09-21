extends Node2D

@onready var events = get_parent().get_node("Events")
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	print(events.get_child_count())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _get_position():
	return events.get_child(rng.randf_range(0, events.get_child_count() - 1))
