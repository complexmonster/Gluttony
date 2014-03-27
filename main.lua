require 'math'

function love.load ()
	setup()
end

function love.draw ()
	--love.graphics.draw(player.img, player.x, player.y)
	love.graphics.setColor(255, 255, 255, 5)
	--love.graphics.print(GameTimer.getSeconds())
	font = love.graphics.newFont(250)
	smallFont = love.graphics.newFont(10)
	love.graphics.setFont(font)
	love.graphics.printf(math.floor(GameTimer.getRemaining()+0.5), 0,150 , width, "center")
	
	killObjects ()
	drawObjects()

	love.graphics.setColor(mainColor)
	love.graphics.rectangle("fill", 0,0,10,10)
	love.graphics.setFont(smallFont)
	love.graphics.print(cake, 15, 0)
	
	love.graphics.setColor(player.c)
	love.graphics.circle( "fill", player.x, player.y, player.size, 25 )
	love.graphics.setColor(255, 255, 255, 200)
	love.graphics.circle( "line", player.x, player.y, player.vacuumSize, 25 )	
end

function drawObjects ()
	if dots then
		for i,d in ipairs(dots) do
		  	love.graphics.setColor(d.c)
		  	if vacuum == true and dist(d.x, d.y, player.x, player.y) < player.vacuumSize then
			  	d.x = lerp( d.x, player.x, d.speed )
			  	d.y = lerp( d.y, player.y, d.speed )
			  	if d.speed < 0.9 then d.speed = d.speed + 0.02 end
			end
	      	love.graphics.circle( "fill", d.x, d.y, d.size, 25 )

	      	if vacuum == true and dist(d.x, d.y, player.x, player.y) < player.size then 
	      		d.kill = true

	      		local points = 0

	      		if player.size > d.size then
		      		if player.size < player.maxSize then player.size = player.size + d.size / 10 end

		      		player.vacuumStrength = player.vacuumStrength + ( 1 + player.size / 100 )
		      		player.c = d.c

		      		if d.c == mainColor then
		      			-- many points, no slow, much awesome
		      			cake = cake + d.size
		      		else
		      			-- not many points, slow, not ok
		      			cake = cake + dot.minSize
		      			player.speed = player.maxSpeed - (player.maxSpeed * (player.size / player.maxSize / 10 ))
		      		end
	      		end
	      	end
	    end
	end
end

function killObjects ()
	if dots then
	  for i,d in ipairs(dots) do
	  	if d.kill == true then 
	  		table.remove(dots, i) 
	  	end
      end
	end
end

function love.update( dt )
	movePlayer()
	restorePlayerColor ()

	if love.keyboard.isDown(" ") then 
		vacuum = true
		if player.vacuumSize < player.vacuumStrength then player.vacuumSize = player.vacuumSize + 2 end
	else 
		vacuum = false
		if player.vacuumSize > player.size + 1 then player.vacuumSize = player.vacuumSize - 2 end
	end

	if SpawnTimer.isDone() then 
		createDot ()
		SpawnTimer:start( love.math.random(.5,1.5) )
	end
end

function movePlayer ()
	if love.keyboard.isDown("left") then
		if player.xVel > 0 then player.xVel = 0 end
    	player.xVel = player.xVel - player.speed
    elseif love.keyboard.isDown("right") then
    	if player.xVel < 0 then player.xVel = 0 end
      	player.xVel = player.xVel + player.speed
    end
   	if love.keyboard.isDown("up") then
    	if player.yVel > 0 then player.yVel = 0 end
      	player.yVel = player.yVel - player.speed
   	elseif love.keyboard.isDown("down") then
    	if player.yVel < 0 then player.yVel = 0 end
      	player.yVel = player.yVel + player.speed
   	end 


   	player.x = player.x + player.xVel
	player.y = player.y + player.yVel
   	player.xVel = player.xVel * 0.75
   	player.yVel = player.yVel * 0.75
end

function createObjects ()
	dots = {}

	player = {
		x = width/2,
		y = height-50,
		xVel = 0,
		yVel = 0,
		speed = .75,
		maxSpeed = .75,
		size = 5,
		maxSize = 50,
		vacuumStrength = 6,
		vacuumSize = 6,
		--r = 255, g = 255, b = 255,
		c = c[5],
	}

	dot = {
		x = love.math.random (0, width),
		y = love.math.random (0, height),
		minSize = 2,
		maxSize = 5,
		speed = 0.1
	}


	generateDots ()
end

function generateDots ()
	for i=1,10 do
		createDot ()
	end
end

function createDot ()
	table.insert (dots, { x = love.math.random (0, width), y = love.math.random (0, height), size = love.math.random( dot.minSize, dot.maxSize ), speed = dot.speed, c = c[love.math.random(1,4)] })
end

function restorePlayerColor () 
	--if player.r < 255 then player.r = player.r + 1 else player.r = 255 end
	--if player.g < 255 then player.g = player.g + 1 else player.g = 255 end
	--if player.b < 255 then player.b = player.b + 1 else player.b = 255 end
end

function setup ()
	-- setup all variables and functions from load()

	vacuum = false
	gameOver = false
	cake = 0

	c = { }

	c[0] = {43,53,56,255} -- grey
	c[1] = {255,59,119,255} -- pink
	c[2] = {205,255,0,255} -- lime
	c[3] = {0,170,255,255} -- blue
	c[4] = {255, 155, 35, 255} -- orange
	c[5] = {255, 255, 255, 255} -- white

	mainColor = c[love.math.random(1,4)]

	love.graphics.setBackgroundColor(c[0])

	width = love.window.getWidth()
	height = love.window.getHeight()

	createObjects()

	SpawnTimer:start( 1 )
	GameTimer:start( 30 )
end

-- Useful shit
function lerp(a,b,t) return a+(b-a)*t end
function dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end


-- Timer class or table or whatever they call it
SpawnTimer = {
	startTime = 0,
	duration = 5,
}

function SpawnTimer:start ( d )
	SpawnTimer.duration = d
	SpawnTimer.startTime = love.timer.getTime() 
	print(d)
end

function SpawnTimer.isDone ()
	if love.timer.getTime() - SpawnTimer.startTime > SpawnTimer.duration then
		return true
	else return false end 
end

-- Timer class or table or whatever they call it
GameTimer = {
	startTime = 0,
	duration = 30,
}

function GameTimer:start ( d )
	GameTimer.duration = d
	GameTimer.startTime = love.timer.getTime() 
	print(d)
end

function GameTimer.isDone ()
	if love.timer.getTime() - GameTimer.startTime > GameTimer.duration then
		return true
	else return false end 
end

function GameTimer.getSeconds ()
	return love.timer.getTime() - GameTimer.startTime
end

function GameTimer.getRemaining ()
	r = GameTimer.duration - (love.timer.getTime() - GameTimer.startTime)
	if r > 0 then return r else return 0 end 
end