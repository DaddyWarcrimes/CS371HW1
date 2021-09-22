local balls={}
local ballCount = 0
local score = display.newText("Balls: 0",32,-29)
local function stopper(event)
	if event.target.stopped == false
		then
			event.target.stopped = true
		else
			event.target.stopped = false
		end
		return true;
	end

local function remover(event)
	event.target.delete = true
	return true;
end

local function createBall(event)
	local group = display.newGroup()
	group.type = math.random(1,2) -- Assign as stoppable or removable ball
	
	group.deltaX = math.random()*10 - 5
	group.deltaY = math.random()*10 - 5 
	rad = math.random(30,60)  -- ball radius
	group.rad = rad
	--Start position based on tap location
--	print(rad,event.x,display.contentWidth,event.y,display.contentHeight)
	startx = 0
	starty = 0
	if event.x < rad
		then
			startx = rad
		elseif event.x + rad > display.contentWidth
		then
			startx = display.contentWidth - rad
		else 
			startx = event.x
	end
	if event.y < rad
		then
			starty = rad
		elseif event.y + rad > display.contentHeight
		then
			starty = display.contentHeight - rad
		else
			starty = event.y
	end
	group.x=startx
	group.y=starty

	local ball=display.newCircle(0, 0, rad)
	group:insert(ball)

	--color
	local cA = math.random()
	local cB = math.random()
	local cC = math.random()
--[[ --test for specific color values:w
--
	local cA = .55
	local cB = .55
	local cC = .55
	]]	
	local cD = 0
	local cE = 0
	local cF = 0

	if cA > 0.4 and cA < 0.6
		then
			cD = math.abs(0.5 - cA)
		else
			cD = 1 - cA
		end
	if cB > 0.4 and cB < 0.6
		then
			cE = math.abs(0.5 - cB)
		else
			cE = 1 - cB
		end
	if cC > 0.4 and cB < 0.6
		then
			cF = math.abs(0.5 - cC)
		else
			cF = 1 - cC
		end

	ball:setFillColor(cA,cB,cC)
	ball.strokeWidth = rad/9
	ball:setStrokeColor(cD,cE,cF)
	-- Set text color to contrast with ball
	local letter = display.newText(group,"F",0,0,native.systemFont, rad)
	letter:setFillColor(cD,cE,cF)

	--Stoppable ball
	if group.type == 2
		then
			ball.stopped = false
			ball:addEventListener("tap",stopper)
			letter.text = "S"
		else
			ball.stopped = false
			ball.delete= false
			ball:addEventListener("tap",remover)
			letter.text = "R"
		end
		
	table.insert(balls,ball)
	ballCount = ballCount + 1
	score.text = "Balls: " .. ballCount
end

local function update()
	for index, ball in pairs(balls) do
		if ball.stopped == false or ball.delete == false
			then
				if ball.parent.x + ball.parent.deltaX < ball.parent.rad or ball.parent.x + ball.parent.deltaX > display.contentWidth - ball.parent.rad
					then
						ball.parent.deltaX = -ball.parent.deltaX
					end
				if ball.parent.y + ball.parent.deltaY < ball.parent.rad or ball.parent.y + ball.parent.deltaY > display.contentHeight - ball.parent.rad
					then 
						ball.parent.deltaY = -ball.parent.deltaY
					end
				ball.parent.x = ball.parent.x + ball.parent.deltaX
				ball.parent.y = ball.parent.y + ball.parent.deltaY
		end
		if ball.delete == true
			then
				table.remove(balls,index)
				ball.parent:remove(2)
				ball.parent:removeSelf()
				ball:removeSelf()
				ballCount = ballCount - 1
				score.text = "Balls: " .. ballCount
		end
	end
end
timer.performWithDelay(10,update,0)
Runtime:addEventListener("tap", createBall)

