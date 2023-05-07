extends KinematicBody2D

var Vida := 200
var speed := 120
var aceleracion := 200
var direccion := 0.0
var salto := 250
var velocidad := Vector2.ZERO
const gravedad := 35

onready var anim := $AnimationPlayer
onready var sprite := $Sprite
onready var state_machine = $AnimationTree.get("parameters/playback")

func _physics_process(delta):
	
	if $Izquierda.is_colliding():
		$Sprite.flip_h = false
		print("estas cerca")
		state_machine.travel("Ataque")
		
	if $Derecha.is_colliding():
		$Sprite.flip_h = true
		print("estas cerca")
		state_machine.travel("Ataque")
		
	sprite.flip_h = direccion > 0 if direccion != 0 else sprite.flip_h
	
	velocidad.y = velocidad.y + gravedad
	# Control de direccion
	sprite.flip_h = direccion > 0 if direccion != 0 else sprite.flip_h
	velocidad = move_and_slide(velocidad, Vector2.UP)
	velocidad.x = lerp(velocidad.x, 0, 0.2)
	
	func _on_Timer_timeout():
	#print("patrullar!")
	# calcular una nueva posicion aleatoria dentro del rango para moverse
	target_position = Vector2(rand_range(0, move_range), rand_range(0, move_range))
	state_machine.travel("Walk")
	# definir una duracion aleatoria entre 10 y 20 segundos
	var duration = rand_range(10, 20)
	#print("esperando ", duration, " segundos")
	# iniciar el timer con esa duracion
	timer.start(duration)
