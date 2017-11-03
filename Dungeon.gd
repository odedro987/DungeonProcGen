extends Node2D

var roomCount
var roomSizeRange
var rooms
var midpoints
var edges

func _ready():
	randomize()
	roomCount = 10
	roomSizeRange = Vector2(20, 100)
	rooms = {}
	midpoints = {}
	generateRooms()
	edges = Calculations.triangulateRooms(rooms)
	_draw()

func generateRooms():
	for i in range(roomCount):
		var newRoom = Rect2(Calculations.getRandomPointInCircle(200), Vector2(round(rand_range(roomSizeRange.x, roomSizeRange.y)), round(rand_range(roomSizeRange.x, roomSizeRange.y))))
		while(Calculations.roomCollidesInArray(newRoom, rooms)):
			newRoom = Rect2(Calculations.getRandomPointInCircle(200), Vector2(round(rand_range(roomSizeRange.x, roomSizeRange.y)), round(rand_range(roomSizeRange.x, roomSizeRange.y))))
		rooms[str(i)] = newRoom
		midpoints[str(i)] = Vector2(newRoom.pos.x + newRoom.size.x / 2, newRoom.pos.y + newRoom.size.y / 2)
	print(midpoints)

func generateCorridors():
	pass

func _draw():
	for room in rooms:
		draw_rect(rooms[room], Color(0, 0, 0))
	for edge in range(edges.size()):
		draw_line(midpoints[str(edges[edge].x)], midpoints[str(edges[edge].y)], Color(255, 0, 0))