extends Area2D

var damage = 5
var attack_size = 1.0
var HurtBoxType = 1 # HitOnce

@onready var swain = get_tree().get_first_node_in_group("player")
@onready var snd = $snd_auto
@onready var animation = $AnimationPlayer

func _ready():
	snd.play()
	animation.play("swain_auto")
	attack_size = 1.0 * (1 + swain.spell_size)
	scale = Vector2(1, 1) * attack_size

func _physics_process(_delta: float) -> void:
	position = swain.global_position.normalized()
