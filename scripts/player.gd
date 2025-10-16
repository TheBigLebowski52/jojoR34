extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast: RayCast2D = $RayCast2D  
@onready var label: Label = $Camera2D/Label
@onready var dialogue: NinePatchRect = $Camera2D/Dialogo
@onready var menu: Control = $Menulayer/Menu


const SPEED : int = 300.0

var inventory: PlayerInventory = preload("res://inventory/player_inventory.tres")

func _ready():
	dialogue.visible = false
	add_to_group("player")
	
func _process(_delta):
	#if ray_cast.is_colliding():
		#print("Sto colpendo: ", ray_cast.get_collider())
	pass
	
#------------------------
#MOVIMENTO + ANIMAZIONI
#------------------------
func _physics_process(delta):
	var direction := Vector2.ZERO

#MOVIMENTO CON DIAGONALE (mancano le animazioni e riproduce solo il primo frame)
	if Input.is_action_pressed("move_n"):
		direction.y -= 1
		ray_cast.target_position.x = 0
		ray_cast.target_position.y = -64
		animated_sprite.animation = "walk_n"
	if Input.is_action_pressed("move_e"):
		direction.x += 1
		ray_cast.target_position.x = 64
		ray_cast.target_position.y = 0
		animated_sprite.animation = "walk_e"
	if Input.is_action_pressed("move_s"):
		direction.y += 1
		ray_cast.target_position.x = 0
		ray_cast.target_position.y = 64
		animated_sprite.animation = "walk_s"
	if Input.is_action_pressed("move_w"):
		direction.x -= 1
		ray_cast.target_position.x = -64
		ray_cast.target_position.y = 0
		animated_sprite.animation = "walk_w"
	if Input.is_action_pressed("move_w") and Input.is_action_pressed("move_s"):
		animated_sprite.animation = "walk_w"

	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = direction * SPEED
		move_and_slide()
		
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				animated_sprite.animation = "walk_e"  
			else: 
				"walk_w"
		else:
			if direction.y > 0:
				animated_sprite.animation = "walk_s"
			else:
				"walk_n"
		animated_sprite.play()
	else:
		velocity = Vector2.ZERO
		animated_sprite.stop()
		
	if Input.is_action_just_pressed("interact"):
		_try_interact()
		
	
#-------------------------
#INTERAZIONE 
#--------------------------

func _try_interact() -> void:
	
	if not ray_cast.is_colliding():
		return  # non c'è un cazzo davanti
	var obj := ray_cast.get_collider()
	# pensare e implementare l'idea di fare un gruppo "interactables" 
	if (obj.is_in_group("chest") or obj.is_in_group("npc") or obj.is_in_group("save")) and obj.has_method("interact"):
		obj.interact() 
