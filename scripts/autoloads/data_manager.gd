# A place to store constants and other related information

extends Node

signal show_dan
signal Level4_has_done_confrontation

var intro_done := false

var Level5: Dictionary[String, Variant] = {
	done_level = true,
	in_minigame = false,
	minigame_1_complete = false
}
