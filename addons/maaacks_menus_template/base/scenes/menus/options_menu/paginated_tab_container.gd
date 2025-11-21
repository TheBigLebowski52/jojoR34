extends TabContainer
## Applies UI page up and page down inputs to tab switching.
@onready var player: CharacterBody2D = $"../.."
@onready var location: Label = $CharacterList/Location/location
@onready var something: Label = $CharacterList/Location/something
@onready var dialogue: NinePatchRect = $"../../Camera2D/DialogueLayer/Dialogo"

var menu_open: bool = false

func _ready() -> void:
	visible = false
	await get_tree().process_frame


func _unhandled_input(event : InputEvent) -> void:
	if dialogue.visible:
		return  

	if event.is_action_pressed("menu"):
		current_tab = 0
		if menu_open:
			_close_menu()
		else:
			_open_menu()
	elif event.is_action_pressed("move_e") or event.is_action_pressed("ui_left"):
		current_tab = (current_tab+1) % get_tab_count()
	elif event.is_action_pressed("move_w") or event.is_action_pressed("ui_right"):
		if current_tab == 0:
			current_tab = get_tab_count()-1
		else:
			current_tab = current_tab-1
			


func _process(delta: float) -> void:
	# quando fai un match, e ti accorgi che stai confrontando numeri, quindi una stringa corrisponde 
	# ad un numero, stai pensando ad un array
	# come le stats e altre cose, le location dovrebbero venire da un database o qualocosa del genere
	# per adesso fottesega
	var locations = GameManager.locations
	location.text = locations[GameManager.area][0]
	something.text = locations[GameManager.area][1]

	# -------------------------------
#       MENU CONTROL
# -------------------------------
func _open_menu() -> void:
	menu_open = true
	visible = true
	get_tree().paused = true


func _close_menu() -> void:

	menu_open = false
	get_tree().paused = false
	visible = false

	
