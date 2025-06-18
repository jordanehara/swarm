extends Node

const ICON_PATH = "res://Textures/Items/Upgrades/"
const WEAPON_PATH = "res://Textures/Items/Weapons/"

const UPGRADES = {
	"icespear1": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"displayname": "Ice Spear",
		"details": "A spear of ice is thrown at a random enemy",
		"level": "Level: 1",
		"prerequiside": [],
		"type": "weapon"
	},
	"icespear2": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"displayname": "Ice Spear",
		"details": "An additional ice spear is thrown",
		"level": "Level: 1",
		"prerequiside": ["icespear1"],
		"type": "weapon"
	},
	"food": {
		"icon": ICON_PATH + "chunk.png",
		"displayname": "Food",
		"details": "Heals you for 20 health",
		"level": "",
		"prerequiside": [],
		"type": "item"
	}
}
