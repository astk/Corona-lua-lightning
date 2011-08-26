local util = require("util")

_W = display.contentWidth
_H = display.contentHeight

gameStates = { menu = 0, pause = 1, gameOver = 2, levelSelection = 3, lightning = 4, inGame = 5};
currentState = gameStates["menu"];

function onTouch(event)
	if (event.phase == "began") then
		print("creating lightning...")
		util.newLightning(_W/2,_H/2,event.x,event.y)
		_G.currentState = gameStates["lightning"]
	end
end

Runtime:addEventListener("touch", onTouch)
