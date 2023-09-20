extends Node2D

@export_category("Parameters")
@export var spawn_probability := 50.0
@export var execution_time := 2
@export var cool_down := 5 # Min time between activations
@export var delay := 5 # Time required for event to try to init

var try_count := 0.0;
var isActive := false;
var isPlayer := false;

# Components
@onready var notification = $notification
@onready var trigger = $hint_trigger
@onready var hint = $hint
@onready var rng = RandomNumberGenerator.new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	try_count += 1 * delta;
	if !isActive && try_count >= delay: 
		start_event()
		try_count = 0

# Wait for player to use interact in order to complete event
func _input(event):
	if event.is_action_released("Interact") && isActive && isPlayer:
		complete_event()

# Try's to init the event using the given %
func start_event():
	if rng.randf_range(0.0, 1.0) > spawn_probability / 100:
		isActive = true
		show()

# Disable the event and wait x seconds before beeing available for activation
func complete_event():
	hide()
	await get_tree().create_timer(delay).timeout
	isActive = false
	try_count = 0

# Player detection
func _on_hint_trigger_body_entered(body):
	hint.show()
	isPlayer = true

func _on_hint_trigger_body_exited(body):
	hint.hide()
	isPlayer = false
