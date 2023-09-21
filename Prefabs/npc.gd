extends CharacterBody2D

@export_subgroup("Components")
@export var sprite: Sprite2D

@export_subgroup("Properties")
@export var movement_speed: float = 200.0

var target : Vector2
@onready var nav: NavigationAgent2D = $NavigationAgent2D

func _physics_process(delta):
	handle_controls()
	handle_position(delta)
	
	move_and_slide()

func handle_controls():
	# Movement
	var input := Vector2.ZERO
	
	if target == null:
		nav.target_position = get_new_target()
	
	#velocity = adjust_diagonal_movement(input.normalized()) * movement_speed
	
func handle_position(delta):
	position += velocity * delta
	
	if velocity.length() == 0: return
	sprite.flip_h = velocity.x < 0
	
func get_new_target():
	pass
	#it will take from a list of points, a random one
	
