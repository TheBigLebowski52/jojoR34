extends Control

@onready var status_screen = $StatusScreen
@onready var inventory_screen = $InventoryScreen
@onready var skill_screen = $SkillScreen
@onready var equipment_screen = $EquipmentScreen
@onready var settings_screen = $SettingsScreen

var menu_open = false
var current_screen : Control = null
var cursor_index = 0
var options = []  # labels nella pagina principale
var in_submenu = false

func _ready():
	# Raccoglie automaticamente tutte le Label del menu principale
	options = $StatusScreen/OptionList.get_children()
	_highlight_option(0)
	_show_screen(status_screen)
	visible = false


func _unhandled_input(event):
	if event.is_action_pressed("menu"):
		if menu_open:
			_close_menu()
		else:
			_open_menu()

	elif menu_open:
		if not in_submenu:
			_handle_status_input(event)
		else:
			if event.is_action_pressed("back"):
				# torna al menu principale
				in_submenu = false
				_show_screen(status_screen)
				_highlight_option(cursor_index)


func _handle_status_input(event):
	if event.is_action_pressed("move_a") or event.is_action_pressed("ui_left"):
		_move_cursor(-1)
	elif event.is_action_pressed("move_d") or event.is_action_pressed("ui_right"):
		_move_cursor(1)
	elif event.is_action_pressed("menu_select"):
		_open_submenu(cursor_index)
	elif event.is_action_pressed("back"):
		_close_menu()


func _move_cursor(dir: int):
	cursor_index = clamp(cursor_index + dir, 0, options.size() - 1)
	_highlight_option(cursor_index)


func _highlight_option(index: int):
	for i in range(options.size()):
		options[i].modulate = Color(1, 1, 1, 1) if i == index else Color(0.5, 0.5, 0.5, 1)


func _open_menu():
	menu_open = true
	visible = true
	get_tree().paused = true
	in_submenu = false
	cursor_index = 0
	_highlight_option(cursor_index)
	_show_screen(status_screen)


func _close_menu():
	menu_open = false
	get_tree().paused = false
	visible = false
	_show_screen(null)


func _open_submenu(index: int):
	in_submenu = true
	match index:
		0:
			_show_screen(inventory_screen)
		1:
			_show_screen(skill_screen)
		2:
			_show_screen(equipment_screen)
		3:
			_show_screen(settings_screen)


func _show_screen(screen: Control):
	# Nasconde tutto, poi mostra solo la schermata richiesta
	for child in get_children():
		if child is Control:
			child.visible = false
	if screen:
		screen.visible = true
