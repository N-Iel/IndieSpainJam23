extends Node2D

signal event_activated
signal event_resolved

@export_category("Parameters")
@export_range(0, 100) var spawn_probability := 50.0
@export var npc_requirement := 0
@export var execution_time := 2
@export var cool_down := 5 # Min time between activations
@export var delay := 5 # Time required for event to try to init

var npcs = []
var try_count := 0.0
var active_count := 0.0
var is_active := false
var is_player := false

# Components
@onready var notification = $notification
#@onready var minigame = $minigame
@onready var trigger = $hint_trigger
@onready var hint = $hint_trigger/hint
@onready var rng = RandomNumberGenerator.new()
@onready var event_manager = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	try_count += 1 * delta;
	
	check_conditions()
	
	if is_active : active_countdown(delta)


# Wait for player to use interact in order to complete event
func _input(event):
	if event.is_action_released("Interact") && is_active && is_player:
#		if minigame != null:
#			minigame.start()
#		else:
			complete_event(true)


func check_conditions():	
	if npcs.size() >= npc_requirement \
			&& !is_active && !is_player \
			&& try_count >= delay \
			&& event_manager.active_events < event_manager.max_events:
		start_event()
	elif try_count >= delay:
		try_count = 0


# Try's to init the event using the given %
func start_event():
	try_count = 0
	
	if rng.randf_range(0.0, 1.0) > spawn_probability / 100:
		event_manager.active_events += 1
		is_active = true
		show()


# Disable the event and wait x seconds before beeing available for activation
func complete_event(success):
	
	if !success : 
		event_manager.events_failed += 1
	
	hide()
	event_manager.active_events -= 1
	
	await get_tree().create_timer(delay).timeout
	
	is_active = false
	try_count = 0


func active_countdown(delta):
	active_count += 1 * delta;
	if active_count >= execution_time:
		complete_event(false)


# Player detection
func _on_hint_trigger_body_entered(body):
	if body.name == "Player":
		hint.show()
		is_player = true
	elif body.get_parent().name == "npc":
		npcs.push_front(body)


func _on_hint_trigger_body_exited(body):
	if body.name == "Player":
		hint.hide()
		is_player = false
	elif body.get_parent().name == "NPC":
		npcs.erase(body)
