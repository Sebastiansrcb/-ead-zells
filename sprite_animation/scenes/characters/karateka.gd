extends KinematicBody2D

const ACCEL = 500
const MAX_SPEED = 80
const FRICTION = 500

var velocity = Vector2.ZERO
onready var state_machine = $AnimationTree.get("parameters/playback")
var health = 10
const SPEED = 180
const GRAVITY = 35
const JUMPFORCE = -1000

# warning-ignore:unused_argument
func _input(event):
	if Input.is_action_just_pressed("damage"):
		health -= 1
		print("health: ", health)

func _physics_process(delta):
	# entrada de movimiento
	var input_vector = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		velocity.x = SPEED
		$AnimationPlayer.play("Caminar")
	
	if Input.is_action_pressed("ui_left"):
		velocity.x = -SPEED
		$AnimationPlayer.play("Caminar")
		
	velocity.y = velocity.y + GRAVITY
	
	if Input.is_action_just_released("Saltar") and is_on_floor():
		velocity.y = JUMPFORCE

	input_vector = input_vector.normalized()
	print(input_vector)
	
	if input_vector != Vector2.ZERO:
		# jugador en movimiento
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCEL * delta)
		state_machine.travel("Caminar")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		state_machine.travel("idle")
	
	# atacar
	if Input.is_action_just_pressed("Punhete"):
		$AnimationPlayer.play("Punhete")
		
	if Input.is_action_just_pressed("Patada"):
		$AnimationPlayer.play("Patada")
	#Sprint
	#if Input.is_action_pressed("sprint"):
	#	state_machine.travel("Caminar")
	#	velocity = velocity.move_toward(input_vector * MAX_SPEED * MAX_SPEED, ACCEL * delta)
	#Rol
	if Input.is_action_just_pressed("Roll"):
		$AnimationPlayer.play("Roll")
		
	#Saltar Atacar
	if Input.is_action_pressed("PatadaFuerte"):
		$AnimationPlayer.play("PatadaFuerte")
		
	# morir
	if health <= 0:
		state_machine.travel("Morir")
		velocity = Vector2.ZERO
	
	if velocity.x < 0:
		$Sprite.scale.x = -2
		$Sprite.scale.y = 2
	elif velocity.x > 0:
		$Sprite.scale.x = 2
		$Sprite.scale.y = 2
	#ejecutar movimiento
	velocity = move_and_slide(velocity, Vector2.UP)
	velocity.x = lerp(velocity.x, 0, 0.2)
	

