extends Area2D

var level = 1
var hp = 1
var speed = 300
var damage = 7
var HurtBoxType = 1 # HitOnce
var maxDistance = 150
var angle = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")
@onready var snd = $snd_auto
@onready var collision = $CollisionShape2D

signal remove_from_array(object)

func _ready():
	match level:
		1:
			damage = 7
		2:
			damage = 10
		3:
			damage = 13
		4:
			damage = 16
		5:
			damage = 25
			hp = 9999

func _physics_process(delta: float) -> void:
	position += angle * speed * delta
	if position.length() >= maxDistance:
		queue_free()

func enemy_hit(charge = 1):
	snd.play()
	hp -= charge
	if hp <= 0:
		emit_signal("remove_from_array", self)
		queue_free()
