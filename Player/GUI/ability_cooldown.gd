extends Control

@export var cd_timer: Timer
@export var skill_image: CompressedTexture2D

@onready var timelbl = $timelbl
@onready var progressbar = $ProgressBar
@onready var updateTimer = $UpdateTimer

func _ready():
	progressbar.texture_under = skill_image

func _physics_process(_delta: float) -> void:
	if not cd_timer.is_stopped():
		timelbl.text = str(snapped(cd_timer.time_left, 0.1))
	else:
		timelbl.visible = false

func _on_timer_timeout() -> void:
	progressbar.value -= 1/(updateTimer.wait_time*cd_timer.wait_time)
