--// Services
local TweenService = game:GetService("TweenService")

--// Packages
local Roact = require(script.Parent.Packages.roact)

local Settings = settings().Studio

local StudioThemes = Settings:GetAvailableThemes()

local DarkTheme = StudioThemes[2]
local LightTheme = StudioThemes[1]

local TweenInfo = TweenInfo.new(
    0.2,
    Enum.EasingStyle.Quint,
    Enum.EasingDirection.InOut
)

local TopBar = Roact.Component:extend("TopBar")

local function createButton(Text, Theme, X)
    local Button = Roact.Component:extend("Button")

    function Button:render()
        return Roact.createElement("TextButton", {
            Size = UDim2.new(0.5,0,1,0),
            AnchorPoint = Vector2.new(X,0.5),
            Position = UDim2.new(X,0,0.5,0),
            BackgroundColor3 = Theme:GetColor(Enum.StudioStyleGuideColor.Titlebar,Enum.StudioStyleGuideModifier.Default),
            TextColor3 = Theme:GetColor(Enum.StudioStyleGuideColor.MainText,Enum.StudioStyleGuideModifier.Default),
            AutoButtonColor = false,
            Text = Text,

            --// Events
            [Roact.Event.Activated] = function(instance)
                TweenService:Create(instance,TweenInfo,{BackgroundColor3 = Theme:GetColor(Enum.StudioStyleGuideColor.Button,Enum.StudioStyleGuideModifier.Pressed)}):Play()
                Settings.Theme = Theme
            end,
            [Roact.Event.MouseEnter] = function(instance)
                TweenService:Create(instance,TweenInfo,{BackgroundColor3 = Theme:GetColor(Enum.StudioStyleGuideColor.Button,Enum.StudioStyleGuideModifier.Hover)}):Play()
            end,
            [Roact.Event.MouseLeave] = function(instance)
                TweenService:Create(instance,TweenInfo,{BackgroundColor3 = Theme:GetColor(Enum.StudioStyleGuideColor.Button,Enum.StudioStyleGuideModifier.Default)}):Play()
            end
        },{
            Roact.createElement("UIStroke",{
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Theme:GetColor(Enum.StudioStyleGuideColor.Border,Enum.StudioStyleGuideModifier.Default)
            })
        })
    end

    return Button
end

function TopBar:render()
    return Roact.createElement("Frame", {
        AnchorPoint = Vector2.new(0.5,0),
        Size = UDim2.new(1,0,0,50),
        Position = UDim2.new(0.5,0,0,0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0
    },{
        Roact.createElement(createButton("Dark Theme", DarkTheme, 0)),
        Roact.createElement(createButton("Light Theme", LightTheme, 1))
    })
end

function TopBar:getElementTraceback()
    print("Bar")
end

return TopBar