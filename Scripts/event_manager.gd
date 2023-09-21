extends Node2D

enum Type {Common = 0, Rare = 1, Unique = 2}

var event_list = [] # similar to get children probably optional
var active_events = [] # list of active events
var available_events = [] # list of events ready to get active

@export var event_limit := 2
@export var spawn_rate := 5.0
@export var time_between_events := 5.0

var timer
var active := true
var active_minigame := false

func _ready():
	event_list = get_children()
	_set_available_events()
	_set_timer()


# Activate a new event
func _active_event():
	
	# Check if can activate events
	if (active_minigame || !active || active_events.size() >= event_limit):
		print("Unable to active events")
		return
	
	# Get the rarity of the next event
	var type
	var result = randf_range(0,1)
	
	# Select a event based on rarity
	if (result <= 0.3):
		type = Type.Unique
	elif (result <= 0.5):
		type = Type.Rare
	elif (result <= 0.8):
		type = Type.Common
		
	_get_event(type)


# get a specific event from the available list using a type
func _get_event(type):
	
	# Look for available events of specified type
	if (available_events.size() <= 0 || !available_events.any(func(event): return event.type == type && event._is_available())):
		return
	
	# Get a random event of the choosed type
	var event = available_events.filter(func(event): return event.type == type && event._is_available()).pick_random()
	
	# Update the lists
	available_events.erase(event)
	active_events.push_front(event)
	event._enable_event()

# Update the state of the given event
func _disable_event(event):
	active_events.erase(event)

# Update the state of the given event
func _enable_event(event):
	available_events.push_back(event)


# Updates the rarity of the given event with a given rarity
func _update_event_rarity(event, rarity):
	event.rarity = rarity


# Select available events from the list
func _set_available_events():
	# Look for available events
	if (event_list.size() <= 0 || !event_list.any(func(event): return event.available == true)):
		print("No events availables on the list")
		return
	
	# Disable event activation while updating list
	active = false
	available_events = []
	
	# If the event is enabled 
	available_events = event_list.filter(func(event): return event.available == true)
	
	# If there are enought events the activation gets enabled
	if (available_events.size() > 0):
		active = true


# Init timer for event execution
func _set_timer():
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_active_event)
	timer.start(spawn_rate)
