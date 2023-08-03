--// Packages
local Roact = require(script.Parent.Packages.roact)

function createModal()
    local Modal = Roact.Component:extend("Modal")

    function Modal:init()
        self.activated = Roact.createBinding(false)
    end

    function Modal:render()
        return Roact.createElement("Frame",{
            AnchorPoint = Vector2.new(0.5,0.5),
            Size = UDim2.new(1,-50,1,-50),
            Position = UDim2.new(0.5,0,0.5,0),
            BackgroundColor3 = 
        }, {
            Close = Roact.createElement("TextButton", {
                [Roact.Event.Activated] = function()
                    self.activated(false)
                    self.activated:map(function(e)
                        print("CHANGED",e)
                    end)
                end
            })
        })
    end

    return Modal
end

return createModal