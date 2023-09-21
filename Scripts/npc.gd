extends CharacterBody2D

@export_subgroup("Components")
@export var sprite: Sprite2D

@export_subgroup("Properties")
@export var movement_speed: float = 200.0
@export var available := true
@export var type := 0

var target
var origin
var direction 
var disapeared := false
var active := false


@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var manager = get_parent()

func _physics_process(delta):
	
	if !active || disapeared: return
	
	_handle_controls()
	_handle_position(delta)
	
	move_and_slide()


func _handle_controls():
	# Movement
	if (nav.target_position != null):
		direction = nav.get_next_path_position() - global_position
	else:
		direction = Vector2.ZERO


func _handle_position(delta):
	position += movement_speed * direction.normalized() * delta
	
	if velocity.length() == 0: return
	sprite.flip_h = velocity.x < 0


func _set_active():
	nav.target_position = target.global_position
	active = true


func _set_origin(_origin):
	origin = _origin
	global_position = origin.global_position


func _on_disapear():
	hide()
	disapeared = true
	active = false
	manager._on_npc_disapear(self)


func _on_navigation_agent_2d_target_reached():
	match type:
		1: manager._enable_npc(self)
		0: 
			hide()
			manager._enable_npc(self)
