--[[
    Studio Theme
    Made by Monnapse
--]]

local Settings = settings().Studio

local Theme = {}

local StudioTheme = Settings:GetAvailableThemes()
Theme.StudioTheme = {
    Dark = StudioTheme[2],
    Light = StudioTheme[1]
}

function Theme.GetColors(Theme: StudioTheme?)
    Theme = Theme or Settings.Theme

    local Colors = {}

    for index, ColorGuide in ipairs(Enum.StudioStyleGuideColor:GetEnumItems()) do
        local Default = Theme:GetColor(ColorGuide,Enum.StudioStyleGuideModifier.Default)
        local Disabled = Theme:GetColor(ColorGuide,Enum.StudioStyleGuideModifier.Disabled)
        local Hover = Theme:GetColor(ColorGuide,Enum.StudioStyleGuideModifier.Hover)
        local Pressed = Theme:GetColor(ColorGuide,Enum.StudioStyleGuideModifier.Pressed)
        local Selected = Theme:GetColor(ColorGuide,Enum.StudioStyleGuideModifier.Selected)

        Colors[ColorGuide.Name] = {
            Default = Default,
            Disabled = Disabled,
            Hover = Hover,
            Pressed = Pressed,
            Selected = Selected,
        }
    end
    
    return Colors
end

function Theme.ChangeTheme(Theme: StudioTheme)
    Settings.Theme = Theme
end

return Theme