extends Node2D

@export var delay_random := 5.0
@export var delay_special := 10.0
@export var max_random := 9
@export var max_special := 3

@onready var available_npc = []
@onready var active_npc = []
@onready var disapeared_npc = []
@onready var event_manager = $"../Events"
@onready var random_locations_parent = $"../Locations"
@onready var random_prefab = load("res://Prefabs/npc.tscn")

var special_npc = []
var special_locations = []
var random_locations = []
var special_timer
var random_timer
var special_count := 0
var random_count := 0
var current_type := 0

# Trigger timers for npc spawn and initialice npc/location lists
func _ready():
	_get_available_npc()
	_get_random_locations()
	_get_special_locations()
	_set_timer(random_timer, _spawn_random_npc, delay_random)
	_set_timer(special_timer, _spawn_special_npc, delay_special)


# Get random locations from the parentNode
func _get_random_locations():
	for location in random_locations_parent.get_children():
		random_locations.push_front(location)


# Get special locations from the event_manager
func _get_special_locations():
	for location in event_manager.get_children():
		special_locations.push_front(location)


# Add special available npcs to the available list
func _get_available_npc():
	special_npc = get_children()
	if special_npc.size() > 0:
		for npc in special_npc:
			if npc.available:
				available_npc.push_front(npc)


func _spawn_random_npc():
	if (random_count >= max_random): return
	
	_spawn_random()
	random_count += 1

# Spawn random npcs
func _spawn_special_npc():
	if (special_count >= max_special): return
	_spawn_special()
	special_count += 1


# Generate a new random npc and set the route
func _spawn_random():
	var npc = random_prefab.instantiate()
	add_child(npc)
	_set_random_route(npc)


# Get an available npc from the list and update it's target
func _spawn_special():
	_set_special_route(available_npc.filter(func(npc): return npc.type == 1).pick_random())


# Get an origin and target for the random npc
func _set_random_route(npc):
	npc._set_origin(random_locations.pick_random())
	var target = random_locations.pick_random()
	
	while target == npc.origin:
		target = random_locations.pick_random()

	active_npc.push_back(npc)
	npc._set_active(target)


# Update origin and target from special npcs
func _set_special_route(npc):
	if npc == null : return
		
	if npc.origin == null:
		npc._set_origin(random_locations.pick_random())
		npc.show()
	
	var target = _get_special_location()
	
	if target == null: 
		print("No available locations")
		return
	
	available_npc.erase(npc)
	active_npc.push_back(npc)
	npc._set_active(target)


# Filter available locations for special npcs
func _get_special_location():
	var available_locations = special_locations.filter(func(location): return (location.has_method("_is_available") && location.available == true))
	return available_locations.pick_random()


# Update the list of npcs on disapear
func _on_npc_disapear(npc):
	active_npc.erase(npc)
	disapeared_npc.push_front(npc)


# Update npc state
func _enable_npc(npc):
	active_npc.erase(npc)
	available_npc.push_front(npc)


# Init timer for execution
func _set_timer(timer, function, time):
	timer = Timer.new()
	add_child(timer)
	
	timer.timeout.connect(function)
	timer.start(time)
