extends Area2D

var level = 1
var hp = 1
var speed = 300
var damage = 2
var HurtBoxType = 1 # HitOnce

var angle = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")
@onready var snd = $snd_auto
@onready var collision = $CollisionPolygon2D

func _physics_process(delta: float) -> void:
	position += angle * speed * delta

func enemy_hit(charge = 1):
	snd.play()
	hp -= charge
	if hp <= 0:
		emit_signal("remove_from_array", self)
		queue_free()
