extends Control

@onready var player : CharacterBody2D = get_node("/root/Game/Player")
@onready var mugshot: TextureRect = $Mugshot
@onready var low_mugshot: TextureRect = $LowMugshot
@onready var namePlayer: Label = $Name
@onready var health: Label = $HP
@onready var fullness: Label = $Fullness
@onready var humanity: Label = $Humanity
@onready var bloodBar: TextureProgressBar = $BloodBar
@onready var gutBar: TextureProgressBar = $GutBar
@onready var blood_val: Label = $bloodVal
@onready var gut_val: Label = $gutVal



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	namePlayer.text = GameManager.char1_name
	match GameManager.char1_humanity:
		-1:
			humanity.text = "▽"
		0:
			humanity.text = ""
		1:
			humanity.text = "▼"
		2:
			humanity.text = "▼▼"
		3:
			humanity.text = "▼▼▼"


#Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# aggiornamento mugshot
	if GameManager.char1_hp >= 30:
		mugshot.visible = true
		low_mugshot.visible = false
	else:
		mugshot.visible = false
		low_mugshot.visible = true

	# aggiornamento HP
	blood_val.text = str(GameManager.char1_hp) + " / " + str(GameManager.char1_maxHp)
	bloodBar.value = GameManager.char1_hp

	# aggiornamento saturazione
	gut_val.text = str(GameManager.char1_sat) + " / " + str(GameManager.char1_maxSat)
	gutBar.value = GameManager.char1_sat
