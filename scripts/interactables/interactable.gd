class_name Interactable
extends Area2D

var interaction_name: String = ""
var locked_by: Lock.Type = Lock.Type.none

func entered_interact_area():
  pass

func exited_interact_area():
  pass

func interact(_interactor: Humanoid):
  pass
