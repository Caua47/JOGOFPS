extends CharacterBody3D
const explosion = preload("res://explosion.tscn")
var vida = 100


func dano(valor):
	vida -= valor

	if vida <= 0:
		var bum = explosion.instantiate()
		get_parent().add_child(bum)
		bum.global_position = global_position
		morrer()
	

func morrer():
	queue_free()
