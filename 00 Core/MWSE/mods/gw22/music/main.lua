-- file paths are relative to 'Data Files\\Music\\'

local SILENCE = "gw22\\special\\silence.mp3"
local SITUATION = tes3.musicSituation.explore

local TRACKS = {
    "gw22\\saturnalia-title.mp3",
    "gw22\\saturnalia-dream.mp3",
    "gw22\\saturnalia-explore2.mp3",
}

local function isSeydaNeenCell(cell)
    return (cell and cell.editorName or ""):startswith("Seyda Neen")
end

local function onCellChanged(e)
    local isSeydaNeen = isSeydaNeenCell(e.cell)
    local wasSeydaNeen = isSeydaNeenCell(e.previousCell)

    if isSeydaNeen and not wasSeydaNeen then
        tes3.streamMusic({path = table.choice(TRACKS), situation = SITUATION})
    elseif wasSeydaNeen and not isSeydaNeen then
        tes3.streamMusic({path = SILENCE})
    end
end
event.register("cellChanged", onCellChanged)

local function onMusicSelectTrack(e)
    if isSeydaNeenCell(tes3.player.cell) then
        e.music = table.choice(TRACKS)
        e.situation = SITUATION
        return false
    end
end
event.register("musicSelectTrack", onMusicSelectTrack, { priority = 360 })

local function onMainMenu()
    tes3.streamMusic({path = "gw22\\saturnalia-title.mp3", situation = tes3.musicSituation.uninterruptible})
end
event.register (tes3.event.uiActivated, onMainMenu, { filter = "MenuOptions", doOnce = true, })

event.register("initialized", function()
    mwse.overrideScript("gw22_Music_s", function()
    end)
end)
