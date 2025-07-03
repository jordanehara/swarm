extends Area2D

var damage = 10
var attack_size = 1.0
var HurtBoxType = 0 # Cooldown
var slow = 0.3
var totaldamage = 0

@onready var player = get_tree().get_first_node_in_group("player")
@onready var snd = $snd_ult

func _ready():
	snd.play()
	position = player.global_position
	attack_size = 1.0 * (1 + player.spell_size)
	scale = Vector2(1, 1) * attack_size

func _on_duration_timer_timeout() -> void:
	queue_free()


func _on_health_drain_timer_timeout() -> void:
	if player.hp < player.maxhp:
		player.hp = clamp(player.hp + int(totaldamage * 0.1), 0, player.maxhp)
		totaldamage = 0
