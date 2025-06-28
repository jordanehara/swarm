extends Area2D

var damage = 10
var attack_size = 1.0
var HurtBoxType = 1 # HitOnce

var angle = Vector2.ZERO

@onready var swain = get_tree().get_first_node_in_group("player")
@onready var snd = $snd_auto
@onready var animation = $AnimationPlayer
@onready var collision = $CollisionPolygon2D

func _ready():
	swain.velocity = Vector2.ZERO
	snd.play()
	angle = swain.global_position.direction_to(get_global_mouse_position())
	rotation = angle.angle() + deg_to_rad(20)
	
	attack_size = 1.0 * (1 + swain.spell_size)
	scale = Vector2(1, 1) * attack_size

func _physics_process(_delta: float) -> void:
	position = swain.global_position.normalized()

func _on_snd_auto_finished() -> void:
	queue_free()


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	collision.call_deferred("set", "disabled", true)
