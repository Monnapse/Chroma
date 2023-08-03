--// Packages
local Rodux = require(script.Parent.Packages.rodux)
local Roact = require(script.Parent.Packages.roact)
local StudioTheme = require(script.Parent.studioTheme)

local Settings = settings().Studio

local Theme = {}

function Theme.GetTheme(Colors)

    return {
        Background = Colors.MainBackground.Default,
        Text = Colors.MainText.Default,
        Border = Colors.Border.Default,
    
        ScrollBar = Colors.ScrollBar.Default,
        ScrollBarBackground = Colors.ScrollBarBackground.Default,
    }
end

Theme.Store = Rodux.Store.new(function(state, action)
    state = state or {
        ThemeContext = Theme.ThemeContext
    }

    if action.type == "changeTheme" then
        state.ThemeContext = action.ThemeContext
    end
    
    return state
end)

--[[
Settings.ThemeChanged:Connect(function()
    print("THEME CHANGED")
    --ThemeContext:update(GetTheme(StudioTheme.GetColors(Settings.Theme)))
end)
]]

--return ThemeContext

return Theme