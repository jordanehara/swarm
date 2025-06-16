extends CharacterBody2D

var movement_speed = 50.0
var hp = 80

# Attacks
var iceSpear = preload("res://Player/Attack/ice_spear.tscn")

# Attack Nodes
@onready var iceSpearTimer = get_node("%IceSpearTimer")
@onready var iceSpearAttackTimer = get_node("%IceSpearAttackTimer")

# Ice Spear
var icespear_ammo = 0
var icespear_baseammo = 1
var icespear_attackspeed = 1.5
var icespear_level = 1

# Enemy Related
var enemy_close = []

@onready var sprite = $Sprite2D
@onready var walkTimer = get_node("%walkTimer")

func _ready():
	attack()

# delta = 1s/frame_rate
# if moving 600 pixels, movement_speed = 6
# 60 fps = 600/(60*6) = 1.67s
# 20 fps = 600/(20*6) = 5s
#
# if moving 600 pixels, movement_speed 360*delta
# 60 fps = 600/(60*360/1/60) = 1.67s
# 20 fps = 600/(20*360/20) = 1.67s
func _physics_process(_delta: float) -> void: # 1/60s movement runs
	movement()

func movement():
	 # Takes care of pressing down multiple movement directions. Will be +1 or -1 otherwise
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov, y_mov)
	
	# Animate sprite
	if mov.x > 0:
		sprite.flip_h = true;
	elif mov.x < 0:
		sprite.flip_h = false;
		
	if mov != Vector2.ZERO:
		if walkTimer.is_stopped():
			if sprite.frame >= sprite.hframes - 1:
				sprite.frame = 0
			else:
				sprite.frame = 1
			walkTimer.start()
	
	# velocity actually moves the character
	# diagonal movement would be faster than right left movement if not normalized
	velocity = mov.normalized() * movement_speed 
	move_and_slide() # specific to 2d body. Automatically uses delta 

func attack():
	if icespear_level > 0:
		iceSpearTimer.wait_time = icespear_attackspeed
		if iceSpearTimer.is_stopped():
			iceSpearTimer.start()

func _on_hurt_box_hurt(damage, _angle, _knockback) -> void:
	hp -= damage
	print(hp)


func _on_ice_spear_timer_timeout() -> void:
	icespear_ammo += icespear_baseammo
	iceSpearAttackTimer.start()


func _on_ice_spear_attack_timer_timeout() -> void:
	if icespear_ammo > 0:
		var icespear_attack = iceSpear.instantiate()
		icespear_attack.position = position
		icespear_attack.target = get_random_target()
		icespear_attack.level = icespear_level
		add_child(icespear_attack)
		icespear_ammo -= 1
		if icespear_ammo > 0:
			iceSpearAttackTimer.start()
		else:
			iceSpearAttackTimer.stop()


func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP


func _on_enemy_detection_area_body_entered(body: Node2D) -> void:
	if not enemy_close.has(body):
		enemy_close.append(body)


func _on_enemy_detection_area_body_exited(body: Node2D) -> void:
	if enemy_close.has(body):
		enemy_close.erase(body)
