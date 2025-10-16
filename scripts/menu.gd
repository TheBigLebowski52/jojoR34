extends Control

@onready var player: CharacterBody2D = $"../.."
@onready var general_container: TabContainer = $PanelContainer/GeneraltabContainer
@onready var location: Label = $PanelContainer/GeneraltabContainer/CharacterList/Location/location
@onready var something: Label = $PanelContainer/GeneraltabContainer/CharacterList/Location/something
@onready var dialogue: NinePatchRect = $"../../Camera2D/Dialogo"

@onready var inventory_tab_container: TabContainer = $PanelContainer/GeneraltabContainer/INVENTORY/InventoryTabContainer


const TAB_TITLES = ["INVENTORY", "SKILL", "EQUIPMENT", "SETTINGS"]

var selected_tab_index: int = 1 # tab evidenziata (1 = Inventory)
var in_submenu: bool = false
var menu_open: bool = false

const INVENTORY_TITLES = ["ITEM", "FOOD", "TEXTS", "ARMOR", "WEAPONS"]
var selected_inventory_index: int = 0
var in_inventory_submenu: bool = false


func _ready() -> void:
	visible = false
	general_container.set_tab_hidden(0, true) # nasconde la tab con i personaggi
	await get_tree().process_frame
	general_container.current_tab = 0
	_update_tab_highlight()
	general_container.add_theme_icon_override("increment", null)
	general_container.add_theme_icon_override("decrement", null)
	general_container.clip_tabs = false

	#ammazza il mouse
	var tab_bar := general_container.get_tab_bar()
	tab_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _process(delta: float) -> void:
	match GameManager.area:
		0:
			match GameManager.room:
				0:
					location.text = "Silvera's Backstreets - Golden Church"
					something.text = "A Scar on Top of the World"
		1:
			match GameManager.room:
				0:
					location.text = "Silvera's Throat - Main Entrance"
		2:
			match GameManager.room:
				0:
					location.text = "Enthor's Corpse - Stomach"
		3:
			match GameManager.room:
				0:
					location.text = "Dark Depths - Subterranean Lake"
		4:
			match GameManager.room:
				0:
					location.text = "Temples of Frenzy - Naos"
		5:
			match GameManager.room:
				0:
					location.text = "Syndra's Caves - Altar of Stolen Memories"
		6:
			match GameManager.room:
				0:
					location.text = "Eternal Gallows - Blood Cantine"
		7:
			match GameManager.room:
				0:
					location.text = "The Anvil - Nuclear Liar"
		8:
			match GameManager.room:
				0:
					location.text = "The Downward Spiral - Altar of Chaos"
		9:
			match GameManager.room:
				0:
					location.text = "Still, Endless Sea"


func _unhandled_input(event: InputEvent) -> void:
	if dialogue.visible:
		return  

	if event.is_action_pressed("menu"):
		if menu_open:
			_close_menu()
		else:
			_open_menu()
	elif menu_open:
		if in_submenu:
			_handle_submenu_input(event)
		else:
			_handle_status_input(event)


# -------------------------------
#       INPUT HANDLING
# -------------------------------
func _handle_status_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_w") or event.is_action_pressed("ui_left"):
		_move_cursor(-1)
	elif event.is_action_pressed("move_e") or event.is_action_pressed("ui_right"):
		_move_cursor(1)
	elif event.is_action_pressed("menu_select"):
		_open_submenu()
	elif event.is_action_pressed("back"):
		_close_menu()


func _handle_submenu_input(event: InputEvent) -> void:
	if event.is_action_pressed("back"):
		in_submenu = false
		general_container.current_tab = 0
		_reset_tab_titles()
		_update_tab_highlight()


func _handle_inventory_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_w") or event.is_action_pressed("ui_left"):
		_move_cursor(-1)
	elif event.is_action_pressed("move_e") or event.is_action_pressed("ui_right"):
		_move_cursor(1)
	elif event.is_action_pressed("menu_select"):
		_open_submenu()
	elif event.is_action_pressed("back"):
		_close_menu()

# -------------------------------
#       MENU CONTROL
# -------------------------------
func _open_menu() -> void:
	menu_open = true
	visible = true
	get_tree().paused = true
	in_submenu = false
	selected_tab_index = 1
	general_container.current_tab = 0
	_reset_tab_titles()
	_update_tab_highlight()


func _close_menu() -> void:
	menu_open = false
	get_tree().paused = false
	visible = false
	in_submenu = false
	general_container.current_tab = 0
	_reset_tab_titles()


func _open_submenu() -> void:
	in_submenu = true
	general_container.current_tab = selected_tab_index
	general_container.set_tab_hidden(0, true)
	general_container.set_tab_hidden(1, true)
	general_container.set_tab_hidden(2, true)
	general_container.set_tab_hidden(3, true)
	general_container.set_tab_hidden(4, true)


# -------------------------------
#       TAB NAVIGATION
# -------------------------------
func _move_cursor(direction: int) -> void:
	if in_submenu:
		return # cursore disabilitato in submenu
	var tab_count = general_container.get_tab_count()
	selected_tab_index = clamp(selected_tab_index + direction, 1, tab_count - 1)
	_update_tab_highlight()


func _update_tab_highlight() -> void:
	for i in range(1, general_container.get_tab_count()):
		var title : String = TAB_TITLES[i - 1]
		
		if i == selected_tab_index and not in_submenu:
			# Tab selezionata → evidenziata
			general_container.set_tab_title(i, "[ " + title + " ]")
		elif not in_submenu:
			# Tab normale in home
			general_container.set_tab_title(i, title)


func _select_tab(event) -> void:
	# Entrata in submenu → nascondi i titoli
	general_container.current_tab = selected_tab_index
	in_submenu = true
	_hide_tab_titles()
	if selected_tab_index == 1 and event.is_action_pressed(""):
		_handle_inventory_input(event)

# -------------------------------
#       UTILITY
# -------------------------------
func _reset_tab_titles() -> void:
	for i in range(1, general_container.get_tab_count()):
		general_container.set_tab_hidden(i, false)
		general_container.set_tab_title(i, TAB_TITLES[i - 1])


func _hide_tab_titles() -> void:
	for i in range(1, general_container.get_tab_count()):
		general_container.set_tab_title(i, "")
