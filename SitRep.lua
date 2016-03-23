local savedVariables
local defaults = {
   lastVisit = 0,               -- integer in seconds
   diffTimeAllowed      = 3600,        -- integer in minutes
   armorThreshold       = 30,       -- integer as a percentage
   weaponThreshold      = 30,       -- integer as a percentage
   timeToDisplay        = 7000,     -- interger as time in milliseconds
   attributesThreshold  = 3       -- integer as number of unspent attribute points
}

local function OnLoad(eventCode, name)

    if name ~= "SitRep" then return end
    EVENT_MANAGER:UnregisterForEvent("SitRep", EVENT_ADD_ON_LOADED)
    savedVariables = ZO_SavedVars:New("SitRep_SavedVariables", 4, nil, defaults)
    CreateSettingsPanel(savedVariables)

end

local function PlayerActivated(eventCode)

    local currentTimeStamp = GetTimeStamp()
    local timeDiff = GetDiffBetweenTimeStamps(currentTimeStamp, savedVariables.lastVisit)
    --d("time diff: " .. timeDiff .. " interval in minutes: " .. savedVariables.diffTimeAllowed)

    if (timeDiff > (savedVariables.diffTimeAllowed)) then
        savedVariables.lastVisit = currentTimeStamp
        generate_sitrep(savedVariables)
    end
end



function sitRepClose()
    if (SitRep:IsControlHidden() == false) then
        SitRep:ToggleHidden()
    end
end


EVENT_MANAGER:RegisterForEvent("SitRepPlayerActivated", EVENT_PLAYER_ACTIVATED, PlayerActivated)
EVENT_MANAGER:RegisterForEvent("SitRepOnLoad", EVENT_ADD_ON_LOADED, OnLoad)
SLASH_COMMANDS["/sitrep"] = function (extra)
    --d("generate sitrep")
    generate_sitrep(savedVariables)
    SitRep:ToggleHidden()
end