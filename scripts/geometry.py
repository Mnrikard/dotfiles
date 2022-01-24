def drawStar(points,length):
	angle = 180-(180/points)	
	import turtle
	turtle.begin_fill()
	turtle.clear()
	turtle.pendown()
	for i in range(0,points):
		turtle.forward(length)
		turtle.right(angle)
