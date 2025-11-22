extends StaticBody2D

@onready var dialogue := get_node("/root/Game/Player/Camera2D/DialogueLayer/Dialogo")
@onready var player := get_node("/root/Game/Player")
@onready var label: Label = get_node("/root/Game/Player/Camera2D/DialogueLayer/Dialogo/Label")
@onready var chiusa: Sprite2D = $"../chiusa"

var chest : bool = false
var typing : bool = false

func _ready():
	add_to_group("chest")
	randomize()
	if dialogue == null:
		print ("si ma porcoddio")

func interact() -> void:
	var roll : float = randi() % 100 + 1
	var loot := ""

	# non scalabile però per adesso va bene
	# prossimamente al posto di fare sta cacata usami l attributo name di ogni oggeti per fare il messaggio
	var item_file = [
		#oggetti
		["Blue Gem", "objects/blue_gem.tres"],
		["Deer Antlers", "objects/deer_antlers.tres"],
		["Human Skull", "objects/human_skull.tres"],
		["Red Gem", "objects/red_gem.tres"],
		["Rock", "objects/rock.tres"],
		#equipment
		["Black Iron", "equipments/black_iron.tres"], 
		["Chu-ko-nu", "equipments/chu-ko-nu.tres"],
		["Double Knight Swords", "equipments/double_knight_swords.tres"],
		["Finger Darts", "equipments/finger_darts.tres"],
		["Ghoul Mask", "equipments/ghoul_mask.tres"],
		["God of Death's Greatsword", "equipments/GOD_greatsword.tres"],
		["Jagged Greatsword", "equipments/jagged_greatsword.tres"],
		["Jitte", "equipments/jitte.tres"],
		["Khanda", "equipments/khanda.tres"],
		["Kris", "equipments/kris.tres"],
		["Lucerne Hammer","equipments/lucerne_hammer.tres"], 
		["Macuahuitl", "equipments/macuahuitl.tres"],
		["Parashu","equipments/parashu.tres"], 
		["Plumbata", "equipments/plumbata.tres"],
		["Shotel","equipments/shotel.tres"],
		["Throwing Knives", "equipments/throwing_knives.tres"],
		["Tibiar", "equipments/tibiar.tres"],
		["Urumi", "equipments/urumi.tres"],
		["Vertebrale", "equipments/vertebrale.tres"],
		["Yari", "equipments/yari.tres"],
		#food
		["Borscht", "food/borscht.tres"],
		["Golden Milk", "food/golden_milk.tres"],
		["Miso Soup", "food/miso_soup.tres"],
		["Nail Soup", "food/nail_soup.tres"],
		["Rotten Meat", "food/rotten_meat.tres"],
		["Watermelon", "food/watermelon.tres"],
		#incantesimi
		["Apocryphal 1: Devour Yourself", "spells/apoc1_devourYourself.tres"],
		["Apocryphal 2: Abyss' Fangs", "spells/apoc2_abyssFangs.tres"],
		["Edict 1: Unnatural Growth", "spells/edic1_innaturalGrowth.tres"],
		["Sentence 1: Undead Whisper", "spells/sent1_undeadWhisper.tres"],
		["Sentence 2: Not Dead Enough","spells/sent2_notDeadEnough.tres"],
		["Sentence 3: Crimson Dusk", "spells/sent3_crimsonDusk.tres"],
		["Sentence 4: Fire Vomit", "spells/sent4_fireVomit.tres"],
		["Sentence 5: Testicular Torsion", "spells/sent5_testicularTorsion.tres"],
		["Verses 1: Poisonous Offspring", "spells/vers1_poisonousOffspring.tres"],
	]


	randomize()
	# prende un indice casuale (sceglie un oggetto)
	var random_index = randi() % item_file.size()
	loot = item_file[random_index][0]
	var item_file_name = item_file[random_index][1]
	var path = "res://inventory/items/" + item_file_name
	var item: InventoryItem = load(path)
	Inventory.collect(item, 1)

	label.text = "You found " + loot
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
		print("ok1")
		get_tree().paused = false
		dialogue.visible = false
		label.text = ""
		chest = false

func _on_barrels_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_sacks_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
