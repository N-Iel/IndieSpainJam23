extends Node2D

enum Type {Common = 0, Rare = 1, Unique = 2}

@export var execution_time := 5.0
@export var npc_required := 0
@export var available := true
@export var max_npc := 1
@export var delay := 5.0
@export var type : Type


@onready var event_manager = get_parent()
@onready var original_type = type
@onready var minigame := $minigame
@onready var hint := $hint_trigger

var npc_list := []
var player_inside := false
var minigame_active := false
var timer

func _input(event):
	if event.is_action_released("Interact") && player_inside && !minigame_active:
#		if minigame != null:
#			#minigame?.start()
#			print("Minigame started")
#		else:
		_complete_event(true)


# Resolve the event with the given result
func _complete_event(success := false):
	if success:
		on_event_success()
	else:
		on_event_fail()
		
	hide()
	_set_timer(_disable_event, delay)


# On execution time runs out, complete as fail
func on_timeout():
	if (minigame_active): return
	_complete_event(false)


# Execute action on event faild
func on_event_fail():
	# Update active event list
	event_manager._disable_event(self)
	
	# Check for posible disaperances
	if npc_required <= 0: return
	
	var npc = npc_list.pick_random()
	npc._on_disapear()
	npc_list.erase(npc)


# Execute action on event success
func on_event_success():
	pass


# Disable the event at the end of execution
func _disable_event():
	
	# Make event available again
	event_manager._enable_event(self)
	type = original_type

func _enable_event():	
	show()
	_set_timer(_complete_event, execution_time)

# Init timer for event execution
func _set_timer(method, time):
	timer = Timer.new()
	timer.set_one_shot(true)
	add_child(timer)
		
	timer.timeout.connect(method)
	timer.start(time)


# Return if the event is available for activation
func _is_available():
	return available \
			&& !player_inside


# Player detection
func _on_hint_trigger_body_entered(body):
	if body.name == "Player":
		hint.show()
		player_inside = true
	elif body.get_parent().name == "Npc":
		npc_list.push_front(body)


func _on_hint_trigger_body_exited(body):
	if body.name == "Player":
		hint.hide()
		player_inside = false
	elif body.get_parent().name == "Npc":
		npc_list.erase(body)
