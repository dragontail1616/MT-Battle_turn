extends Node

var level_name: String = ""
var no_teams: int = 0
var teams_integrants: int = 0
var teams: Array[String] = [] # Nombre de los equipos
var participants: Dictionary[String, Array] = {} # Nombre de equipo con sus participantes
var inventory: Dictionary[String, Array] = {} # Nombre del personaje con el nombre de los items de su inventario
var objects: Array[String] = [] # Objetos habilitados para drops
var turn_time_limit: float = 0.0 # Tiempo limite por turno
var max_rounds: int = 0 # Maximo de rondas antes de la destruccion del mapa
var victory_rules # TODO: Añadir un enum con los tipos de juegos (eliminacion de equipos...)

func team_victory(t: Team) -> void: # Pendiente de cambio los parametros
	pass

func team_eliminated(t: Team) -> void:
	pass

func game_over() -> void:
	pass
