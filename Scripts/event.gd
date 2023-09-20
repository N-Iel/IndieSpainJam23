extends Node2D

@export_category("Parameters")
@export var spawn_probability := 50.0
@export var execution_time := 2
@export var cool_down := 5 # Min time between activations
@export var delay := 5 # Time required for event to try to init

var try_count := 0.0;
var isActive := false;

# Components
@onready var notification = $notification
@onready var trigger = $hint_trigger
@onready var rng = RandomNumberGenerator.new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	try_count += 1 * delta;
	if !isActive && try_count >= delay: 
		start_event()
		try_count = 0

# Try's to init the event using the given %
func start_event():
	print_debug("Trying to start Event")
	if rng.randf_range(0.0, 1.0) > spawn_probability / 100:
		print_debug("Event initiated")
		isActive = true
		show()
		


