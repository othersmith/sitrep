
local LAM = LibStub:GetLibrary("LibAddonMenu-2.0")


function CreateSettingsPanel(savedVariables) 
    local panelData = {
        type = "panel",
        name = "SitRep",
        author = "Mishima",
        version = "1.2.1",
    }
    LAM:RegisterAddonPanel("SitRepOptions", panelData)
    local optionsData = {

         [1] = {
              type = "slider",
              name = EsoStrings[SR_TIME_TO_DISPLAY_NAME],
              tooltip = EsoStrings[SR_TIME_TO_DISPLAY_TIP],
              min = 1,
              max = 20,
              getFunc = function() return savedVariables.timeToDisplay/1000 end,
              setFunc = function(value) savedVariables.timeToDisplay = value * 1000 end,
         },
         [2] = {
              type = "slider",
              name =  EsoStrings[SR_DIFF_TIME_ALLOWED_NAME],
              tooltip = EsoStrings[SR_DIFF_TIME_ALLOWED_TIP],
              min = 0,
              max = (60*12),
              step = 15,
              getFunc = function() return savedVariables.diffTimeAllowed/60 end,
              setFunc = function(value) savedVariables.diffTimeAllowed = value * 60 end,
         },
         [3] = {
              type = "slider",
              name = EsoStrings[SR_ARMOR_THRESHOLD_NAME],
              tooltip = EsoStrings[SR_ARMOR_THRESHOLD_TIP],
              min = 1,
              max = 100,
              getFunc = function() return savedVariables.armorThreshold end,
              setFunc = function(value) savedVariables.armorThreshold = value end,
         },
         [4] = {
              type = "slider",
              name = EsoStrings[SR_WEAPON_THRESHOLD_NAME],
              tooltip = EsoStrings[SR_WEAPON_THRESHOLD_TIP],
              min = 1,
              max = 100,
              getFunc = function() return savedVariables.weaponThreshold end,
              setFunc = function(value) savedVariables.weaponThreshold = value end,
         },
         [5] = {
              type = "slider",
              name = EsoStrings[SR_ATTRIBUTES_THRESHOLD_NAME],
              tooltip = EsoStrings[SR_ATTRIBUTES_THRESHOLD_TIP],
              min = 1,
              max = 20,
              getFunc = function() return savedVariables.attributesThreshold end,
              setFunc = function(value) savedVariables.attributesThreshold = value end,
         },

    }

    LAM:RegisterOptionControls("SitRepOptions", optionsData)

end