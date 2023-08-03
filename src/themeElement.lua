--// Packages
local Roact = require(script.Parent.Packages.roact)
local ThemeContext = require(script.Parent.ThemeContext)
local StudioTheme = require(script.Parent.studioTheme)

local Elements = {}

local function Unpack(...)
    local PackedTable = {...}
	local UnpackedTable = {}

	for i,v in ipairs(PackedTable) do
        for index,value in pairs(v) do
            UnpackedTable[index] = value
        end
	end
	
	return UnpackedTable
end

function Elements.Button(props)
    local Button = Roact.Component:extend("Button")

    function Button:render()
        return Roact.createElement(Roact.createContext(ThemeContext.GetTheme(StudioTheme.GetColors())).Consumer, {
            render = function(theme)
                return Roact.createElement("TextButton", Unpack(
                    {
                        BackgroundColor3 = theme.Background,
                        TextColor3 = theme.Text
                    }, props
                ), props[Roact.Children])
            end
        })
    end

    function Button:getElementTraceback()
        print("Button")
    end

    return Button
end

function Elements.ScrollingFrame(props)
    print(props)
    local ScrollingFrame = Roact.Component:extend("ScrollingFrame")

    function ScrollingFrame:render()
        return Roact.createElement(Roact.createContext(ThemeContext.GetTheme(StudioTheme.GetColors())).Consumer, {
            render = function(theme)
                return Roact.createElement("ScrollingFrame", Unpack(
                    {
                        BackgroundColor3 = theme.ScrollBarBackground,
                        ScrollBarImageColor3 = theme.ScrollBar
                    }, props
                ), props[Roact.Children])
            end
        })
    end

    function ScrollingFrame:getElementTraceback()
        print("ScrollingFrame")
    end

    return ScrollingFrame
end

return Elements