--[[
	Chroma Plugin
	Made By Monnapse
--]]

--// Packages
local RoactRedux = require(script.Parent.Packages.roactRodux)
local Roact = require(script.Parent.Packages.roact)
local Theme = require(script.Parent.ThemeContext)
local Store = Theme.Store
local TopBar = require(script.Parent.bar)
local List = require(script.Parent.list)
local ThemeContext = require(script.Parent.ThemeContext)
local StudioTheme = require(script.Parent.studioTheme)
--local Modal = require(script.Parent.modal)

local Settings = settings().Studio

local Name = "Chroma Theme Colors"
local Id = "Chroma"
local ShortDescription = "Chroma Colors"
local Icon = "rbxassetid://"

local ToolBar = plugin:CreateToolbar(Name)

local PluginButton = ToolBar:CreateButton(Id, ShortDescription, Icon)

PluginButton.ClickableWhenViewportHidden = true

-- Create new "DockWidgetPluginGuiInfo" object
local widgetInfo = DockWidgetPluginGuiInfo.new(
    Enum.InitialDockState.Float, -- Widget will be initialized in floating panel
    false, -- Widget will be initially enabled
    false, -- Don't override the previous enabled state
    200, -- Default width of the floating window
    300, -- Default height of the floating window
    150, -- Minimum width of the floating window
    150 -- Minimum height of the floating window
)

-- Create new widget GUI
local Widget = plugin:CreateDockWidgetPluginGui("Chroma", widgetInfo)
Widget.Title = "Chroma"

local function InitializePlugin()
    Widget.Enabled = not Widget.Enabled
end

local function Initialize()
    --List = RoactRedux.connect(
    --function(state, props)
    --    return state
    --end,
    --function(dispatch)
    --    return {}
    --end
    --)(List)

    local function UI(props)
        local ThemeContext = props.ThemeContext
        print(ThemeContext)

        local UI = Roact.Component:extend("UI")

        function UI:render()
            return Roact.createElement("Frame",{
                AnchorPoint = Vector2.new(0,0),
                Position = UDim2.new(0,0,0,0),
                Size = UDim2.new(1,0,1,0),
                BackgroundTransparency = 1
            },{
                TopBar = Roact.createElement(TopBar),
                List = Roact.createElement(List)
                --Roact.createElement(Modal())s
            })
        end
        
        function UI:getElementTraceback()
            print("UI")
        end

        return UI
    end
    
    UI = RoactRedux.connect(
        function(state, props)
            return state
        end,
        function(dispatch)
            return {
                type = "changeTheme",
                ThemeContext = Roact.createContext(ThemeContext.GetTheme(StudioTheme.GetColors())).Consumer
            }
        end
    )(UI)

    local Tree =  Roact.createElement("Frame", {
        AnchorPoint = Vector2.new(0,0),
        Position = UDim2.new(0,0,0,0),
        Size = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1
    }, {
        Frame = Roact.createElement(UI)
    })

    local RoactTree = Roact.createElement(RoactRedux.StoreProvider, {
        store = Store
    }, {
        Tree = Roact.createElement(Tree)
    })

    local handle = Roact.mount(RoactTree, Widget, "Chroma Interface")

    plugin.Unloading:Connect(function()
        Roact.unmount(handle)
    end)
    
    Settings.ThemeChanged:Connect(function()
        Store:dispatch({
            type = "changeTheme",
            ThemeContext = Theme.NewContext()
        })
    end)
end

Initialize()

PluginButton.Click:Connect(InitializePlugin)