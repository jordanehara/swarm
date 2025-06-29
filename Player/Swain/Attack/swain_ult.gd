extends Area2D

var damage = 3
var attack_size = 1.0
var knockback_amount = 150
var HurtBoxType = 0 # Cooldown

@onready var swain = get_tree().get_first_node_in_group("player")
@onready var snd = $snd_ult

func _ready():
	snd.play()

func _on_duration_timer_timeout() -> void:
	queue_free()
