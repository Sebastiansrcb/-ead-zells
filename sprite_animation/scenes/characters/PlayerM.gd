extends KinematicBody2D

var vida := 100
var speed := 120
var aceleracion := 300
var direccion := 0.0
var salto := -1000
var velocidad := Vector2.ZERO
const gravedad := 35

onready var anim := $AnimationPlayer
onready var sprite := $Sprite
onready var state_machine = $AnimationTree.get("parameters/playback")

func _physics_process(delta):
	
	direccion = Input.get_axis("ui_left","ui_right")
	velocidad.x = direccion * speed
	#Caminar
	if direccion != 0:
		state_machine.travel("Walk")
	#Correr 
	elif Input.is_action_pressed("sprint"):
		state_machine.travel("Correr")
		velocidad.x = aceleracion
	#Salto
	elif Input.is_action_just_pressed("saltar") and is_on_floor():
		state_machine.travel("Jump")
		velocidad.y = salto
	#Ataque leve
	elif Input.is_action_just_pressed("ataque"):
		state_machine.travel("Ataque2")
		print("ataqueMagico")
	#Ataque Fuerte
	elif Input.is_action_just_pressed("ataqueFuerte"):
		state_machine.travel("Ataque1")
		print("ataqueSuperMagico")
	#Bloquear
	elif Input.is_action_pressed("bloquear"):
		state_machine.travel("Hurt")
	# Muerte
	elif Input.is_action_pressed("morir"):
		state_machine.travel("Dead")
	#Quieto
	else:
		state_machine.travel("Idle")
	velocidad.y = velocidad.y + gravedad
	# Control de direccion
	sprite.flip_h = direccion < 0 if direccion != 0 else sprite.flip_h
	#move_and_slide(velocidad)
	velocidad = move_and_slide(velocidad, Vector2.UP)
	velocidad.x = lerp(velocidad.x, 0, 0.2)
	
	#morir
	if vida <= 0:
		state_machine.travel("Dead")
		velocidad.x=0
		velocidad.y=0
func take_damage():
	vida -= 1
	print("health: ", vida)
	

func _on_Hurtbox_area_entered(area):
	take_damage()
	print(area.collision_layer,"-",area.collision_mask)
	
