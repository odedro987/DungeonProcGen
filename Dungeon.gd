extends Node2D

const ROOM_COUNT = 10
const ROOM_SIZE_RANGE = Vector2(30, 100)
const DUNGEON_RADIUS = 200
var rooms
var edges

const DungeonRoom = preload("DungeonRoom.gd")

func _ready():
	randomize()
	rooms = []
	generateRooms()
	edges = Calculations.triangulateRooms(rooms)
	_draw()

func generateRooms():
	for i in range(ROOM_COUNT):
		var newRoom = Rect2(Calculations.getRandomPointInCircle(DUNGEON_RADIUS), Vector2(round(rand_range(ROOM_SIZE_RANGE.x, ROOM_SIZE_RANGE.y)), round(rand_range(ROOM_SIZE_RANGE.x, ROOM_SIZE_RANGE.y))))
		while(Calculations.roomCollidesInArray(newRoom, rooms)):
			newRoom = Rect2(Calculations.getRandomPointInCircle(DUNGEON_RADIUS), Vector2(round(rand_range(ROOM_SIZE_RANGE.x, ROOM_SIZE_RANGE.y)), round(rand_range(ROOM_SIZE_RANGE.x, ROOM_SIZE_RANGE.y))))
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