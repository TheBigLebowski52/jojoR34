extends Control

@onready var player : CharacterBody2D = get_node("/root/Game/Player")
@onready var general_container: TabContainer = get_node("/root/Menu/PanelContainer/GeneraltabContainer")
@onready var inventory_container: TabContainer = $InventoryTabContainer


var selected_tab_index: int = 1 # tab evidenziata (1 = Inventory)
var in_submenu: bool = false
var menu_open: bool = false
var in_category: bool = false

const TAB_TITLES = ["ITEM", "FOOD", "TEXTS", "ARMOR", "WEAPONS"]
var selected_inventory_index: int = 0
var in_inventory_submenu: bool = false


func _ready() -> void:
	visible = false
	await get_tree().process_frame
	inventory_container.current_tab = 0
	_update_tab_highlight()
	inventory_container.add_theme_icon_override("increment", null)
	inventory_container.add_theme_icon_override("decrement", null)
	inventory_container.clip_tabs = false

	#ammazza il mouse
	var tab_bar := inventory_container.get_tab_bar()
	tab_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _unhandled_input(event: InputEvent) -> void:

	if event.is_action_pressed("menu"):
		if menu_open:
			_close_menu()
		else:
			_open_menu()
	elif menu_open:
		if in_submenu:
			_handle_category_input(event)
		else:
			_handle_inventory_input(event)


# -------------------------------
#       INPUT HANDLING
# -------------------------------
func _handle_inventory_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_w") or event.is_action_pressed("ui_left"):
		_move_cursor(-1)
	elif event.is_action_pressed("move_e") or event.is_action_pressed("ui_right"):
		_move_cursor(1)
	elif event.is_action_pressed("menu_select"):
		_open_category()
	elif event.is_action_pressed("back"):
		_close_menu()


func _handle_category_input(event: InputEvent) -> void:
	if event.is_action_pressed("back"):
		in_submenu = false
		inventory_container.current_tab = 0
		_reset_tab_titles()
		_update_tab_highlight()

# -------------------------------
#       MENU CONTROL
# -------------------------------
func _open_menu() -> void:
	menu_open = true
	visible = true
	in_submenu = true
	selected_tab_index = 1
	inventory_container.current_tab = 0
	_reset_tab_titles()
	_update_tab_highlight()


func _close_menu() -> void:
	menu_open = false
	visible = false
	in_submenu = false
	in_category = false
	inventory_container.current_tab = 0
	_reset_tab_titles()


func _open_category() -> void:
	in_category = true
	


# -------------------------------
#       TAB NAVIGATION
# -------------------------------
func _move_cursor(direction: int) -> void:
	if in_submenu:
		var tab_count = inventory_container.get_tab_count()
		selected_tab_index = clamp(selected_tab_index + direction, 1, tab_count - 1)
		_update_tab_highlight()


func _update_tab_highlight() -> void:
	for i in range(1, inventory_container.get_tab_count()):
		var title : String = TAB_TITLES[i - 1]
		
		if i == selected_tab_index and not in_category:
			# Tab selezionata → evidenziata
			inventory_container.set_tab_title(i, "[ " + title + " ]")
		elif not in_category:
			# Tab normale in home
			inventory_container.set_tab_title(i, title)


func _select_tab(event) -> void:
	# Entrata in submenu, nasconde i titoli
	inventory_container.current_tab = selected_tab_index
	in_category = true
	if selected_tab_index == 1 and event.is_action_pressed(""):
		_handle_inventory_input(event)

# -------------------------------
#       UTILITY
# -------------------------------
func _reset_tab_titles() -> void:
	for i in range(1, inventory_container.get_tab_count()):
		inventory_container.set_tab_hidden(i, false)
		inventory_container.set_tab_title(i, TAB_TITLES[i - 1])
