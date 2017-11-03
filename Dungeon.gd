extends Node2D

var roomCount
var roomSizeRange
var rooms
var edges

const DungeonRoom = preload("DungeonRoom.gd")

func _ready():
	randomize()
	roomCount = 10
	roomSizeRange = Vector2(30, 100)
	rooms = []
	generateRooms()
	edges = Calculations.triangulateRooms(rooms)
	_draw()

func generateRooms():
	for i in range(roomCount):
		var newRoom = Rect2(Calculations.getRandomPointInCircle(200), Vector2(round(rand_range(roomSizeRange.x, roomSizeRange.y)), round(rand_range(roomSizeRange.x, roomSizeRange.y))))
		while(Calculations.roomCollidesInArray(newRoom, rooms)):
			newRoom = Rect2(Calculations.getRandomPointInCircle(200), Vector2(round(rand_range(roomSizeRange.x, roomSizeRange.y)), round(rand_range(roomSizeRange.x, roomSizeRange.y))))
		var dungeonRoom = DungeonRoom.new()
		dungeonRoom.init(i, newRoom)
		rooms.append(dungeonRoom)

func generateCorridors():
	pass

func _draw():
	for room in rooms:
		draw_rect(room.getRect(), Color(0, 0, 0))
	for edge in range(edges.size()):
		draw_line(rooms[edges[edge].x].getMidpoint(), rooms[edges[edge].y].getMidpoint(), Color(255, 0, 0))