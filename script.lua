--System.oaenable()

-- MAIN MENU VARIABLES DEFINE ------------------------
-- colors --------------------
white = Color.new(255, 255, 255) 
yellow = Color.new(255, 255, 0) 
blue = Color.new(0, 0, 255) 
green = Color.new(0, 255, 0)
lightBlue = Color.new(150, 180, 255)
-- images --------------------
title = Image.load("images/main.PNG")
menuCursor = Image.load("images/cursor1.PNG")
labelBG = Image.createEmpty(480,12)
--labelBG:clear(grey)
-- flags ---------------------
enterGame = false
enterOptions = false
-- constants -----------------
menuCursorX = 195
menuCursorY = { start = 182, options = 202, about = 222 }
menuX = 220
menuY = { start = 190, options = 210, about = 230 }
menuSound = Sound.load("wav/main.wav",false)
menuStates = {start = "START", options = "OPTIONS", about = "ABOUT" }
menuStateTips = {start = "Press CIRCLE to start the game", options = "Press CIRCLE to view or change current options", about = "About this game"}
menuStateTip = menuStateTips.start
menuState = menuStates.start
gameState = "READY"
Cursor = { } Cursor[1] = { x = menuCursorX, y = menuCursorY.start } 
MenuItem = { } 
MenuItem[1] = { x = menuX, y = menuY.start, state = menuStates.start, tip = menuStateTips.start, cursorY = menuCursorY.start }
MenuItem[2] = { x = menuX, y = menuY.options, state = menuStates.options, tip = menuStateTips.options, cursorY = menuCursorY.options }
MenuItem[3] = { x = menuX, y = menuY.about, state = menuStates.about, tip = menuStateTips.about, cursorY = menuCursorY.about }

count = 0

-- PLAY GAME VARIABLES DEFINE ------------------------
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
submarines = Image.load("images/submarine.PNG")
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
currentPlay = ""
currentPlayCount = 0



-- flags ------------------
selectedFlags = {}
existFlags = {}
playFlag = 0
stopFlag = 0



-- OPTIONS VARIABLES DEFINE --------------------------
-- images --------------------
gameBG = Image.load("images/background.PNG")
optionsBG = Image.load("images/optionsBG.PNG")


-- FUNCTIONS DEFINE ----------------------------------

--显示游戏信息（debug用）
function displayInfo()
    screen:print(10, 30, "ABSOLUTE XY", red)
    screen:print(10, 40, "X: ", yellow)
    screen:print(10, 50, "Y: ", yellow)
    screen:print(10, 90, "-----------", green)
    screen:print(10, 110, "RELATIVE XY", red)
    screen:print(10, 120, "X: ", yellow)
    screen:print(10, 130, "Y: ", yellow)
    screen:print(90, 260, gameTips, green)
    screen:print(108, 5, "SIZE: "..gridNum.."*"..gridNum.."    GAME STATE: "..gameState, white)
    if playFlag == 0 then 
        gameState = "READY"
    elseif playFlag == 1 then
        screen:print(30, 40, MoveCursor[1].x, yellow)
	screen:print(30, 50, MoveCursor[1].y, yellow)
	screen:print(30, 120, moveGridX, yellow)
	screen:print(30, 130, moveGridY, yellow)
        gameState = "PLAYING"
    elseif stopFlag == 1 then
        gameState = "END"
    end
end

--显示游戏信息
function getTips()
     if playFlag == 0 then
         gameTips = "Press SQUARE to start playing..."
     end
     if selectedFlags[moveGridX][moveGridY] ~= 1 and playFlag == 1 and checkBlueExist(moveGridX,moveGridY)~=true then
         gameTips = "Press CIRCLE to select this grid..."
     elseif  selectedFlags[moveGridX][moveGridY] == 1 and playFlag == 1 and checkBlueExist(moveGridX,moveGridY)~=true and checkRedExist(moveGridX,moveGridY)~=true then
         gameTips = "This grid ("..moveGridX..","..moveGridY..") has already been selected."
     elseif  selectedFlags[moveGridX][moveGridY] ~= 1 and playFlag == 1 and checkBlueExist(moveGridX,moveGridY)==true then
         gameTips = "You can never shoot your own submarine."
     elseif selectedFlags[moveGridX][moveGridY] == 1 and playFlag == 1 and checkBlueExist(moveGridX,moveGridY)==true then
         gameTips = "This part of your submarine was destroyed."
     elseif selectedFlags[moveGridX][moveGridY] == 1 and playFlag == 1 and checkRedExist(moveGridX,moveGridY)==true then
         gameTips = "This part of enemy submarine was destroyed."
     end

     if playFlag == 1 then
         if currentPlayCount%2==0 then
             currentPlay = "PLAYER"
         elseif  currentPlayCount%2==1 then
             currentPlay = "COMPUTER"
         end
	 screen:print(gridEndX+32, 30, "Now", yellow)
         screen:print(gridEndX+32, 50, currentPlay, yellow)
         screen:print(gridEndX+32, 70, "is playing...", yellow)
         screen:print(gridEndX+32, 100, "-------------", red)
	 screen:print(gridEndX+32, 120, "PLAYER: ", green)

         sinkBlue4Count = sinkBlue4[1]+sinkBlue4[2]+sinkBlue4[3]+sinkBlue4[4]
	 sinkBlue3Count = sinkBlue3[1]+sinkBlue3[2]+sinkBlue3[3]
	 sinkRed4Count = sinkRed4[1]+sinkRed4[2]+sinkRed4[3]+sinkRed4[4]
	 sinkRed3Count = sinkRed3[1]+sinkRed3[2]+sinkRed3[3]

         -- 显示双方潜艇被击中和沉没的情况
	 if sinkBlue4Count~=4 then
	     screen:print(gridEndX+32, 130, "blue4: "..sinkBlue4Count, yellow)
	 else
	     screen:print(gridEndX+32, 130, "blue4: sinked!", yellow)
	 end
	 if sinkBlue3Count~=3 then
	     screen:print(gridEndX+32, 140, "blue3: "..sinkBlue3Count, yellow)
         else
	     screen:print(gridEndX+32, 140, "blue3: sinked!", yellow)
	 end
	 if sinkBlue1~=1 then
             screen:print(gridEndX+32, 150, "blue1: "..sinkBlue1, yellow)
	 else
	     screen:print(gridEndX+32, 150, "blue1: sinked!", yellow)
	 end
	 if sinkBlue4Count + sinkBlue3Count + sinkBlue1 == 8 then
             screen:print(gridEndX+32, 160, "All sinked!", red)
	 else
	     screen:print(gridEndX+32, 160, "blue : "..sinkBlue4Count+sinkBlue3Count+sinkBlue1, red)
	 end

	 screen:print(gridEndX+32, 190, "COMPUTER: ", green)
	 if sinkRed4Count~=4 then
             screen:print(gridEndX+32, 200, "red4 : "..sinkRed4Count, yellow)
         else
             screen:print(gridEndX+32, 200, "red4 : sinked!", yellow)
	 end
	 if sinkRed3Count~=3 then
             screen:print(gridEndX+32, 210, "red3 : "..sinkRed3Count, yellow)
         else
             screen:print(gridEndX+32, 210, "red3 : sinked!", yellow)
	 end
	 if sinkRed1~=1 then
             screen:print(gridEndX+32, 220, "red1 : "..sinkRed1, yellow)
	 else 
	     screen:print(gridEndX+32, 220, "red1 : sinked!", yellow)
	 end
	 if sinkRed4Count + sinkRed3Count + sinkRed1 == 8 then
             screen:print(gridEndX+32, 230, "All sinked!", red)
	 else
	     screen:print(gridEndX+32, 230, "red  : "..sinkRed4Count+sinkRed3Count+sinkRed1, red)
	 end
     end

end

-- 游戏按键控制
function playControl()
   
    -- 方向键 上
    if pad:up() and MoveCursor[1].y > gridY and playFlag == 1 and oldpad:up() ~= pad:up() then
	MoveCursor[1].y = MoveCursor[1].y - moveLength
    end
    -- 方向键 下
    if pad:down() and MoveCursor[1].y < gridEndY and playFlag == 1 and oldpad:down() ~= pad:down() then
	MoveCursor[1].y = MoveCursor[1].y + moveLength
    end
    -- 方向键 左
    if pad:left() and MoveCursor[1].x > gridX and playFlag == 1 and oldpad:left() ~= pad:left() then
        MoveCursor[1].x = MoveCursor[1].x - moveLength
    end
    -- 方向键 右
    if pad:right() and MoveCursor[1].x < gridEndX and playFlag == 1 and oldpad:right() ~= pad:right() then
        MoveCursor[1].x = MoveCursor[1].x + moveLength
    end
    -- 交叉键
    if pad:cross() then
	enterGame = false
    end
    -- 方形键
    if pad:square() then
        playFlag = 1
    end
    -- 圆形键
    if pad:circle() and oldpad:circle()~=pad:circle() and playFlag == 1 then
        if selectedFlags[moveGridX][moveGridY] == 0 then
	    if currentPlayCount%2==0 and checkBlueExist(moveGridX,moveGridY)~=true then
	        selectedFlags[moveGridX][moveGridY] = 1
	        currentPlayCount = currentPlayCount + 1
	        screen:blit( 120+(moveGridX-1)*24, 15+(moveGridY-1)*24, explode)
	        enemyMove()
	    end
	end
    end
    getTips()
end

-- 敌人的移动
function enemyMove()
   emptyExist=false
   for x = 1, 10 do
	for y = 1,10 do
	    if selectedFlags[x][y] ~= 1 and checkRedExist(x,y)~=true then
	        emptyExist = true
	    end
	end
   end
   enemyMoveX = math.random(0,9)
   enemyMoveY = math.random(0,9)
   if selectedFlags[enemyMoveX+1][enemyMoveY+1]~=1 then
       if currentPlayCount%2==1 and checkRedExist(enemyMoveX+1,enemyMoveY+1)~=true then
           selectedFlags[enemyMoveX+1][enemyMoveY+1] = 1
           currentPlayCount = currentPlayCount + 1
           screen:blit( 120+(enemyMoveX)*24, 15+(enemyMoveY)*24, explode)
       else
	   if emptyExist == true then
	        enemyMove()
	   else
	        stopFlag = 1
	   end
       end
   else
       if emptyExist == true then
	   enemyMove()
       else
           stopFlag = 1
       end
   end
end

-- 显示格子是否已被选择的情况
function select()
    for x = 1, gridNum do
        for y = 1, gridNum do
	    if selectedFlags[x][y]==1 then
                screen:blit(gridX + moveLength * ( x - 1 ), gridY + moveLength * ( y - 1 ), selected)
	    end
        end
    end
end

-- 检测当前格子(x,y)是否存在蓝色潜艇
function checkBlueExist(x,y)
    for i = 1, 4 do
        if directionBlue4==0 then
            if x==relativeBlue4X+1 and y==relativeBlue4Y+i then
	        return true
	    end
	elseif directionBlue4==1 then
	    if x==relativeBlue4X+i and y==relativeBlue4Y+1 then
                return true
	    end
	end
    end
    for i = 1, 3 do
        if directionBlue3==0 then
            if x==relativeBlue3X+1 and y==relativeBlue3Y+i then
	        return true
	    end
	elseif directionBlue3==1 then
	    if x==relativeBlue3X+i and y==relativeBlue3Y+1 then
                return true
	    end
	end
    end
    if x==relativeBlue1X+1 and y==relativeBlue1Y+1 then
	return true
    end
    if x==relativeBlue1X+1 and y==relativeBlue1Y+1 then
        return true
    end
    return false
end

-- 检测当前格子(x,y)是否存在红色潜艇
function checkRedExist(x,y)
    for i = 1, 4 do
        if directionRed4==0 then
            if x==relativeRed4X+1 and y==relativeRed4Y+i then
	        return true
	    end
	elseif directionRed4==1 then
	    if x==relativeRed4X+i and y==relativeRed4Y+1 then
                return true
	    end
	end
    end
    for i = 1, 3 do
        if directionRed3==0 then
            if x==relativeRed3X+1 and y==relativeRed3Y+i then
	        return true
	    end
	elseif directionBlue3==1 then
	    if x==relativeRed3X+i and y==relativeRed3Y+1 then
                return true
	    end
	end
    end
    if x==relativeRed1X+1 and y==relativeRed1Y+1 then
	return true
    end
    if x==relativeRed1X+1 and y==relativeRed1Y+1 then
        return true
    end
    return false
end

-- 判断蓝色潜艇4*1被击中
function checkBlue4(x,y)
    for i = 1, 4 do
	if directionBlue4==0 then
	    if gridX + moveLength * ( x - 1 )==120+relativeBlue4X*24 and gridY + moveLength * ( y - 1 )==15+relativeBlue4Y*24+24*(i-1) then
		screen:blit(gridX + moveLength * ( x - 1 ), gridY + moveLength * ( y - 1 ), submarines, 96, 24*(i-1), 24, 24)
		--existFlags[moveGridX][moveGridY] = 1
		sinkBlue4[i] = 1
	    end
	else
	    if gridX + moveLength * ( x - 1 )==120+relativeBlue4X*24+24*(i-1) and gridY + moveLength * ( y - 1 )==15+relativeBlue4Y*24 then
		screen:blit(gridX + moveLength * ( x - 1 ), gridY + moveLength * ( y - 1 ), submarines, 96+24*(i-1), 168, 24, 24)
		--existFlags[moveGridX][moveGridY] = 1
		sinkBlue4[i] = 1
	    end
	end
    end
end

-- 判断蓝色潜艇3*1被击中
function checkBlue3(x,y)
    for i = 1, 3 do
	if directionBlue3==0 then
	    if gridX + moveLength * ( x - 1 )==120+relativeBlue3X*24 and gridY + moveLength * ( y - 1 )==15+relativeBlue3Y*24+24*(i-1) then
		screen:blit(gridX + moveLength * ( x - 1 ), gridY + moveLength * ( y - 1 ), submarines, 120, 24*i, 24, 24)
		--existFlags[moveGridX][moveGridY] = 1
		sinkBlue3[i] = 1
	    end
	else
	    if gridX + moveLength * ( x - 1 )==120+relativeBlue3X*24+24*(i-1) and gridY + moveLength * ( y - 1 )==15+relativeBlue3Y*24 then
		screen:blit(gridX + moveLength * ( x - 1 ), gridY + moveLength * ( y - 1 ), submarines, 120+24*(i-1), 144, 24, 24)
		--existFlags[moveGridX][moveGridY] = 1
		sinkBlue3[i] = 1
	    end
	 end
    end
end

-- 判断蓝色潜艇1*1被击中
function checkBlue1(x,y)
    if gridX + moveLength * ( x - 1 )==120+relativeBlue1X*24 and gridY + moveLength * ( y - 1 )==15+relativeBlue1Y*24 then
	screen:blit(gridX + moveLength * ( x - 1 ), gridY + moveLength * ( y - 1 ), submarines, 120, 0, 24, 24)
	--existFlags[moveGridX][moveGridY] = 1
	sinkBlue1 = 1
    end
end

-- 判断红色潜艇4*1被击中
function checkRed4(x,y)
    for i = 1, 4 do
	if directionRed4==0 then
	    if gridX + moveLength * ( x - 1 )==120+relativeRed4X*24 and gridY + moveLength * ( y - 1 )==15+relativeRed4Y*24+24*(i-1) then
		screen:blit(gridX + moveLength * ( x - 1 ), gridY + moveLength * ( y - 1 ), submarines, 144, 24*(i-1), 24, 24)
		--existFlags[moveGridX][moveGridY] = 1
		sinkRed4[i] = 1
	    end
	else
	    if gridX + moveLength * ( x - 1 )==120+relativeRed4X*24+24*(i-1) and gridY + moveLength * ( y - 1 )==15+relativeRed4Y*24 then
		screen:blit(gridX + moveLength * ( x - 1 ),gridY + moveLength * ( y - 1 ), submarines, 96+24*(i-1), 120 , 24, 24)
		--existFlags[moveGridX][moveGridY] = 1
		sinkRed4[i] = 1
	    end
	end
    end
end

-- 判断红色潜艇3*1被击中
function checkRed3(x,y)
    for i = 1, 3 do
        if directionRed3==0 then
	    if gridX + moveLength * ( x - 1 )==120+relativeRed3X*24 and gridY + moveLength * ( y - 1 )==15+relativeRed3Y*24+24*(i-1) then
		screen:blit(gridX + moveLength * ( x - 1 ), gridY + moveLength * ( y - 1 ), submarines, 168, 24*i, 24, 24)
		--existFlags[moveGridX][moveGridY] = 1
		sinkRed3[i] = 1
	    end
	else
	    if gridX + moveLength * ( x - 1 )==120+relativeRed3X*24+24*(i-1) and gridY + moveLength * ( y - 1 )==15+relativeRed3Y*24 then
		screen:blit(gridX + moveLength * ( x - 1 ), gridY + moveLength * ( y - 1 ), submarines, 120+24*(i-1), 96, 24, 24)
		--existFlags[moveGridX][moveGridY] = 1
		sinkRed3[i] = 1
	    end
	end
    end
end

-- 判断红色潜艇1*1被击中
function checkRed1(x,y)
    if gridX + moveLength * ( x - 1 )==120+relativeRed1X*24 and gridY + moveLength * ( y - 1 )==15+relativeRed1Y*24 then
	screen:blit(gridX + moveLength * ( x - 1 ), gridY + moveLength * ( y - 1 ), submarines, 168, 0, 24, 24)
	--existFlags[moveGridX][moveGridY] = 1
	sinkRed1 = 1
    end
end

-- 选择的某一个格子是否击中潜艇
function exploding()
    for x = 1, gridNum do
        for y = 1, gridNum do
            if selectedFlags[x][y]==1 then
	        checkRed4(x,y)
                checkRed3(x,y)
                checkRed1(x,y)
		checkBlue4(x,y)
		checkBlue3(x,y)
		checkBlue1(x,y)
	    end
        end
    end
end

-- 显示游戏主场景
function displayScene()
    screen:blit(0, 0, gameBG )
    screen:blit(gridX, gridY, grid)
    moveGridX = ( MoveCursor[1].x - 120 + moveLength ) / moveLength
    moveGridY = ( MoveCursor[1].y - 15 + moveLength ) /moveLength
end

-- 显示游戏选项
function showOptions()
    while enterOptions == true  do
        pad = Controls.read()
        screen:clear()

        screen:blit(0, 0, gameBG)
        screen:blit(150, 50, optionsBG)


        if pad:cross() then
            enterOptions = false
        end

        screen.waitVblankStart()
        screen.flip()
    end 
end

-- 随机设置蓝色4*1的方向和位置
function placeBlue4()
    --directionBlue4 = math.random(0,1)
    if directionBlue4==0 then
        relativeBlue4X = math.random(0,9)
        relativeBlue4Y = math.random(0,6)
	existFlags[relativeBlue4X+1][relativeBlue4Y+1] = 1
	existFlags[relativeBlue4X+1][relativeBlue4Y+2] = 1
	existFlags[relativeBlue4X+1][relativeBlue4Y+3] = 1
	existFlags[relativeBlue4X+1][relativeBlue4Y+4] = 1
    else
        relativeBlue4X = math.random(0,6)
        relativeBlue4Y = math.random(0,9)
	existFlags[relativeBlue4X+1][relativeBlue4Y+1] = 1
	existFlags[relativeBlue4X+2][relativeBlue4Y+1] = 1
	existFlags[relativeBlue4X+3][relativeBlue4Y+1] = 1
	existFlags[relativeBlue4X+4][relativeBlue4Y+1] = 1
    end

end

-- 随机设置蓝色3*1的方向和位置
function placeBlue3()
    --directionBlue3 = math.random(0,1)
    if directionBlue3==0 then
        relativeBlue3X = math.random(0,9)
        relativeBlue3Y = math.random(0,7)
	if existFlags[relativeBlue3X+1][relativeBlue3Y+1]==1 or existFlags[relativeBlue3X+1][relativeBlue3Y+2]==1 or existFlags[relativeBlue3X+1][relativeBlue3Y+3]==1 then
	    placeBlue3()
	end
	existFlags[relativeBlue3X+1][relativeBlue3Y+1]=1
	existFlags[relativeBlue3X+1][relativeBlue3Y+2]=1
	existFlags[relativeBlue3X+1][relativeBlue3Y+3]=1
    else
        relativeBlue3X = math.random(0,7)
        relativeBlue3Y = math.random(0,9)
	if existFlags[relativeBlue3X+1][relativeBlue3Y+1]==1 or existFlags[relativeBlue3X+2][relativeBlue3Y+1]==1 or existFlags[relativeBlue3X+3][relativeBlue3Y+1]==1 then
	    placeBlue3()
	end
	existFlags[relativeBlue3X+1][relativeBlue3Y+1]=1
	existFlags[relativeBlue3X+2][relativeBlue3Y+1]=1
	existFlags[relativeBlue3X+3][relativeBlue3Y+1]=1
    end
end

-- 随机设置蓝色1*1的方向和位置
function placeBlue1()
    relativeBlue1X = math.random(0,9)
    relativeBlue1Y = math.random(0,9)
    if existFlags[relativeBlue1X+1][relativeBlue1Y+1]==1 then
	placeBlue1()
    end
    existFlags[relativeBlue1X+1][relativeBlue1Y+1]=1
end

-- 随机设置红色4*1的方向和位置
function placeRed4()
    --directionRed4 = math.random(0,1)
    if directionRed4==0 then
        relativeRed4X = math.random(0,9)
        relativeRed4Y = math.random(0,6)
	if existFlags[relativeRed4X+1][relativeRed4Y+1]==1 or existFlags[relativeRed4X+1][relativeRed4Y+2]==1 or existFlags[relativeRed4X+1][relativeRed4Y+3]==1 or existFlags[relativeRed4X+1][relativeRed4Y+4]==1 then
	    placeRed4()
	end
	existFlags[relativeRed4X+1][relativeRed4Y+1]=1
	existFlags[relativeRed4X+1][relativeRed4Y+2]=1
	existFlags[relativeRed4X+1][relativeRed4Y+3]=1
	existFlags[relativeRed4X+1][relativeRed4Y+4]=1
    else
        relativeRed4X = math.random(0,6)
        relativeRed4Y = math.random(0,9)
	if existFlags[relativeRed4X+1][relativeRed4Y+1]==1 or existFlags[relativeRed4X+2][relativeRed4Y+1]==1 or existFlags[relativeRed4X+3][relativeRed4Y+1]==1 or existFlags[relativeRed4X+4][relativeRed4Y+1]==1 then
	    placeRed4()
	end
	existFlags[relativeRed4X+1][relativeRed4Y+1]=1
	existFlags[relativeRed4X+2][relativeRed4Y+1]=1
	existFlags[relativeRed4X+3][relativeRed4Y+1]=1
	existFlags[relativeRed4X+4][relativeRed4Y+1]=1
    end

end

-- 随机设置红色3*1的方向和位置
function placeRed3()
    --directionRed3 = math.random(0,1)
    if directionRed3==0 then
        relativeRed3X = math.random(0,9)
        relativeRed3Y = math.random(0,7)
	if existFlags[relativeRed3X+1][relativeRed3Y+1]==1 or existFlags[relativeRed3X+1][relativeRed3Y+2]==1 or existFlags[relativeRed3X+1][relativeRed3Y+3]==1 then
	    placeRed3()
	end
	existFlags[relativeRed3X+1][relativeRed3Y+1]=1
	existFlags[relativeRed3X+1][relativeRed3Y+2]=1
	existFlags[relativeRed3X+1][relativeRed3Y+3]=1
    else
        relativeRed3X = math.random(0,7)
        relativeRed3Y = math.random(0,9)
	if existFlags[relativeRed3X+1][relativeRed3Y+1]==1 or existFlags[relativeRed3X+2][relativeRed3Y+1]==1 or existFlags[relativeRed3X+3][relativeRed3Y+1]==1 then
	    placeRed3()
	end
	existFlags[relativeRed3X+1][relativeRed3Y+1]=1
	existFlags[relativeRed3X+2][relativeRed3Y+1]=1
	existFlags[relativeRed3X+3][relativeRed3Y+1]=1
    end
end

-- 随机设置红色4*1的方向和位置
function placeRed1()
    relativeRed1X = math.random(0,9)
    relativeRed1Y = math.random(0,9)
    if existFlags[relativeRed1X+1][relativeRed1Y+1]==1 then
	placeRed1()
    end
    existFlags[relativeRed1X+1][relativeRed1Y+1]=1
end

-- 显示游戏
function showGame()

    -- 二维数组，存放格子是否已被选择的情况，1为是，2为否
    for x = 1, gridNum do
        selectedFlags[x] = {}
        for y = 1, gridNum do
            selectedFlags[x][y] = 0
        end  
    end

    -- 二维数组，存放格子是否存在潜艇的情况，1为是，2为否
    for x = 1, gridNum do
        existFlags[x] = {}
        for y = 1, gridNum do
            existFlags[x][y] = 0
        end  
    end
    
    -- 潜艇被击中的情况，1为是，2为否
    sinkBlue4 = {0,0,0,0}
    sinkBlue3 = {0,0,0}
    sinkBlue1 = 0
    sinkRed4 = {0,0,0,0}
    sinkRed3 = {0,0,0}
    sinkRed1 = 0
    -- 长度大于1的潜艇被击中的计数
    sinkBlue4Count = 0
    sinkBlue3Count = 0
    sinkRed4Count = 0
    sinkRed3Count = 0

    -- 随机数设置各潜艇在格子上摆放的方向（横，竖）和位置（x,y)
    directionBlue4 = math.random(0,1)
    directionBlue3 = math.random(0,1)
    directionRed4 = math.random(0,1)
    directionRed3 = math.random(0,1)
    placeBlue4()
    placeBlue3()
    placeBlue1()
    placeRed4()
    placeRed3()
    placeRed1()

    MoveCursor = { } MoveCursor[1] = { x = moveCursorX, y = moveCursorY } 


    -- 当enterGame为true，进入游戏
    while enterGame == true do
        pad = Controls.read()
        screen:clear()
        displayScene()

        select()
        
	-- 当playFlag为1，游戏正式开始
        if playFlag == 1 then
	    --putSubmarinesRed()
	    --screen:blit(gridX, gridY, grid)
	    
	    putSubmarinesBlue()
	    exploding()
            screen:blit(MoveCursor[1].x, MoveCursor[1].y, moveCursor)
        
	end

        displayInfo()
    
        playControl()

        screen.waitVblankStart()
        screen.flip()
        oldpad = pad
    end
end

-- 放置蓝色潜艇
function putSubmarinesBlue()
    if directionBlue4 == 0 then
        screen:blit(120+relativeBlue4X*24,15+relativeBlue4Y*24,submarines,0,0,24,24)
        screen:blit(120+relativeBlue4X*24,15+relativeBlue4Y*24+24,submarines,0,24,24,24)
        screen:blit(120+relativeBlue4X*24,15+relativeBlue4Y*24+48,submarines,0,48,24,24)
        screen:blit(120+relativeBlue4X*24,15+relativeBlue4Y*24+72,submarines,0,72,24,24)
    else
        screen:blit(120+relativeBlue4X*24,15+relativeBlue4Y*24,submarines,0,96,24,24)
        screen:blit(120+relativeBlue4X*24+24,15+relativeBlue4Y*24,submarines,24,96,24,24)
        screen:blit(120+relativeBlue4X*24+48,15+relativeBlue4Y*24,submarines,48,96,24,24)
        screen:blit(120+relativeBlue4X*24+72,15+relativeBlue4Y*24,submarines,72,96,24,24)
    end
    if directionBlue3 == 0 then
        screen:blit(120+relativeBlue3X*24,15+relativeBlue3Y*24,submarines,24,24,24,24)
        screen:blit(120+relativeBlue3X*24,15+relativeBlue3Y*24+24,submarines,24,48,24,24)
        screen:blit(120+relativeBlue3X*24,15+relativeBlue3Y*24+48,submarines,24,72,24,24)
    else
        screen:blit(120+relativeBlue3X*24,15+relativeBlue3Y*24,submarines,24,120,24,24)
        screen:blit(120+relativeBlue3X*24+24,15+relativeBlue3Y*24,submarines,48,120,24,24)
        screen:blit(120+relativeBlue3X*24+48,15+relativeBlue3Y*24,submarines,72,120,24,24)    
    end
    screen:blit(120+relativeBlue1X*24,15+relativeBlue1Y*24,submarines,24,0,24,24)
end

-- 放置红色潜艇（不需要）
function putSubmarinesRed()
    if directionRed4 == 0 then
        screen:blit(120+relativeRed4X*24,15+relativeRed4Y*24,submarines,48,0,24,24)
        screen:blit(120+relativeRed4X*24,15+relativeRed4Y*24+24,submarines,48,24,24,24)
        screen:blit(120+relativeRed4X*24,15+relativeRed4Y*24+48,submarines,48,48,24,24)
        screen:blit(120+relativeRed4X*24,15+relativeRed4Y*24+72,submarines,48,72,24,24)
    else
        screen:blit(120+relativeRed4X*24,15+relativeRed4Y*24,submarines,0,144,24,24)
        screen:blit(120+relativeRed4X*24+24,15+relativeRed4Y*24,submarines,24,144,24,24)
        screen:blit(120+relativeRed4X*24+48,15+relativeRed4Y*24,submarines,48,144,24,24)
        screen:blit(120+relativeRed4X*24+72,15+relativeRed4Y*24,submarines,72,144,24,24)
    end
    if directionRed3 == 0 then
        screen:blit(120+relativeRed3X*24,15+relativeRed3Y*24,submarines,72,24,24,24)
        screen:blit(120+relativeRed3X*24,15+relativeRed3Y*24+24,submarines,72,48,24,24)
        screen:blit(120+relativeRed3X*24,15+relativeRed3Y*24+48,submarines,72,72,24,24)
    else
        screen:blit(120+relativeRed3X*24,15+relativeRed3Y*24,submarines,24,168,24,24)
        screen:blit(120+relativeRed3X*24+24,15+relativeRed3Y*24,submarines,48,168,24,24)
        screen:blit(120+relativeRed3X*24+48,15+relativeRed3Y*24,submarines,72,168,24,24)
    end

    screen:blit(120+relativeRed1X*24,15+relativeRed1Y*24,submarines,72,0,24,24)
end

-------------------------------------------------


--设置随机数种子
math.randomseed(os.time())

oldpad = Controls.read()

local sound = menuSound
voice = sound:play()



while enterGame == false and enterOptions == false do

    pad = Controls.read()
    screen:clear()
    
    screen:blit(0, 0, title)
    --screen:blit(0, 260, labelBG)
    
    for a = 1, 3 do
       if menuState == MenuItem[a].state then
           screen:print(MenuItem[a].x, MenuItem[a].y, MenuItem[a].state,yellow)
	   menuStateTip = MenuItem[a].tip
       else
           screen:print(MenuItem[a].x, MenuItem[a].y, MenuItem[a].state, white)
       end
       
    end
    
    screen:print(10, 262, menuStateTip, lightBlue)

    screen:blit(Cursor[1].x, Cursor[1].y, menuCursor)

    if pad:up() and oldpad:up() ~= pad:up() then
        for a = 1, 3 do
	    if menuState == MenuItem[a].state and a > 1 then
                menuState =  MenuItem[a-1].state
	        Cursor[1].y = MenuItem[a-1].cursorY
	    end
	end
    end

    if pad:down() and oldpad:down() ~= pad:down() then
         for a = 1, 3 do
	    if menuState == MenuItem[a].state and a < 3 then
	        if  menuState == MenuItem[a].state then
                    menuState =  MenuItem[a+1].state
	            Cursor[1].y = MenuItem[a+1].cursorY
		end
	    end
        end
    end

    if pad:circle() then
        if menuState == MenuItem[1].state then 
	    enterGame = true
	    gameState = "PLAYING"
	    showGame()
        elseif menuState == MenuItem[2].state then 
            enterOptions = true
            showOptions()
        end
    end

    screen.waitVblankStart()
    screen.flip()
    oldpad = pad
end 