extends Node 

var id
var rect
var midpoint

func init(id, rect):
	self.id = id
	self.rect = rect
	self.midpoint = Vector2(self.rect.pos.x + self.rect.size.x / 2, self.rect.pos.y + self.rect.size.y / 2)

#Checks if collides with another Rect2.
func collidesWith(other):
	return !(self.rect.end.x < other.pos.x || self.rect.pos.x > other.end.x || self.rect.end.y < other.pos.y || self.rect.pos.y > other.end.y)

func getRect(): return self.rect
func getId(): return self.id
func getMidpoint(): return self.midpoint