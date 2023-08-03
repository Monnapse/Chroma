--// Packages
local Roact = require(script.Parent.Packages.roact)
local Buttons = require(script.Parent.buttons)
local ThemeElements = require(script.Parent.themeElement)

function List()
    local list = Roact.Component:extend("List")
    
    function list:render()
        return Roact.createElement(ThemeElements.ScrollingFrame,{
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            AnchorPoint = Vector2.new(0.5,1),
            Size = UDim2.new(1,0,1,-50),
            Position = UDim2.new(0.5,0,1,0),
            --BackgroundTransparency = 1,
            BottomImage = "",
            TopImage = "",
            BorderSizePixel = 0,
            --[Roact.Children] = {
            --    UIListLayout = Roact.createElement("UIListLayout", {
            --        SortOrder = Enum.SortOrder.LayoutOrder
            --    }),
            --    Buttons = Roact.createElement(Buttons)
            --}
        })
    end

    return list
end

return List