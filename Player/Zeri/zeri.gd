extends CharacterBody2D

var movement_speed = 50.0
const basehp = 200
var maxhp = basehp
var hp = basehp
var killCount = 0
var last_movement = Vector2.UP

var experience = 0
var experience_level = 1
var collected_experience = 0

# Attacks
var zeriAuto = preload("res://Player/Zeri/Attack/zeri_auto.tscn")
var zeriAuto_abilityspeed = 1.75

#var zeriSkill = preload("res://Player/Zeri/Attack/zeri_skill.tscn")
var zeriSkill_abilityspeed = 20

#var zeriUlt = preload("res://Player/Zeri/Attack/zeri_ult.tscn")
var zeriUlt_abilityspeed = 60

# Attack Nodes
@onready var autoCooldownTimer = get_node("%AutoCooldownTimer")
@onready var skillCooldownTimer = get_node("%SkillCooldownTimer")
@onready var ultCooldownTimer = get_node("%UltCooldownTimer")

# UPGRADES
var collected_upgrades = ["zeri"]
var armor = 0
var speed = 0
var spell_cooldown = 0
var spell_size = 0
var additional_attacks = 0
var health_regen = 1

# Auto
var auto_level = 0

# Enemy Related
var enemy_close = []

@onready var sprite = $Sprite2D
@onready var walkTimer = get_node("%walkTimer")

# GUI
@onready var gui = get_tree().get_first_node_in_group("gui")

# Signal
signal playerdeath

func _ready():
	set_default_gui()
	upgrade_character("zeriauto1")
	_on_hurt_box_hurt("", 0, 0, 0, 0)
	set_spell_speed()

func _physics_process(_delta: float) -> void: # 1/60s movement runs
	movement()
	if Input.get_action_strength("skill"):
		skill()
	if Input.get_action_strength("ult"):
		ult()

func set_default_gui():
	gui.set_expbar(experience, calculate_experiencecap())
	#gui.set_skillTimer(%SkillCooldownTimer, preload("res://Textures/Zeri/zeri_skill_thumb.png") as CompressedTexture2D)
	#gui.set_ultTimer(%UltCooldownTimer, preload("res://Textures/Zeri/zeri_ult_thumb.png") as CompressedTexture2D)

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
		last_movement = mov
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

func set_spell_speed():
	autoCooldownTimer.wait_time = zeriAuto_abilityspeed * (1 - spell_cooldown)
	skillCooldownTimer.wait_time = zeriSkill_abilityspeed * (1 - spell_cooldown)
	ultCooldownTimer.wait_time = zeriUlt_abilityspeed * (1 - spell_cooldown)

func skill():
	if skillCooldownTimer.is_stopped():
		skillCooldownTimer.start()
		gui.start_ability_timer(gui.skillTimer)
		#var ability = zeriSkill.instantiate()
		#add_child(ability)

func ult():
	if ultCooldownTimer.is_stopped():
		ultCooldownTimer.start()
		gui.start_ability_timer(gui.ultTimer)
		#var ultimate = zeriUlt.instantiate()
		#add_child(ultimate)

func increment_killcount():
	killCount += 1
	var oldmaxhp = float(maxhp)
	maxhp = basehp + killCount/3
	hp = int(maxhp * snapped(hp/oldmaxhp, 0.01))
	gui.update_healthbar(hp, maxhp)

func _on_hurt_box_hurt(_node_path, damage, _angle, _knockback, _slow) -> void:
	hp -= clamp(damage - armor, 1.0, 999.0)
	gui.update_healthbar(hp, maxhp)
	if hp <= 0:
		emit_signal("playerdeath")
		gui.death()

func _on_enemy_detection_area_body_entered(body: Node2D) -> void:
	if not enemy_close.has(body):
		enemy_close.append(body)


func _on_enemy_detection_area_body_exited(body: Node2D) -> void:
	if enemy_close.has(body):
		enemy_close.erase(body)


func _on_grab_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		area.target = self


func _on_collect_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		var gem_exp = area.collect()
		calculate_experience(gem_exp)

func calculate_experience(gem_exp):
	var exp_required = calculate_experiencecap()
	collected_experience += gem_exp
	if experience + collected_experience >= exp_required: # level up
		collected_experience -= exp_required-experience
		experience_level += 1
		experience = 0
		exp_required = calculate_experiencecap()
		gui.levelup(experience_level, collected_upgrades)
	else:
		experience += collected_experience
		collected_experience = 0
	
	gui.set_expbar(experience, exp_required)

func calculate_experiencecap():
	var exp_cap = experience_level
	if experience_level < 20:
		exp_cap = experience_level * 5
	elif experience_level < 40:
		exp_cap = 95 * (experience_level-19) * 8
	else:
		exp_cap = 255 * (experience_level-39) * 12
	return exp_cap

func upgrade_character(upgrade):
	match upgrade:
		"zeriauto1", "zeriauto2", "zeriauto3", "zeriauto4":
			auto_level += 1
		"zeriauto5":
			auto_level = 5
		"armor1","armor2","armor3","armor4":
			armor += 1
		"speed1","speed2","speed3","speed4":
			movement_speed += 10.0
		"tome1","tome2","tome3","tome4":
			spell_size += 0.10
		"scroll1","scroll2","scroll3","scroll4":
			spell_cooldown += 0.05
		"ring1","ring2":
			additional_attacks += 1
		"food":
			hp += 20
			hp = clamp(hp, 0, maxhp)
	
	set_spell_speed()
	gui.adjust_gui_collection(upgrade, collected_upgrades)
	collected_upgrades.append(upgrade)
	get_tree().paused = false
	calculate_experience(0)


func _on_auto_cooldown_timer_timeout() -> void:
	if auto_level > 0:
		var auto_attack = zeriAuto.instantiate()
		auto_attack.level = auto_level
		add_child(auto_attack)


func _on_health_regen_timer_timeout() -> void:
	if hp < maxhp:
		hp += health_regen
		gui.update_healthbar(hp, maxhp)
