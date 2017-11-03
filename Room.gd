extends Node

var id
var rect
	
func _init(id, rect):
	self.id = id
	self.rect = rect

func getRect(): return self.rect
func getId(): return self.id
