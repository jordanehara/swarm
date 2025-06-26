extends Area2D

var damage = 5
var attack_size = 1.0
var HurtBoxType = 0 # Cooldown

@onready var swain = get_tree().get_first_node_in_group("player")
@onready var collisionShape = $CollisionShape2D
@onready var snd = $snd_ultimate

func _ready():
	snd.play()
	attack_size = 1.0 * (1 + swain.spell_size)
	scale = Vector2(1, 1) * attack_size

func _physics_process(_delta: float) -> void:
	position = swain.global_position.normalized()

func _on_duration_timer_timeout() -> void:
	queue_free()
