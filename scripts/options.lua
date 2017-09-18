-- images --------------------
gameBG = Image.load("images/background.PNG")
optionsBG = Image.load("images/optionsBG.PNG")
-- constants -----------------
filePathMain = "./script.lua"

while true do
    pad = Controls.read()
    screen:clear()

    screen:blit(0, 0, gameBG)
    screen:blit(150, 50, optionsBG)


    if pad:cross() then
        dofile(filePathMain)
    end

    screen.waitVblankStart()
    screen.flip()
end 