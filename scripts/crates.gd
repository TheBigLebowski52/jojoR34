extends StaticBody2D

@onready var dialogue := get_node("/root/Game/Player/Camera2D/Dialogo")
@onready var player := get_node("/root/Game/Player")
@onready var inventory = get_node("res://inventory/player_inventory.gd")
@onready var label: Label = $Camera2D/Dialogo/Label
@onready var chiusa: Sprite2D = $"../chiusa"

	
var chest : bool = false
var typing : bool = false

func _ready():
	add_to_group("chest")
	randomize()
	if dialogue == null:
		print ("si ma porcoddio")

func interact():
	var roll : float = randi() % 100 + 1
	var loot := ""
	if roll <= 1:
		var cash = randi_range(5, 20)
		loot = str(cash) + " obsidian discs"
	elif roll <= 3:
		loot = "human flesh"
	elif roll <= 5:
		loot = "a shotel"
	elif roll <= 7:
		loot = "a chestplate"
	elif roll <= 9:
		loot = "a human heart"
	elif roll <= 12:
		loot = "blackened bones"
	elif roll <= 20:
		loot = "ashes"
	elif roll <= 30:
		loot = "rotten meat"
	elif roll <= 40:
		loot = "a rock"
	elif roll <= 50:
		loot = "a blue gem"
	elif roll <= 60:
		loot = "a yellow gem"
	elif roll <= 65:
		loot = "a red gem"
	elif roll <= 70:
		loot = "goat skin"
	elif roll <= 75:
		loot = "black sword"
	elif roll <= 80:
		loot = "\"Sentence 4: Fire Vomit\""
	elif roll <= 85:
		loot = "\"Delirious Verses I: Poisonous Offspring\""
	elif roll <= 90:
		loot = "\"Edict 3-12: Ice Wall\""
	elif roll <= 95:
		loot = "\"Empty Stone Tablet: Silence\""
	elif roll <= 96:
		loot = "\">Bible Black\" (THE MANGA)"
	else:
		loot = "nothing"
	chest = true
	remove_from_group("chest")
	
	
	var item_che_ho_messo_nel_gioco_uno_di_ogni_tipo_poi_ti_implementi_tutti_gli_oggetti_con_tutte_le_descrizioni_e_tutte_le_texutre = [
		#oggetti
		"Blue Gem",
		"Deer Antlers",
		"Human Skull",
		"Red Gem",
		"Rock",
		#equipment
		"Black Iron",
		"Chu-ko-nu",
		"Double Knight Swords",
		"Finger Darts",
		"Ghoul Mask",
		"God of Death's Greatsword",
		"Jagged Greatsword",
		"Jitte",
		"Khanda",
		"Kris",
		"Lucerne Hammer",
		"Macuahuitl",
		"Parashu",
		"Plumbata",
		"Shotel",
		"Throwing Knives",
		"Tibiar",
		"Urumi",
		"Vertebrale",
		"Yari",
		#food
		"Borscht",
		"Golden Milk",
		"Miso Soup",
		"Nail Soup",
		"Rotten Meat",
		"Watermelon",
		#incantesimi
		"Apocryphal 1: Devour Yourself",
		"Apocryphal 2: Abyss' Fangs",
		"Edict 1: Unnatural Growth",
		"Sentence 1: Undead Whisper",
		"Sentence 2: Not Dead Enough",
		"Sentence 3: Crimson Dusk",
		"Sentence 4: Fire Vomit",
		"Sentence 5: Testicular Torsion",
		"Verses 1: Poisonous Offspring",
	]
	loot = item_che_ho_messo_nel_gioco_uno_di_ogni_tipo_poi_ti_implementi_tutti_gli_oggetti_con_tutte_le_descrizioni_e_tutte_le_texutre[randi() % item_che_ho_messo_nel_gioco_uno_di_ogni_tipo_poi_ti_implementi_tutti_gli_oggetti_con_tutte_le_descrizioni_e_tutte_le_texutre.size()]
	var item: InventoryItem
	if loot == "Blue Gem":
	# roba solo per testare poi quando fai tutto gli oggetti puoi rimettere puoi togliere questa roba
		item= preload("res://inventory/items/objects/blue_gem.tres")
	elif loot == "Black Sword":
		item= preload("res://inventory/items/equipments/black_iron.tres")
	elif loot == "rotten meat":
		item= preload("res://inventory/items/foods/rotten_meat.tres")
	elif loot == "Sentence 4: Fire Vomit":
		item= preload("res://inventory/items/spells/sent4_fireVomit.tres")
		
	inventory.collect(item)
	
	label.text = ("You found " + loot)
	get_tree().paused = true
	dialogue.visible = true
	await type_text(label, "You found " + loot)
	chiusa.visible = false
	
func type_text(label: Label, full_text: String, speed: float = 0.01) -> void:
	label.text = ""
	for i in full_text.length():
		label.text += full_text[i]
		await get_tree().create_timer(speed).timeout

func _input(event):
	if get_tree().paused and event.is_action_pressed("interact") and chest == true:
		get_tree().paused = false
		dialogue.visible = false
		label.text = ""
		chest = false
	
			


















#


func _on_barrels_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_sacks_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
