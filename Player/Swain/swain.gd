extends CharacterBody2D

var movement_speed = 50.0
const basehp = 200
var maxhp = basehp
var hp = basehp
var killCount = 0
var last_movement = Vector2.UP
var time = 0

var experience = 0
var experience_level = 1
var collected_experience = 0


# Attacks
var swainAuto = preload("res://Player/Swain/Attack/swain_auto.tscn")
var swainAuto_abilityspeed = 1.75

var swainSkill = preload("res://Player/Swain/Attack/swain_skill.tscn")
var swainSkill_abilityspeed = 20

var swainUlt = preload("res://Player/Swain/Attack/swain_ult.tscn")

# Attack Nodes
@onready var autoCooldownTimer = get_node("%AutoCooldownTimer")
@onready var skillCooldownTimer = get_node("%SkillCooldownTimer")
@onready var ultCooldownTimer = get_node("%UltCooldownTimer")

# UPGRADES
var collected_upgrades = ["swain"]
var upgrade_options = []
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
@onready var expBar = get_node("%ExperienceBar")
@onready var lblLevel = get_node("%lbl_level")
@onready var levelPanel = get_node("%LevelUp")
@onready var upgradeOptions = get_node("%UpgradeOptions")
@onready var sndLevelUP = get_node("%snd_levelup")
@onready var itemOptions = preload("res://Utility/item_option.tscn")
@onready var healthbar = get_node("%HealthBar")
@onready var lblTimer = get_node("%lblTimer")
@onready var collectedWeapons = get_node("%CollectedWeapons")
@onready var collectedUpgrades = get_node("%CollectedUpgrades")
@onready var itemContainer = preload("res://Player/GUI/item_container.tscn")

@onready var deathPanel = get_node("%DeathPanel")
@onready var lblResult = get_node("%lbl_Result")
@onready var sndVictory = get_node("%snd_victory")
@onready var sndLose = get_node("%snd_lose")
@onready var skillCooldown = $GUILayer/GUI/Skill_cooldown
@onready var ultCooldown = $GUILayer/GUI/Ult_cooldown

# Signal
signal playerdeath

func _ready():
	upgrade_character("swainauto1")
	set_expbar(experience, calculate_experiencecap())
	_on_hurt_box_hurt("", 0, 0, 0, 0)
	set_spell_speed()

func _physics_process(_delta: float) -> void: # 1/60s movement runs
	movement()
	
	if Input.get_action_strength("skill"):
		skill()
	if Input.get_action_strength("ult"):
		ult()

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
	autoCooldownTimer.wait_time = swainAuto_abilityspeed * (1 - spell_cooldown)
	skillCooldownTimer.wait_time = swainSkill_abilityspeed * (1 - spell_cooldown)
	ultCooldownTimer.wait_time = swainUlt_abilityspeed * (1 - spell_cooldown)

func skill():
	if skillCooldownTimer.is_stopped():
		skillCooldownTimer.start()
		start_ability_timer_gui(skillCooldown)
		var ability = swainSkill.instantiate()
		add_child(ability)

func ult():
	if ultCooldownTimer.is_stopped():
		ultCooldownTimer.start()
		start_ability_timer_gui(ultCooldown)
		var ultimate = swainUlt.instantiate()
		add_child(ultimate)

func start_ability_timer_gui(timergui: Control):
	timergui.timelbl.visible = true
	timergui.progressbar.value = 100
	timergui.updateTimer.start()

func increment_killcount():
	killCount += 1
	var oldmaxhp = float(maxhp)
	maxhp = basehp + killCount/3
	hp = int(maxhp * snapped(hp/oldmaxhp, 0.01))
	update_healthbar()

func update_healthbar():
	healthbar.max_value = maxhp
	healthbar.value = hp

func _on_hurt_box_hurt(_node_path, damage, _angle, _knockback, _slow) -> void:
	hp -= clamp(damage - armor, 1.0, 999.0)
	update_healthbar()
	if hp <= 0:
		death()

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
		levelup()
	else:
		experience += collected_experience
		collected_experience = 0
	
	set_expbar(experience, exp_required)

func calculate_experiencecap():
	var exp_cap = experience_level
	if experience_level < 20:
		exp_cap = experience_level * 5
	elif experience_level < 40:
		exp_cap = 95 * (experience_level-19) * 8
	else:
		exp_cap = 255 * (experience_level-39) * 12
	return exp_cap

func set_expbar(set_value = 1, set_max_value = 100):
	expBar.value = set_value
	expBar.max_value = set_max_value

func levelup():
	sndLevelUP.play()
	lblLevel.text = str("Level: ", experience_level)
	var tween = levelPanel.create_tween()
	tween.tween_property(levelPanel, "position", Vector2(220, 50), 0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.play()
	levelPanel.visible = true
	var options = 0
	var optionsmax = 3
	while options < optionsmax:
		var option_choice = itemOptions.instantiate()
		option_choice.item = get_random_item()
		upgradeOptions.add_child(option_choice)
		options += 1
	get_tree().paused = true

func upgrade_character(upgrade):
	match upgrade:
		"swainauto1", "swainauto2", "swainauto3", "swainauto4":
			auto_level += 1
		"swainauto5":
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
	adjust_gui_collection(upgrade)
	var option_children = upgradeOptions.get_children()
	for i in option_children:
		i.queue_free()
	upgrade_options.clear()
	collected_upgrades.append(upgrade)
	levelPanel.visible = false
	levelPanel.position = Vector2(800, 50)
	get_tree().paused = false
	calculate_experience(0)

func get_random_item():
	var dblist = []
	for i in UpgradesDb.UPGRADES:
		if i in collected_upgrades or i in upgrade_options or UpgradesDb.UPGRADES[i]["type"] == "item": # If already collected or exists as an option or food item
			pass
		elif UpgradesDb.UPGRADES[i]["prerequisite"].size() > 0: # If prerequisites exist
			var to_add = true
			for n in UpgradesDb.UPGRADES[i]["prerequisite"]:
				if not n in collected_upgrades:
					to_add = false
			if to_add:
				dblist.append(i)
		else:
			dblist.append(i)
	if dblist.size() > 0:
		var randomitem = dblist.pick_random()
		upgrade_options.append(randomitem)
		return randomitem
	else:
		return null

func change_time(argtime = 0):
	time = argtime
	var get_m = int(time / 60.0)
	var get_s = time % 60
	if get_m < 10:
		get_m = str(0, get_m)
	if get_s < 10:
		get_s = str(0, get_s)
	lblTimer.text = str(get_m, ":", get_s)

func adjust_gui_collection(upgrade):
	var get_upgraded_displayname = UpgradesDb.UPGRADES[upgrade]["displayname"]
	var get_type = UpgradesDb.UPGRADES[upgrade]["type"]
	if get_type != "item":
		var get_collected_displaynames = []
		for i in collected_upgrades.slice(1, -1):
			get_collected_displaynames.append(UpgradesDb.UPGRADES[i]["displayname"])
		if not get_upgraded_displayname in get_collected_displaynames:
			var new_item = itemContainer.instantiate()
			new_item.upgrade = upgrade
			match get_type:
				"weapon":
					collectedWeapons.add_child(new_item)
				"upgrade":
					collectedUpgrades.add_child(new_item)

func death():
	deathPanel.visible = true
	emit_signal("playerdeath")
	get_tree().paused = true
	var tween = deathPanel.create_tween()
	tween.tween_property(deathPanel, "position", Vector2(220, 50), 3.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	if time >= 300:
		lblResult.text = "You Win"
		sndVictory.play()
	else:
		lblResult.text = "You Lose"
		sndLose.play()

func _on_btn_menu_click_end() -> void:
	get_tree().paused = false
	var _level = get_tree().change_scene_to_file("res://TitleScreen/menu.tscn")


func _on_auto_cooldown_timer_timeout() -> void:
	if auto_level > 0:
		var auto_attack = swainAuto.instantiate()
		auto_attack.level = auto_level
		add_child(auto_attack)


func _on_health_regen_timer_timeout() -> void:
	if hp < maxhp:
		hp += health_regen
		update_healthbar()
