class_name TurnManager
extends Node

signal round_started(no_round: int)
signal round_ended(no_round: int)
signal turn_started(character: Character, no_turn: int, team_name: String)
signal turn_ended(character: Character, no_turn: int, team_name: String)

var turn_max_time: float = 20.0 # Tiempo limite para un personaje inmobil
var turn_time: float = 5.0 # Tiempo limite para un personaje por ronde (sera modificado para cant de mana)
var round_max_limit: int = 10 # Rondas limites para el comienzo de la destrucion del mapa

var _characters: Dictionary[String, Character] = {} # Agregar el equipo
var _teams: Array[Team] = []
var _team_turn: int = 0
var _turn_number: int = 0
var _round_number: int = 0

func _init(chars: Dictionary[String, Character], team_map: Dictionary[String, Array]) -> void:
	_characters = chars
	_teams.clear()
	var teams_order: Array[String] = team_map.keys()
	teams_order.shuffle()
	
	for team_name in team_map:
		var t:= Team.new()
		t.team_name = team_name
		t.members.append_array(team_map[team_name])
		t.members.shuffle()
		_teams.append(t)

	_team_turn = 0
	_turn_number = 0
	_round_number = 0

func current_character() -> Character:
	var t: Team = _teams[_team_turn]
	@warning_ignore("integer_division") var div:= roundi(_turn_number / _teams.size())
	var idx_local: int = int(div) % t.members.size()
	var char_name: String = t.members[idx_local]
	return _characters[char_name]

func current_team() -> String:
	return _teams[_team_turn].team_name

func start_turn() -> void:
	var character: Character = current_character()
	var team_name: String = current_team()
	round_started.emit(_round_number)
	turn_started.emit(character, _turn_number, team_name)

func next_turn() -> void:
	# TODO: Las rondas no esta funcionando correctamente
	#var prev_char: Character = current_character()
	#turn_ended.emit(prev_char, _turn_number, current_team())
#
	#_team_turn = (_team_turn + 1) % _teams.size()
	#
	#if is_last_team() and is_last_character_of_team():
		#round_ended.emit(_round_number)
	#
	#if _team_turn == 0:
		#_round_number += 1
		#round_started.emit(_round_number)
	#
	#_turn_number += 1
	#turn_started.emit(current_character(), _turn_number, current_team())
	var prev_char: Character = current_character()
	turn_ended.emit(prev_char, _turn_number, current_team())

	_team_turn = (_team_turn + 1) % _teams.size()

	var t := _teams[_team_turn]
	@warning_ignore("integer_division")
	var last_local := (_turn_number / _teams.size()) % t.members.size() == t.members.size() - 1
	
	if _team_turn == 0 and last_local:
		round_ended.emit(_round_number)
		_round_number += 1
		round_started.emit(_round_number)
	
	_turn_number += 1
	turn_started.emit(current_character(), _turn_number, current_team())

func is_last_character_of_team() -> bool:
	var t : Team= _teams[_team_turn]
	@warning_ignore("integer_division") var div:= (_turn_number / _teams.size())
	return  div % t.members.size() == t.members.size() - 1

func is_last_team() -> bool:
	return (_team_turn == _teams.size() -1) 
