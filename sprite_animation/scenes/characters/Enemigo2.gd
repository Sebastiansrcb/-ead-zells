extends KinematicBody2D

var Vida := 50
var speed := 120
var aceleracion := 200
var direccion := 0.0
var salto := 250
var velocidad := Vector2.ZERO
const gravedad := 35
var forgod = true


onready var sprite := $Sprite
onready var state_machine = $AnimationTree.get("parameters/playback")

func _physics_process(_delta) -> void:
	
	
	if $Izquierda.is_colliding():
		$Sprite.flip_h = false
		$HitAte2.position.x = -9
		print("Ataque barbaro izq")
		state_machine.travel("Ataque")
		velocidad.x = 0
	elif $Derecha.is_colliding():
		$Sprite.flip_h = true
		$HitAte2.position.x = 9
		print("Ataque barbaro der")
		state_machine.travel("Ataque")
	else: 
		if is_on_wall():
			forgod = not forgod
	
		if forgod == true:
			velocidad.x = -50
			$Sprite.flip_h = false
			state_machine.travel("Walk")
		else:
			velocidad.x = 50
			$Sprite.flip_h = true
			state_machine.travel("Walk")
	#morir
	if Vida <= 0:
		state_machine.travel("Dead")
		velocidad.x=0
		velocidad.y=0
		
	velocidad.y = velocidad.y + gravedad
	# Control de direccion
	sprite.flip_h = direccion > 0 if direccion != 0 else sprite.flip_h
	velocidad = move_and_slide(velocidad, Vector2.UP)
	velocidad.x = lerp(velocidad.x, 0, 0.2)
	
func take_damage():
	Vida -= 1
	print("health: ", Vida)
	

func _on_Hurtbox_area_entered(area):
	take_damage()
	print(area.collision_layer,"-",area.collision_mask)


