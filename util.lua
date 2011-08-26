module(..., package.seeall)

local Vector2D = require("vector2d")

function newLightning(startPointX, startPointY, targetX,targetY, parent)

	local segmentList = display.newGroup()

	if (parent ~= nil) then
		parent:insert(segmentList)
	end

	local frame = 0
	local oneCycleDone = false

	local MAIN_LIGHTNING_WIDTH = 3
	local SPLIT_LIGHTNING_WIDTH = 1
	local TOTAL_FRAMES = 20
	local TOTAL_ITERATIONS = 3
	local SPLITEND_RANDOM = 2

	local lightningUpdate

	function lightningUpdate(event)
		if (oneCycleDone or _G.currentState ~= gameStates["lightning"]) then
			for i=1,segmentList.numChildren do
				segmentList:remove(1)
			end

			Runtime:removeEventListener("enterFrame", lightningUpdate);
			_G.currentState = gameStates["inGame"]
			return
		end

		if (frame > TOTAL_FRAMES) then
			frame = 0
			oneCycleDone = true
		else
			frame = frame + 1
			--return
		end

		for i=1,segmentList.numChildren do
			segmentList[1]:removeSelf()
		end

		local segment = display.newLine(startPointX,startPointY, targetX, targetY)
		segment.x1 = startPointX
		segment.y1 = startPointY
		segment.x2 = targetX
		segment.y2 = targetY

		math.randomseed(event.time)
		local red = math.random(0,255)

		math.randomseed(event.time)
		local green = math.random(0,255)

		math.randomseed(event.time)
		local blue = math.random(0,255)

		segment:setColor(red, green, blue)
		segment.width = MAIN_LIGHTNING_WIDTH
		segmentList:insert(segment)

		offsetAmount = 40

		local segmentIndex = 1

		for i=1,TOTAL_ITERATIONS do
			for j=1,segmentList.numChildren do
				local tempSegment = segmentList[segmentIndex]

				local midPointX = tempSegment.x1 + (tempSegment.x2 - tempSegment.x1)/2
				local midPointY = tempSegment.y1 + (tempSegment.y2 - tempSegment.y1)/2

				local startPtVector = Vector2D:new(tempSegment.x1,tempSegment.y1)
				local endPtVector = Vector2D:new(tempSegment.x2,tempSegment.y2)

				local dirVector = Vector2D:Normalize(Vector2D:Sub(endPtVector,startPtVector))

				local perpendicularVector = Vector2D:Perpendicular(dirVector)

				math.randomseed(event.time * j)
				local randomOffset = math.random(-offsetAmount,offsetAmount)
				perpendicularVector:mult(randomOffset)

				midPointX2 = midPointX + perpendicularVector.x
				midPointY2 = midPointY + perpendicularVector.y

				local segment1 = display.newLine(tempSegment.x1,tempSegment.y1, midPointX2, midPointY2)
				segment1.x1 = tempSegment.x1
				segment1.y1 = tempSegment.y1
				segment1.x2 = midPointX2
				segment1.y2 = midPointY2
				segment1:setColor(red, green, blue,255)
				segment1.width = MAIN_LIGHTNING_WIDTH

				local segment2 = display.newLine(midPointX2, midPointY2, tempSegment.x2, tempSegment.y2)
				segment2.x1 = midPointX2
				segment2.y1 = midPointY2
				segment2.x2 = tempSegment.x2
				segment2.y2 = tempSegment.y2
				segment2:setColor(red, green, blue,255)
				segment2.width = MAIN_LIGHTNING_WIDTH

				tempSegment:removeSelf()
				segmentList:remove(tempSegment)
				segmentList:insert(segment1)
				segmentList:insert(segment2)

				local midPtVector = Vector2D:new(midPointX2, midPointY2)
				local direction = Vector2D:Sub(midPtVector, startPtVector)

				math.randomseed(event.time)
				local shouldSplit = math.random(SPLITEND_RANDOM)
				if (shouldSplit == 1) then
					math.randomseed(event.time)
					local randomAngle = math.random(0,0.5)
					direction:rotate(randomAngle)
					direction:mult(0.7)
					direction:add(midPtVector)

					local splitEnd = display.newLine(midPtVector.x, midPtVector.y, direction.x, direction.y);
					splitEnd.x1 = midPtVector.x
					splitEnd.y1 = midPtVector.y
					splitEnd.x2 = direction.x
					splitEnd.y2 = direction.y
					splitEnd:setColor(red, green, blue, 127)
					splitEnd.width = SPLIT_LIGHTNING_WIDTH

					segmentList:insert(splitEnd)
				end

			end
			offsetAmount = offsetAmount / 2
		end
	end

	Runtime:addEventListener("enterFrame", lightningUpdate);
end
