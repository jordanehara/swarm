extends CharacterBody2D

var movement_speed = 50.0

# delta = 1s/frame_rate
# if moving 600 pixels, movement_speed = 6
# 60 fps = 600/(60*6) = 1.67s
# 20 fps = 600/(20*6) = 5s
#
# if moving 600 pixels, movement_speed 360*delta
# 60 fps = 600/(60*360/1/60) = 1.67s
# 20 fps = 600/(20*360/20) = 1.67s
func _physics_process(delta: float) -> void: # 1/60s movement runs
	movement()
	
	
func movement():
	 # Takes care of pressing down multiple movement directions. Will be +1 or -1 otherwise
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov, y_mov)
	
	# velocity actually moves the character
	# diagonal movement would be faster than right left movement if not normalized
	velocity = mov.normalized() * movement_speed 
	move_and_slide() # specific to 2d body. Automatically uses delta 
