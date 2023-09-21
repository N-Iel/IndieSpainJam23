extends CharacterBody2D

@export_subgroup("Components")
@export var sprite: Sprite2D

@export_subgroup("Properties")
@export var movement_speed: float = 200.0

var target : Vector2
@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var manager = get_parent()

func _physics_process(delta):
	handle_controls()
	handle_position(delta)
	
	move_and_slide()

func handle_controls():
	# Movement
	var input := Vector2.ZERO
	
	if nav.target_position == null:
		nav.target_position = manager._get_position()
	
	
	
	
func handle_position(delta):
	position += velocity * delta
	
	if velocity.length() == 0: return
	sprite.flip_h = velocity.x < 0
