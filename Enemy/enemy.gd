extends CharacterBody2D

@export var movement_speed = 20.0
@export var hp = 10
@export var knockback_recovery = 3.5
@export var experience = 1
@export var enemy_damage = 1
var knockback = Vector2.ZERO
var slow_percentage = 1.0

@onready var player = get_tree().get_first_node_in_group("player")
@onready var loot_base = get_tree().get_first_node_in_group("loot")
@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer
@onready var hitBox = $HitBox
@onready var navAgent = $EnemyNavAgent

var exp_gem = preload("res://Objects/experience_gem.tscn")

signal remove_from_array(object)

func _ready():
	anim.play("walk")
	z_index = 1
	hitBox.damage = enemy_damage

func _physics_process(delta: float) -> void:
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	
	navAgent.target_position = player.global_position
	if navAgent.is_navigation_finished():
		return
	var next_path_position = navAgent.get_next_path_position()
	var direction = global_position.direction_to(next_path_position)
	velocity = global_position.direction_to(next_path_position) * movement_speed
	velocity = direction * movement_speed * slow_percentage
	velocity += knockback
	position += velocity * delta
	
	if direction.x > 0.1:
		sprite.flip_h = true
	elif direction.x < -0.1:
		sprite.flip_h = false

func death():
	emit_signal("remove_from_array", self)
	var new_gem = exp_gem.instantiate()
	new_gem.global_position = global_position
	new_gem.experience = experience
	loot_base.call_deferred("add_child", new_gem)
	queue_free() # delete enemy

func _on_hurt_box_hurt(node_path, damage, angle, knockback_amount, slow) -> void:
	hp -= damage
	knockback = angle * knockback_amount
	slow_percentage = slow
	if hp <= 0:
		death()
		get_node(node_path).increment_killcount()
