extends CanvasLayer

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
@onready var skillTimer = $Skill_cooldown
@onready var ultTimer = $Ult_cooldown

var time = 0
var upgrade_options = []

func update_healthbar(hp : int, maxhp : int):
	healthbar.max_value = maxhp
	healthbar.value = hp

func set_expbar(set_value = 1, set_max_value = 100):
	expBar.value = set_value
	expBar.max_value = set_max_value

func set_skillTimer(timer: Timer, image: CompressedTexture2D):
	skillTimer.cd_timer = timer
	skillTimer.set_texture(image)

func set_ultTimer(timer: Timer, image: CompressedTexture2D):
	ultTimer.cd_timer = timer
	ultTimer.set_texture(image)

func levelup(experience_level, collected_upgrades):
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
		option_choice.item = get_random_item(collected_upgrades)
		upgradeOptions.add_child(option_choice)
		options += 1
	get_tree().paused = true

func get_random_item(collected_upgrades):
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

func adjust_gui_collection(upgrade, collected_upgrades):
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
	
	var option_children = upgradeOptions.get_children()
	for i in option_children:
		i.queue_free()
	upgrade_options.clear()
	levelPanel.visible = false
	levelPanel.position = Vector2(800, 50)

func start_ability_timer(timergui: Control):
	timergui.timelbl.visible = true
	timergui.progressbar.value = 100
	timergui.updateTimer.start()

func _on_btn_menu_click_end() -> void:
	get_tree().paused = false
	var _level = get_tree().change_scene_to_file("res://TitleScreen/menu.tscn")

func death():
	deathPanel.visible = true
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
