extends Node

func _ready():
	randomize()
#Distance between two points.
func getDistance(a, b):
	return sqrt(pow(abs(a.x - b.x), 2) + pow(abs(a.y - b.y), 2))
#Generates a random rounded point in a cricle of R raduius.
func getRandomPointInCircle(radius, gridSnap):
	var angle = 2 * PI * randf()
	var randomizer = randf() + randf()
	var rounder = randomizer if randomizer < 1 else 2 - randomizer
	var randomPoint = Vector2(round(radius * rounder * cos(angle) + radius), round(radius * rounder * sin(angle) + radius))
	return Vector2(randomPoint.x - (int(randomPoint.x) % gridSnap), randomPoint.y - (int(randomPoint.y) % gridSnap))
#Return the midpoint of a circle created from 3 points.
func getCircleCenterFromThreePoints(a, b, c):
	var m1 = (b.y - a.y) / (b.x - a.x)
	var m2 = (c.y - b.y) / (c.x - b.x)
	var centerX = (m1 * m2 * (a.y - c.y) + (m2 * (a.x + b.x)) - m1 * (b.x + c.x)) / (2 * (m2 - m1))
	var centerY = (-1 / m1) * (centerX - ((a.x + b.x) / 2)) + ((a.y + b.y) / 2)
	return Vector2(centerX, centerY)
#Checks if two line segments intersect.
func linesIntersect(line1, line2):
	#Calculate the slope and y-intercetpt of the two lines.
	var m1 = (line1[0].y - line1[1].y) / (line1[0].x - line1[1].x)
	var m2 = (line2[0].y - line2[1].y) / (line2[0].x - line2[1].x) 
	var b1 = line1[0].y - m1 * line1[0].x
	var b2 = line2[0].y - m2 * line2[0].x
	#Calculate the intersection point between two lines.
	var interX = (b2 - b1) / (m1 - m2)
	var intersection = Vector2(interX, m1 * interX + b1)
	#Checks if the intersection point is on both lines.
	return pointInRange(intersection, line1) && pointInRange(intersection, line2)
#Checks is a point is in a range of a line segment.
func pointInRange(point, line):
	#Checks if out of bound OR exactly the same point.
	if(point.x < min(line[0].x, line[1].x) || point.x > max(line[0].x, line[1].x) ||
	   point.y < min(line[0].y, line[1].y) || point.y > max(line[0].y, line[1].y) ||
	   point == line[0] || point == line[1]):
		return false
	return true