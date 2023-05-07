extends KinematicBody2D

var Vida := 200
var speed := 120
var aceleracion := 200
var direccion := 0.0
var salto := 250
const velocidad := Vector2.ZERO
#const gravedad := 9

onready var anim := $AnimationPlayer
onready var sprite := $Sprite
onready var state_machine = $AnimationTree.get("parameters/playback")

func _physics_process(delta):
	direccion = Input.get_axis("ui_left","ui_right")
	velocidad.x = direccion * speed
	
	#Caminar
	if direccion != 0:
		state_machine.travel("Walk")
	#Ataque 
	elif Input.is_action_just_pressed("ataque"):
		state_machine.travel("Ataque")
	#Daño
	elif Input.is_action_pressed("daño"):
		state_machine.travel("Hurt")
	#Morir
	elif Input.is_action_pressed("morir"):
		state_machine.travel("Dead")
	#Quieto
	else:
		state_machine.travel("Idle")
	
	
	sprite.flip_h = direccion > 0 if direccion != 0 else sprite.flip_h
	
	if is_on_floor() and Input.is_action_just_pressed("ui_accept"):
		anim.play("Jump")
		velocidad.y -= salto
		#velocidad.y = gravedad
	#if !is_on_floor():
		#velocidad.y += gravedad
	
	move_and_slide(velocidad)
