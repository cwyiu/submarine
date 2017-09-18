-- colors -----------------
yellow = Color.new(255, 255, 0)
red = Color.new(255, 0, 0)
green = Color.new(0, 255, 0)
white = Color.new(255, 255, 255)
-- images --------------------
gameBG = Image.load("images/background.PNG")
grid = Image.load("images/grid10.PNG")
moveCursor = Image.load("images/moveCursor.PNG")
explode = Image.load("images/explode.PNG")
selected = Image.load("images/selected.PNG")
-- constants -----------------
filePathMain = "./script.lua"
filePathOptions = "scripts/options.lua"
gridNum = 10
gridX = 120
gridY = 15
moveCursorX = 120
moveCursorY = 15
moveLength = 24
gridEndX =  gridX + grid:width() - moveCursor:width()
gridEndY =  gridY + grid:height() - moveCursor:height()
gameTips = "Press SQUARE to start playing."
-- flags ------------------
selectedFlags = {}
existFlags = {}
playFlag = 0



function displayInfo()
    screen:print(10, 30, "ABSOLUTE XY", red)
    screen:print(10, 40, "X: ", yellow)
    screen:print(30, 40, MoveCursor[1].x, yellow)
    screen:print(10, 50, "Y: ", yellow)
    screen:print(30, 50, MoveCursor[1].y, yellow)
    screen:print(10, 90, "-----------", green)
    screen:print(10, 110, "RELATIVE XY", red)
    screen:print(10, 120, "X: ", yellow)
    screen:print(30, 120, moveGridX, yellow)
    screen:print(10, 130, "Y: ", yellow)
    screen:print(30, 130, moveGridY, yellow)
    screen:print(90, 260, gameTips, green)
    if playFlag == 0 then 
        screen:print(118, 5, "SIZE: "..gridNum.."*"..gridNum.."    GAME STATE: READY", white)
    elseif playFlag == 1 then
        screen:print(108, 5, "SIZE: "..gridNum.."*"..gridNum.."    GAME STATE: PLAYING", white)
    end
end

function getTips()
     if playFlag == 0 then
         gameTips = "Press SQUARE to select this grids..."
     end
     if selectedFlags[moveGridX][moveGridY] ~= 1 and playFlag == 1 then
         gameTips = "Press CIRCLE to select this grids..."
     elseif  selectedFlags[moveGridX][moveGridY] == 1 and playFlag == 1 then
         gameTips = "This grid ("..moveGridX..","..moveGridY..") has already been selected."
     end
end

function control()
    if pad:up() and MoveCursor[1].y > gridY and playFlag == 1 and oldpad:up() ~= pad:up() then
	MoveCursor[1].y = MoveCursor[1].y - moveLength
    end

    if pad:down() and MoveCursor[1].y < gridEndY and playFlag == 1 and oldpad:down() ~= pad:down() then
	MoveCursor[1].y = MoveCursor[1].y + moveLength
    end

    if pad:left() and MoveCursor[1].x > gridX and playFlag == 1 and oldpad:left() ~= pad:left() then
        MoveCursor[1].x = MoveCursor[1].x - moveLength
    end

    if pad:right() and MoveCursor[1].x < gridEndX and playFlag == 1 and oldpad:right() ~= pad:right() then
        MoveCursor[1].x = MoveCursor[1].x + moveLength
    end

    if pad:cross() then
        --dofile(filePathMain)
	playFlag = 1
    end
    
    if pad:square() then
        playFlag = 1
    end

    if pad:circle()  and playFlag == 1 then
        if selectedFlags[moveGridX][moveGridY] ~= 1 then
	    selectedFlags[moveGridX][moveGridY] = 1
	    if moveGridX == 5 and moveGridX == 7 then
	        existFlags[moveGridX][moveGridX] = 1
	    end
	end
    end
    getTips()
end

function select()
    for x = 1, gridNum do
        for y = 1, gridNum do
	    if selectedFlags[x][y]==1 then
                screen:blit(gridX + moveLength * ( x - 1 ), gridY + moveLength * ( y - 1 ), selected)
	    end
	    if existFlags[x][y]==1 then
                screen:blit(gridX + moveLength * ( x - 1 ), gridY + moveLength * ( y - 1 ), explode)
	    end
        end
    end
end

function displayScene()
    screen:blit(0, 0, gameBG )
    screen:blit(gridX, gridY, grid)
    moveGridX = ( MoveCursor[1].x - 120 + moveLength ) / moveLength
    moveGridY = ( MoveCursor[1].y - 15 + moveLength ) /moveLength
    displayInfo()
end


----------------------------------------------------

for x = 1, gridNum do
    selectedFlags[x] = {}
    for y = 1, gridNum do
        selectedFlags[x][y] = 0
    end  
end

for x = 1, gridNum do
    existFlags[x] = {}
    for y = 1, gridNum do
        existFlags[x][y] = 0
    end  
end

MoveCursor = { } MoveCursor[1] = { x = moveCursorX, y = moveCursorY } 

while true do
    pad = Controls.read()
    screen:clear()
    screen:blit(0, 0, gameBG )
    screen:blit(gridX, gridY, grid)
    moveGridX = ( MoveCursor[1].x - 120 + moveLength ) / moveLength
    moveGridY = ( MoveCursor[1].y - 15 + moveLength ) / moveLength
    select()
    if playFlag == 1 then
        screen:blit(MoveCursor[1].x, MoveCursor[1].y, moveCursor)
    end
    displayInfo()
    
    control()

    screen.waitVblankStart()
    screen.flip()
    oldpad = pad
end



