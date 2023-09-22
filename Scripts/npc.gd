extends CharacterBody2D

@export_subgroup("Properties")
@export var movement_speed: float = 200.0
@export var available := true
@export var type := 0

var target
var origin
var direction 
var disapeared := false
var active := false
var time_on_location := 10
var on_active_event := false

@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var sprite = $Sprite2D
@onready var manager = get_parent()

func _ready():
	nav.path_desired_distance = 4.0
	nav.target_desired_distance = 4.0

func _process(delta):
	
	if !active || disapeared || on_active_event: return
	
	_handle_controls()
	_handle_position(delta)
	
	move_and_slide()


func _handle_controls():
	# Movement
	if position.distance_to(target) > 2:
		direction = nav.get_next_path_position() - global_transform.origin
	else:
		_target_reached()
		direction = Vector2.ZERO
	


func _handle_position(delta):
	velocity = movement_speed * direction.normalized()
	
	if velocity.length() == 0: return
	sprite.flip_h = velocity.x > 0


func _set_active(_target):
	target = _target.global_transform.origin
	nav.set_target_position(target)
	active = true


func _set_origin(_origin):
	origin = _origin
	global_position = origin.global_position


func _on_disapear():
	hide()
	disapeared = true
	active = false
	manager._on_npc_disapear(self)

func unlock_npc():
	if !on_active_event:
		manager._enable_npc(self)

func _target_reached():
	if type == 0: 
		manager.random_count -= 1
		queue_free()

	if type == 1: 
		active = false
		_set_timer(time_on_location)

# Init timer for event execution
func _set_timer(time):
	var timer = Timer.new()
	timer.set_one_shot(true)
	add_child(timer)
		
	timer.timeout.connect(unlock_npc)
	timer.start(time)
