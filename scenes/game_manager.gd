extends Node

@onready var message: Label = get_node("/root/Game/Player/Camera2D/Label")


var dead : bool = false

var area : int
var room : int
var locations = [
	["Silvera's Backstreets - Golden Church", "A Scar on Top of the World"],
	["Silvera's Throat - Main Entrance", null],
	["Enthor's Corpse - Stomach", null],
	["Dark Depths - Subterranean Lake", null],
	["Temples of Frenzy - Naos", null],
	["Syndra's Caves - Altar of Stolen Memories", null],
	["Eternal Gallows - Blood Cantine", null],
	["The Anvil - Nuclear Liar", null],
	["The Downward Spiral - Altar of Chaos", null],
	["Still, Endless Sea", null]
]


##sennò si incazza godot
var char1_ID : int = 4

var char1_humanity : int
var char1_name : String 
var char1_maxHp : int
var char1_hp : int 
var char1_maxSat : int
var char1_sat : int 
var char1_baseAtk : int 
var char1_baseDef : float  #moltiplicato per il danno, da il valore di hp tolti
var char1_baseMagAtk : int 
var char1_baseMagDef : float
var char1_critRate : int 
var char1_evasion : int 
var char1_accuracy : int 


##PERSONAGGIO GIOCANTE
func identifyChar():
	match char1_ID:
		1:
			char1_humanity = 3
			char1_name = "Mort"
			char1_maxHp = 100
			char1_hp = 100
			char1_maxSat = 100
			char1_sat = 0
			char1_baseAtk = 40
			char1_baseDef = 0.9 #moltiplicato per il danno, da il valore di hp tolti
			char1_baseMagAtk = 10
			char1_baseMagDef = 1.0
			char1_critRate = 10
			char1_evasion = 15
			char1_accuracy = 90
		2:
			char1_humanity = 1
			char1_name = "Tanek"
			char1_maxHp = 100
			char1_hp = 100
			char1_maxSat = 90
			char1_sat = 0
			char1_baseAtk = 100
			char1_baseDef = 1.0 #moltiplicato per il danno, da il valore di hp tolti
			char1_baseMagAtk = 5
			char1_baseMagDef = 1.0
			char1_critRate = 7
			char1_evasion = 10
			char1_accuracy = 95
		3:
			char1_humanity = 2
			char1_name = "Kaith"
			char1_maxHp = 110
			char1_hp = 110
			char1_maxSat = 110
			char1_sat = 0
			char1_baseAtk = 300
			char1_baseDef = 0.95 #moltiplicato per il danno, da il valore di hp tolti
			char1_baseMagAtk = 0
			char1_baseMagDef = 1.0
			char1_critRate = 5
			char1_evasion = 5
			char1_accuracy = 90
		4:
			char1_humanity = 3
			char1_name = "Rya"
			char1_maxHp = 90
			char1_hp = 90
			char1_maxSat = 80
			char1_sat = 0
			char1_baseAtk = 20
			char1_baseDef = 1.0 #moltiplicato per il danno, da il valore di hp tolti
			char1_baseMagAtk = 90
			char1_baseMagDef = 0.9
			char1_critRate = 10
			char1_evasion = 10
			char1_accuracy = 90
		5:
			char1_humanity = 2
			char1_name = "Angelo"
			char1_maxHp = 100
			char1_hp = 100
			char1_maxSat = 100
			char1_sat = 0
			char1_baseAtk = 70
			char1_baseDef = 0.93 #moltiplicato per il danno, da il valore di hp tolti
			char1_baseMagAtk = 0
			char1_baseMagDef = 1.0
			char1_critRate = 7
			char1_evasion = 5
			char1_accuracy = 90
		6:
			char1_humanity = 2
			char1_name = "Roy"
			char1_maxHp = 100
			char1_hp = 100
			char1_maxSat = 90
			char1_sat = 0
			char1_baseAtk = 50
			char1_baseDef = 1.0 #moltiplicato per il danno, da il valore di hp tolti
			char1_baseMagAtk = 5
			char1_baseMagDef = 1.0
			char1_critRate = 13
			char1_evasion = 10
			char1_accuracy = 85

		
			##magari spostalo poi in un qualche character selection menu
			
			
##PERSONAGGIO 2
var char2_ID : int 
var char2_humanity : int = -1
var char2_name : String = ""
var char2_maxHp : int = 33
var char2_hp : int = 33
var char2_maxSat : int = 33
var char2_sat : int = 0
var char2_baseAtk : int 
var char2_baseDef : float  #moltiplicato per il danno, da il valore di hp tolti
var char2_baseMagAtk : int
var char2_baseMagDef : float 
var char2_critRate : int 
var char2_evasion : int 
var char2_accuracy : int

##PERSONAGGIO 3
var char3_ID : int 
var char3_humanity : int = -1
var char3_name : String = ""
var char3_maxHp : int = 33
var char3_hp : int = 33
var char3_maxSat : int = 33
var char3_sat : int = 0
var char3_baseAtk : int 
var char3_baseDef : float  #moltiplicato per il danno, da il valore di hp tolti
var char3_baseMagAtk : int
var char3_baseMagDef : float 
var char3_critRate : int 
var char3_evasion : int 
var char3_accuracy : int
	
##PERSONAGGIO 4
var char4_ID : int 
var char4_humanity : int = -1
var char4_name : String = ""
var char4_maxHp : int = 33
var char4_hp : int = 33
var char4_maxSat : int = 33
var char4_sat : int = 0
var char4_baseAtk : int 
var char4_baseDef : float  #moltiplicato per il danno, da il valore di hp tolti
var char4_baseMagAtk : int
var char4_baseMagDef : float 
var char4_critRate : int 
var char4_evasion : int 
var char4_accuracy : int



func clamp_stats():
	char1_hp = clamp(char1_hp, 0, char1_maxHp) 
	char2_hp = clamp(char2_hp, 0, char2_maxHp) 
	char3_hp = clamp(char3_hp, 0, char3_maxHp) 
	char4_hp = clamp(char4_hp, 0, char4_maxHp) 
	
	char1_sat = clamp(char1_sat, 0, char1_maxSat) 
	char2_sat = clamp(char2_sat, 0, char2_maxSat) 
	char3_sat = clamp(char3_sat, 0, char3_maxSat) 
	char4_sat = clamp(char4_sat, 0, char4_maxSat) 

func _ready():
	identifyChar()
	
func _physics_process(delta):
	clamp_stats()
	
	if char1_hp <= 0:
		dead = true
	
	if dead:
		message.text = "You just fucking died, you fuckass!"
		message.modulate.a = 1.0
		await get_tree().create_timer(2).timeout
		var tween = get_tree().create_tween()
		tween.tween_property(message, "modulate:a", 0.0, 1.0)  # fade out in 1 secondo
		await tween.finished
		message.text = ""
		
	##restarta la scena corrente
	if Input.is_action_pressed("restart scene"):
		get_tree().reload_current_scene()
		
	##restarta dal nodo specificato (per ora niente)
	if Input.is_action_pressed("restart_all"):
		get_tree().change_scene_to_file("res://path/to/game.tscn")
	
