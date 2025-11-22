extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast: RayCast2D = $RayCast2D
@onready var label: Label = $Camera2D/DialogueLayer/Label
@onready var dialogue: NinePatchRect = $Camera2D/DialogueLayer/Dialogo
@onready var menu: Control = $Menulayer/Menu2
@onready var passi: AudioStreamPlayer2D = $passi

const SPEED := 300.0


var last_direction := "s"
var current_surface := "default" # default = pietra

# suoni superfici
var step_sounds := {
	"default": preload("res://assets/sounds/footsteps/PASSSI.mp3"),
	"grass": preload("res://assets/sounds/footsteps/leaves01.ogg"),
	"wood": preload("res://assets/sounds/footsteps/wood01.ogg"),
	"gravel": preload("res://assets/sounds/footsteps/gravel.ogg"),
}

func _ready():
	dialogue.visible = false
	add_to_group("player")

	# collega foot sync
	animated_sprite.connect("frame_changed", Callable(self, "_on_frame_changed"))

	if Global.next_spawn != "":
		var sp_node = get_tree().current_scene.find_child(Global.next_spawn, true, false)
		if sp_node:
			global_position = sp_node.global_position
		else:
			Global.next_spawn = ""

	Global.dialogue = $Camera2D/DialogueLayer/Dialogo
	Global.dialogue_label = $Camera2D/DialogueLayer/Dialogo/Label
	Global.dialogue_sound = $Camera2D/DialogueLayer/Dialogo/TypeSound


# -------------------------------------------------------
# MOVIMENTO + ANIMAZIONI
# -------------------------------------------------------
func _physics_process(delta):
	var direction := Vector2.ZERO

	if Input.is_action_pressed("move_n"):
		direction.y -= 1
	if Input.is_action_pressed("move_s"):
		direction.y += 1
	if Input.is_action_pressed("move_e"):
		direction.x += 1
	if Input.is_action_pressed("move_w"):
		direction.x -= 1

	# mov
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = direction * SPEED
		move_and_slide()

		# direzione
		if abs(direction.x) > abs(direction.y):
			last_direction = "e" if direction.x > 0 else "w"
		else:
			last_direction = "s" if direction.y > 0 else "n"

		# animazioni walk
		match last_direction:
			"e":
				animated_sprite.animation = "walk_e"
				ray_cast.target_position = Vector2(64, 0)
			"w":
				animated_sprite.animation = "walk_w"
				ray_cast.target_position = Vector2(-64, 0)
			"s":
				animated_sprite.animation = "walk_s"
				ray_cast.target_position = Vector2(0, 64)
			"n":
				animated_sprite.animation = "walk_n"
				ray_cast.target_position = Vector2(0, -64)

		animated_sprite.play()

	else:
		velocity = Vector2.ZERO

		# idle
		match last_direction:
			"e":
				animated_sprite.animation = "idle_e"
			"w":
				animated_sprite.animation = "idle_w"
			"s":
				animated_sprite.animation = "idle_s"
			"n":
				animated_sprite.animation = "idle_n"

		animated_sprite.play()

	# Interazione
	if Input.is_action_just_pressed("interact"):
		_try_interact()


# -------------------------------------------------------
# FOOTSTEP SYNC CON FRAME DELL'ANIMAZIONE
# -------------------------------------------------------
func _on_frame_changed():
	if not animated_sprite.is_playing():
		return

	# se non cammini stai zitto
	if not animated_sprite.animation.begins_with("walk"):
		return

	# parte il suono quando il piedino tocca terra
	if animated_sprite.frame == 1:
		_play_step_sound()
	elif animated_sprite.frame == 3:
		_play_step_sound()

func _play_step_sound():
	if not is_instance_valid(passi):
		return

	# cambia stream in base al terreno
	var sound_to_use = step_sounds.get(current_surface, step_sounds["default"])

	if passi.stream != sound_to_use:
		passi.stream = sound_to_use

	passi.pitch_scale = randf_range(0.95, 1.05)

	passi.play()


# -------------------------------------------------------
# INTERAZIONE
# -------------------------------------------------------
func _try_interact() -> void:
	if not ray_cast.is_colliding():
		return

	var obj := ray_cast.get_collider()

	if (obj.is_in_group("chest") or obj.is_in_group("npc") or obj.is_in_group("save")) and obj.has_method("interact"):
		obj.interact()
		
