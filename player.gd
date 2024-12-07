extends CharacterBody2D


@onready var ray_cast_2d: RayCast2D = $RayCast2D
@export var move_speed = 200

func _start_animation(_ready):
	$Graphics/Alive.frames = get_node("SpriteFrames_qnw67")

var dead = false
var looking = 90

func _process(delta):
	if health < 0:
		kill()
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart"):
		restart()
	if dead:
		return

var health = 3

func _physics_process(delta: float):
	if dead:
		return
	var move_dir = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = move_dir * move_speed
	move_and_slide()
	
	# Calculate the direction and set the global rotation
	if move_dir != Vector2.ZERO:
		global_rotation = move_dir.angle() + PI / 2.0
		
	# Invert the sprite when moving left
	if move_dir.x < 0:
		$Graphics/Alive.scale.x = -1
	else:
		$Graphics/Alive.scale.x = 1

	
func kill():
	if dead:
		return
	dead = true
	$Graphics/Dead.show()
	$Graphics/Alive.hide()
	$CanvasLayer/DeathScreen.show()
	z_index = -1


var invincible = false

func _hit():
	if !invincible:
		health -= 1
		invincible = true
		modulate.a = 0.5
		$IframesTimer.start()


func restart():
	get_tree().reload_current_scene()


func _on_iframes_timer_timeout() -> void:
	invincible = false
	modulate.a = 1
