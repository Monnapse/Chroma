--// Services
local TweenService = game:GetService("TweenService")

--// Packages
local Roact = require(script.Parent.Packages.roact)

local Settings = settings().Studio

--//
local StudioThemes = Settings:GetAvailableThemes()

local Buttons = Roact.Component:extend("Buttons")

local TweenInfo = TweenInfo.new(
    0.2,
    Enum.EasingStyle.Quint,
    Enum.EasingDirection.InOut
)

function Buttons:init()
    self.partRef = Roact.createRef()
    self.transparency = Roact.createBinding(0)
end

function Buttons:render()
    local buttons = {}
    for index, ColorGuide in ipairs(Enum.StudioStyleGuideColor:GetEnumItems()) do
        local DarkColor = StudioThemes[2]:GetColor(ColorGuide,Enum.StudioStyleGuideModifier.Default)
        local LightColor = StudioThemes[1]:GetColor(ColorGuide,Enum.StudioStyleGuideModifier.Default)

        buttons[index] = Roact.createElement("TextButton", {
            Size = UDim2.new(1,0,0,50),
            Text = "",
            LayoutOrder = index,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 2,
            --// Events
            [Roact.Event.Activated] = function(instance)
                TweenService:Create(instance,TweenInfo,{BackgroundTransparency = 0.8}):Play()
            end,
            [Roact.Event.MouseEnter] = function(instance)
                TweenService:Create(instance,TweenInfo,{BackgroundTransparency = 0.6}):Play()
            end,
            [Roact.Event.MouseLeave] = function(instance)
                TweenService:Create(instance,TweenInfo,{BackgroundTransparency = 1}):Play()
            end
        }, {
            Roact.createElement("Frame",{
                AnchorPoint = Vector2.new(0,0.5),
                Size = UDim2.new(0.5,0,1,0),
                Position = UDim2.new(0,0,0.5,0),
                BackgroundColor3 = DarkColor,
                BorderSizePixel = 0
            }),
            Roact.createElement("Frame",{
                AnchorPoint = Vector2.new(1,0.5),
                Size = UDim2.new(0.5,0,1,0),
                Position = UDim2.new(1,0,0.5,0),
                BackgroundColor3 = LightColor,
                BorderSizePixel = 0
            }),
            Roact.createElement("TextLabel",{
                AnchorPoint = Vector2.new(0.5,0.5),
                Position = UDim2.new(.5,0,0.5,0),
                Size = UDim2.new(0,0,0.5,0),
                BackgroundTransparency = 0.5,
                BackgroundColor3 = Color3.fromRGB(0,0,0),
                TextColor3 = Color3.fromRGB(255,255,255),
                AutomaticSize = Enum.AutomaticSize.X,
                BorderSizePixel = 0,
                Text = ColorGuide.Name,
                Name = "Label"
            },{
                Roact.createElement("UIPadding",{
                    PaddingLeft = UDim.new(0,15),
                    PaddingRight = UDim.new(0,15)
                })
            })
        })
    end
    return Roact.createFragment(buttons)
end

return Buttons