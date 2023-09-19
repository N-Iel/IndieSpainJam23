extends Node2D

@onready var sprite = $model

var target_position = null # position of the notification object

func _process(delta):
	var canvas = get_canvas_transform()
	var top_left = -canvas.origin / canvas.get_scale() # Get canvas origin unscaled
	var size = get_viewport_rect().size / canvas.get_scale() # Returns the size (1920x1080) of the screen

	
	set_market_position(Rect2(top_left, size))
	set_marker_rotation()
	
func set_market_position(bounds : Rect2):
	if !target_position:
		sprite.global_position.x = clamp(global_position.x, bounds.position.x, bounds.end.x)
		sprite.global_position.y = clamp(global_position.y, bounds.position.y, bounds.end.y)
	else:
		get_relative_position(bounds)
	
	if bounds.has_point(global_position):
		hide()
	else:
		show()
		
func set_marker_rotation():
	var angle = (global_position - sprite.global_position).angle()
	sprite.global_rotation = angle
	
func get_relative_position(bounds : Rect2, ):
	var offset = global_position - target_position
	var length
	
	# get corner angles respective to target
	var tl = (bounds.position - target_position).angle()
	var tr = (Vector2(bounds.end.x, bounds.position.y) - target_position).angle()
	var bl = (Vector2(bounds.position.x, bounds.end.y) - target_position).angle()
	var br = (bounds.end - target_position).angle()
	
	# get which border to use for positioning
	if (offset.angle() > tr && offset.angle() < tl) \
			|| (offset.angle() < bl && offset.angle() > br):
		var length_y = clamp(offset.y, bounds.position.y - target_position.y, \
				bounds.end.y - target_position.y)
		var angle = offset.angle() - PI / 2.0
		length = length_y / cos(angle) if cos(angle) != 0 else length_y
	else:
		var length_x = clamp(offset.x, bounds.position.x - target_position.x, \
				bounds.end.x - target_position.x)
		var angle = offset.angle() - PI / 2.0
		length = length_x / cos(angle) if cos(angle) != 0 else length_x
	
	sprite.global_position = Vector2(length * cos(offset.angle()), length * sin(offset.angle())) + target_position
