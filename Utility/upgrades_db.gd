extends Node

const ICON_PATH = "res://Textures/Items/Upgrades/"
const WEAPON_PATH = "res://Textures/Items/Weapons/"

const UPGRADES = {
	"zeriauto1": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"displayname": "Burst Fire",
		"details": "Fire a burst of 7 rounds that deal dmg to the first enemy hit",
		"level": "Level: 1",
		"prerequisite": ["zeri"],
		"type": "weapon"
	},
	"zeriauto2": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"displayname": "Burst Fire",
		"details": "Fire a burst of 7 rounds that deal dmg to the first enemy hit",
		"level": "Level: 2",
		"prerequisite": ["zeriauto1"],
		"type": "weapon"
	},
	"zeriauto3": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"displayname": "Burst Fire",
		"details": "Fire a burst of 7 rounds that deal dmg to the first enemy hit",
		"level": "Level: 3",
		"prerequisite": ["zeriauto2"],
		"type": "weapon"
	},
	"zeriauto4": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"displayname": "Burst Fire",
		"details": "Fire a burst of 7 rounds that deal dmg to the first enemy hit",
		"level": "Level: 4",
		"prerequisite": ["zeriauto3"],
		"type": "weapon"
	},
	"zeriauto5": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"displayname": "Burst Fire",
		"details": "Fire a burst of 7 rounds that deal dmg to the first enemy hit. Deal static dmg every hit",
		"level": "Level: Max",
		"prerequisite": ["zeriauto4"],
		"type": "weapon"
	},
	"swainauto1": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"displayname": "Death's Hand",
		"details": "Shoot 3 bolts of eldritch enery in a cone, dealing damage that scales with Max Health",
		"level": "Level: 1",
		"prerequisite": ["swain"],
		"type": "weapon"
	},
	"swainauto2": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"displayname": "Death's Hand",
		"details": "Shoot 3 bolts of eldritch enery in a cone, dealing damage that scales with Max Health",
		"level": "Level: 2",
		"prerequisite": ["swainauto1"],
		"type": "weapon"
	},
	"swainauto3": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"displayname": "Death's Handr",
		"details": "Shoot 3 bolts of eldritch enery in a cone, dealing damage that scales with Max Health",
		"level": "Level: 3",
		"prerequisite": ["swainauto2"],
		"type": "weapon"
	},
	"swainauto4": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"displayname": "Death's Hand",
		"details": "Shoot 3 bolts of eldritch enery in a cone, dealing damage that scales with Max Health",
		"level": "Level: 4",
		"prerequisite": ["swainauto3"],
		"type": "weapon"
	},
	"swainauto5": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"displayname": "Death's Hand",
		"details": "Shoot 3 bolts of eldritch enery in a cone, dealing damage that scales with Max Health and healing Swain for a percentage of the damage",
		"level": "Level: Max",
		"prerequisite": ["swainauto4"],
		"type": "weapon"
	},
	"armor1": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armor",
		"details": "Reduces Damage By 1 point",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"armor2": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armor",
		"details": "Reduces Damage By an additional 1 point",
		"level": "Level: 2",
		"prerequisite": ["armor1"],
		"type": "upgrade"
	},
	"armor3": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armor",
		"details": "Reduces Damage By an additional 1 point",
		"level": "Level: 3",
		"prerequisite": ["armor2"],
		"type": "upgrade"
	},
	"armor4": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armor",
		"details": "Reduces Damage By an additional 1 point",
		"level": "Level: 4",
		"prerequisite": ["armor3"],
		"type": "upgrade"
	},
	"speed1": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Speed",
		"details": "Movement Speed Increased by 50% of base speed",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"speed2": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Speed",
		"details": "Movement Speed Increased by an additional 50% of base speed",
		"level": "Level: 2",
		"prerequisite": ["speed1"],
		"type": "upgrade"
	},
	"speed3": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Speed",
		"details": "Movement Speed Increased by an additional 50% of base speed",
		"level": "Level: 3",
		"prerequisite": ["speed2"],
		"type": "upgrade"
	},
	"speed4": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Speed",
		"details": "Movement Speed Increased an additional 50% of base speed",
		"level": "Level: 4",
		"prerequisite": ["speed3"],
		"type": "upgrade"
	},
	"tome1": {
		"icon": ICON_PATH + "thick_new.png",
		"displayname": "Tome",
		"details": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"tome2": {
		"icon": ICON_PATH + "thick_new.png",
		"displayname": "Tome",
		"details": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 2",
		"prerequisite": ["tome1"],
		"type": "upgrade"
	},
	"tome3": {
		"icon": ICON_PATH + "thick_new.png",
		"displayname": "Tome",
		"details": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 3",
		"prerequisite": ["tome2"],
		"type": "upgrade"
	},
	"tome4": {
		"icon": ICON_PATH + "thick_new.png",
		"displayname": "Tome",
		"details": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 4",
		"prerequisite": ["tome3"],
		"type": "upgrade"
	},
	"scroll1": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Scroll",
		"details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"scroll2": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Scroll",
		"details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 2",
		"prerequisite": ["scroll1"],
		"type": "upgrade"
	},
	"scroll3": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Scroll",
		"details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 3",
		"prerequisite": ["scroll2"],
		"type": "upgrade"
	},
	"scroll4": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Scroll",
		"details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 4",
		"prerequisite": ["scroll3"],
		"type": "upgrade"
	},
	"ring1": {
		"icon": ICON_PATH + "urand_mage.png",
		"displayname": "Ring",
		"details": "Your spells now spawn 1 more additional attack",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"ring2": {
		"icon": ICON_PATH + "urand_mage.png",
		"displayname": "Ring",
		"details": "Your spells now spawn an additional attack",
		"level": "Level: 2",
		"prerequisite": ["ring1"],
		"type": "upgrade"
	},
	"food": {
		"icon": ICON_PATH + "chunk.png",
		"displayname": "Food",
		"details": "Heals you for 20 health",
		"level": "N/A",
		"prerequisite": [],
		"type": "item"
	}
}
